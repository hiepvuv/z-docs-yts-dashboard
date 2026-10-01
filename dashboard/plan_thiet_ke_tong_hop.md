# Plan: Thiết kế bảng đích + SQL select + pipeline tổng hợp

## Mục tiêu

- Mỗi đợt user chỉ file Excel trong `autogen/`. Cột nguồn lấy từ schema `emr_datalake` qua connection cùng tên. Kết quả là `dich.sql`, hai cột kết quả trên Excel, và một DAG mới cho nhóm.
- Quyết định gộp hay tách bảng trước khi viết SQL, theo grain và nguồn, không gộp cho đủ ít bảng.

## Phạm vi / ngoài phạm vi

- In: quy trình một đợt tổng hợp; tiêu chí gộp/tách; bộ file đầu ra; thứ tự làm sau khi user chỉ file Excel.
- Out: chưa có đợt cụ thể nên không viết DDL, không sửa DAG, không đụng `emr_web` / `cdc-web`.
- Đợt thuốc đã xong (`table_merged.md`, `sql_select/dashboard_drugs_2509.sql`, `pipeline/dashboard_pipelines/medical`) chỉ là mẫu, không làm lại.

## Source & stack

- Source: `pipeline`
- Stack: Python, Airflow, MySQL. Nguồn `emr_datalake`, đích `emr_datawarehouse`. Hai server, không JOIN xuyên DB.
- Mẫu: `pipeline/dashboard_pipelines/base_pipeline.py`, `pipeline/dashboard_pipelines/medical/`, `pipeline/emr_dashboard_medical_master_dag.py`.
- Package import trên Airflow là `emr_dashboard_piplines` (folder repo tên `dashboard_pipelines`).

## Đầu vào cố định

- Nguồn đọc từ connection Airflow `emr_datalake`, schema `emr_datalake`. Cột, kiểu, khóa, index lấy bằng `information_schema` trên connection đó. Không dùng `nguon.sql` làm nguồn sự thật.
- Bảng nguồn chưa có trong `z_docs/dashboard/nguon.sql` thì xuất `SHOW CREATE TABLE` từ connection đó và nối vào cuối file. Bảng đã có trong file thì giữ nguyên, không ghi đè. File này để đính kèm khi đánh giá source.
- Yêu cầu nằm ở `z_docs/dashboard/autogen/`. User chỉ tên file Excel của đợt. Đọc đúng file đó.
- File mô tả luôn có các cột: `Mã chức năng`, `Tên chức năng`, `Nguồn`, `Đích mong muốn`, `Bảng tổng hợp`, `SQL select dashboard`.
- Hai cột `Bảng tổng hợp` và `SQL select dashboard` để trống lúc giao. Sau khi chốt thiết kế thì ghi kết quả vào đúng hai cột đó.
- Thiếu file Excel được chỉ, hoặc thiếu cột, thì dừng. Không đoán cột nguồn.

## Tiêu chí gộp hoặc tách

Gộp vào **một** fact khi cùng lúc:

- Cùng tập bảng nguồn và cùng kiểu JOIN.
- Cùng grain (ví dụ cơ sở + ngày + thuốc).
- Cùng công thức cộng (`SUM` số lượng, tiền). Các màn chỉ khác `GROUP BY` lúc đọc dashboard.

Tách bảng khi có một điểm sau:

- Grain khác (ngày so với tháng/năm, hoặc mẫu số lấy từ bảng khác như ngày giường).
- JOIN khác làm rơi hoặc nhân dòng (chỉ kháng sinh, có khoa, có loại điều trị).
- Khóa xóa-ghi khác (ngày so với năm, so với tháng).

Không thêm cột `loai_bao_cao` để nhét nhiều grain vào một bảng.

## File sẽ đụng (mỗi đợt, dự kiến)

| File | Việc |
|---|---|
| Connection `emr_datalake` | Chỉ đọc schema `emr_datalake` (`information_schema` + bảng nghiệp vụ) |
| `z_docs/dashboard/nguon.sql` | Nối DDL bảng nguồn mới (`SHOW CREATE TABLE`). Không ghi đè bảng đã có |
| `z_docs/dashboard/autogen/<file user chỉ>.xlsx` | Đọc yêu cầu. Ghi `Bảng tổng hợp` và `SQL select dashboard` |
| `pipeline/sql/DDL_cac_bang_dich.sql` | `CREATE` fact + `_stg`. Tên fact luôn `emr_db_...`. Không để bảng key-pair trong file này |
| `pipeline/sql/DDL_cac_bang_key_pair.sql` | Bảng khóa, bảng đổi và bảng cặp của mọi nhóm |
| `z_docs/dashboard/dich.sql` | Bản fact cùng nội dung phần bệnh / lượt khám / cận lâm sàng, không gồm key-pair |
| `pipeline/dashboard_pipelines/<nhom>/*.py` | Job load/merge của nhóm, bám `BasePipeline` |
| `pipeline/emr_dashboard_<nhom>_master_dag.py` | Một DAG mới cho nhóm. Không gắn job vào DAG thuốc |

## Pattern bám theo

- File mẫu: `pipeline/dashboard_pipelines/medical/emr_db_tong_hop_thuoc.py` (grain ngày), `emr_db_tong_hop_ddd_khoa.py` (grain năm).
- Fact: tên `emr_db_...`, charset `utf8mb3`, không UNIQUE, xóa theo khóa grain rồi `INSERT` từ `_stg`. DDL fact nằm trong `pipeline/sql/DDL_cac_bang_dich.sql` và `z_docs/dashboard/dich.sql`.
- Mỗi nhóm có bảng key-pair trên đích, cùng kiểu thuốc: bảng khóa (`emr_db_..._key`), bảng đổi của lần chạy (`_chg`), bảng cặp cần tính lại. `prepare` trước các job, `commit` sau khi mọi job của DAG thành công. Nguồn không lưu giá trị cũ của khóa.
- Mọi bảng đích bắt buộc có đủ cột chung, cùng kiểu như fact thuốc: `thoi_gian`, `ma_tinh`, `ten_tinh`, `ma_xa`, `ten_xa`, `ma_csyt`, `ten_csyt`, `tuyen_csyt`, `hang_csyt`, `ma_chi_tieu_bieu_do`, `ma_chi_tieu_canh_bao`, `ten_chi_tieu`, `ngay`, `thang`, `nam`.
- `ma_tinh`, `ten_tinh`, `ma_xa`, `ten_xa`, `ten_csyt`, `tuyen_csyt`, `hang_csyt` và ba cột chỉ tiêu để `NULL` khi chưa có nguồn join. `ma_csyt` vẫn ghi mã cơ sở lấy từ nguồn.
- Độ dài cột chữ khớp cột đã đọc trên schema `emr_datalake`, không nới tùy ý.
- Câu SQL pipeline ghi schema nguồn tường minh: `emr_datalake.<bảng>`, cùng kiểu `pipeline/dashboard_pipelines/disease/`.
- Số lặp trên mọi dòng của một nhóm (ngày giường DDD) ghi trong comment bảng. SQL select lấy `MAX`, không `SUM`.
- Dòng tắt: cộng khi `is_delete = 0` và `is_active = 1`. Dòng tắt vẫn kéo khóa để xóa số cũ.
- Cửa sổ: `update_date >= from` và `< to`. `to` không thuộc cửa sổ.

## API / quyền / DB

- Không API mới.
- User chạy `pipeline/sql/DDL_cac_bang_dich.sql` rồi `pipeline/sql/DDL_cac_bang_key_pair.sql` trên warehouse trước khi bật DAG.
- Index phục vụ pipeline nằm trên **nguồn**, user tạo. Không sửa dữ liệu nguồn.

## Thứ tự bước (sau khi user chỉ file Excel)

1. Đọc file Excel user chỉ trong `autogen/`. Với từng bảng ở cột `Nguồn`, đọc cột, kiểu, khóa, index từ schema `emr_datalake` qua connection `emr_datalake`. Bảng chưa có trong `nguon.sql` thì xuất DDL và nối vào file.
2. Lập grain từng chức năng và quyết định gộp/tách. Dừng nếu user chưa duyệt quyết định này.
3. Viết fact `emr_db_...` và `_stg` vào `pipeline/sql/DDL_cac_bang_dich.sql` và `z_docs/dashboard/dich.sql`. Viết key-pair vào `pipeline/sql/DDL_cac_bang_key_pair.sql`.
4. Viết một DAG mới cho nhóm và các job. `prepare` key-pair trước, `commit` khi mọi job thành công. Comment `# ADD` tại chỗ đăng ký.
5. Ghi tên bảng vào cột `Bảng tổng hợp` và câu `SELECT` vào cột `SQL select dashboard` của đúng dòng Excel.
6. `py_compile` file Python. Không coi là đã chạy MySQL.

## Rủi ro & hồi quy

- Gộp hai grain khác nhau làm `SUM` sai (nhân dòng hoặc cộng ngày giường).
- Khóa xóa lệch cột ngày trên nguồn để sót số cũ khi ngày hoặc cơ sở đổi.
- `dich.sql` dùng `CREATE OR REPLACE` thì xóa dữ liệu fact đã có trong file. Thêm bảng mới không `REPLACE` bảng của nhóm khác.
- Mỗi nhóm một DAG. Không đăng ký job nhóm mới vào DAG thuốc.
- Lần chạy đầu cần cửa sổ phủ hết kỳ cần số. Khóa trống chỉ thấy giá trị hiện tại.

## DoD

- [ ] Đã đọc đúng file Excel trong `autogen/` và schema `emr_datalake` qua connection `emr_datalake`
- [ ] Bảng nguồn mới đã được nối DDL vào `z_docs/dashboard/nguon.sql`
- [ ] Fact `emr_db_...` và `_stg` nằm ở DDL đích; key-pair nằm ở `DDL_cac_bang_key_pair.sql`; đủ cột chung CSYT/thời gian
- [ ] Cột `Bảng tổng hợp` và `SQL select dashboard` của file Excel đã được ghi
- [ ] Nhóm có DAG mới, prepare/commit key-pair, xóa-rồi-ghi đúng grain
- [ ] User chạy DDL fact rồi DDL key-pair trên warehouse trước khi bật DAG
- [ ] Comment `# ADD` / `# UPDATE` tại điểm đăng ký

## Mặc định nếu đợt sau không nói khác

- Một nhóm chức năng = một DAG mới + một bộ key-pair. Không sửa DAG thuốc.
- Mọi fact có đủ cột chung. Địa bàn, tên CSYT, tuyến, hạng và chỉ tiêu để `NULL`. `ma_csyt` lấy từ nguồn.
- Skill làm tiếp sau khi duyệt plan này và sau khi user chỉ file Excel: `/z-add-edit`.
