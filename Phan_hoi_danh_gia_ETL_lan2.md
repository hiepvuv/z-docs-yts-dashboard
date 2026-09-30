# Phản hồi đánh giá ETL thuốc lần 2

Các mục dưới đây không coi là lỗi cần sửa. Phần đã nhận đã vá trong pipeline.

## Không nhận

**Cột địa bàn / tên cơ sở để trống.** `ma_tinh`, `ten_tinh`, `ma_xa`, `ten_xa`, `ten_csyt`, `tuyen_csyt`, `hang_csyt` và các cột chỉ tiêu biểu đồ ghi `''` là chủ đích. Dashboard core vẫn cần đủ cột. Không join `cats_healthfacilities`, tỉnh, xã. `ma_csyt` vẫn là `healthfacilities_id`. Thông tin địa bàn CSYT không quản trên các bảng này.

**Xóa cứng dòng thuốc trên nguồn.** Ngoài phạm vi. Chỉ xử lý xóa mềm: `is_delete`, `is_active`. Dòng tắt vẫn kéo cặp khóa để xóa số cũ trên đích, rồi không cộng vào tổng.

**“300 lần full scan”.** `NVL(healthfacilities_id, '')` đúng là chặn index cột cơ sở, phần đó đã bỏ: join thẳng `healthfacilities_id` và khoảng `use_date`. Không phải 300 lần quét full bảng khi `use_date` có index. Mỗi mẻ là một lần đọc theo cặp cơ sở + ngày. Mã cơ sở null không vào cặp.

## Ghi nhận, không đổi tên trong lần này

`init__.py`, tên `PIPELINE_NAME` gõ lệch, tên package `emr_dashboard_piplines`, `DummyOperator` / `none_failed_or_skipped`. Đổi tên task hoặc tên biến Airflow sẽ lệch lịch sử chạy và `dag_run.conf`. Giữ nguyên để job đang chạy không gãy.
