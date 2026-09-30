-- Dashboard thuốc / kháng sinh. Đọc bảng đích warehouse.
-- ngay_su_dung = DATE(decision_date), khoảng nửa mở: >= :from_date và < :to_date.
-- :thang dạng '01'-'12'. Bỏ điều kiện tháng khi xem cả năm.
-- ma_tinh, ten_csyt, chỉ tiêu đang NULL — không lọc các cột đó.
-- DDD: so_ngay_giuong trên mỗi dòng thuốc đã là tổng ngày giường của khoa, lấy MAX.

-- =============================================================================
-- 1) Top 10 thuốc sử dụng — emr_db_top10_thuoc_sd
-- =============================================================================
SELECT ma_thuoc,
       MAX(ten_thuoc) AS ten_thuoc,
       SUM(so_luong)  AS so_luong,
       SUM(tong_tien) AS tong_tien
FROM emr_db_top10_thuoc_sd
WHERE ma_csyt = :ma_csyt
  AND ngay_su_dung >= :from_date
  AND ngay_su_dung < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY ma_thuoc
ORDER BY tong_tien DESC
LIMIT 10;

-- =============================================================================
-- 2) Top 10 nhóm thuốc sử dụng — emr_db_top10_nhom_thuoc_sd
-- =============================================================================
SELECT nhom_thuoc,
       SUM(so_luong)  AS so_luong,
       SUM(tong_tien) AS tong_tien
FROM emr_db_top10_nhom_thuoc_sd
WHERE ma_csyt = :ma_csyt
  AND ngay_su_dung >= :from_date
  AND ngay_su_dung < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY nhom_thuoc
ORDER BY tong_tien DESC
LIMIT 10;

-- =============================================================================
-- 3) Top 10 hoạt chất — emr_db_tong_hop_thuoc
-- =============================================================================
SELECT ma_hoat_chat,
       MAX(ten_hoat_chat) AS ten_hoat_chat,
       SUM(so_luong)      AS so_luong,
       SUM(tong_tien)     AS tong_tien
FROM emr_db_tong_hop_thuoc
WHERE ma_csyt = :ma_csyt
  AND la_khang_sinh = 1
  AND ngay_su_dung >= :from_date
  AND ngay_su_dung < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY ma_hoat_chat
ORDER BY tong_tien DESC
LIMIT 10;

-- =============================================================================
-- 4) Cơ cấu chi phí sử dụng thuốc — emr_db_tong_hop_thuoc
-- =============================================================================
SELECT la_khang_sinh,
       CASE la_khang_sinh WHEN 1 THEN 'Kháng sinh' ELSE 'Thuốc khác' END AS nhom,
       SUM(so_luong)  AS so_luong,
       SUM(tong_tien) AS tong_tien
FROM emr_db_tong_hop_thuoc
WHERE ma_csyt = :ma_csyt
  AND ngay_su_dung >= :from_date
  AND ngay_su_dung < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY la_khang_sinh;

-- =============================================================================
-- 5) Chi phí kháng sinh theo khoa — emr_db_tong_hop_thuoc
-- =============================================================================
SELECT khoa,
       SUM(so_luong)  AS so_luong,
       SUM(tong_tien) AS tong_tien
FROM emr_db_tong_hop_thuoc
WHERE ma_csyt = :ma_csyt
  AND la_khang_sinh = 1
  AND ngay_su_dung >= :from_date
  AND ngay_su_dung < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY khoa
ORDER BY tong_tien DESC;

-- =============================================================================
-- 6) Tiền kháng sinh theo hoạt chất — emr_db_tong_hop_thuoc
-- =============================================================================
SELECT ma_hoat_chat,
       MAX(ten_hoat_chat) AS ten_hoat_chat,
       SUM(so_luong)      AS so_luong,
       SUM(tong_tien)     AS tong_tien
FROM emr_db_tong_hop_thuoc
WHERE ma_csyt = :ma_csyt
  AND la_khang_sinh = 1
  AND ngay_su_dung >= :from_date
  AND ngay_su_dung < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY ma_hoat_chat
ORDER BY tong_tien DESC;

-- =============================================================================
-- 7) Tiền kháng sinh theo đường dùng — emr_db_tong_hop_thuoc
-- =============================================================================
SELECT duong_dung,
       SUM(so_luong)  AS so_luong,
       SUM(tong_tien) AS tong_tien
FROM emr_db_tong_hop_thuoc
WHERE ma_csyt = :ma_csyt
  AND la_khang_sinh = 1
  AND ngay_su_dung >= :from_date
  AND ngay_su_dung < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY duong_dung
ORDER BY tong_tien DESC;

-- =============================================================================
-- 8) Tiền kháng sinh nội trú và ngoại trú — emr_db_tong_hop_thuoc_noi_ngoai
--    loai_dieu_tri: 1 = ngoại trú, 2 = nội trú
-- =============================================================================
SELECT loai_dieu_tri,
       CASE loai_dieu_tri WHEN '1' THEN 'Ngoại trú' WHEN '2' THEN 'Nội trú' END AS ten_loai,
       SUM(so_luong)  AS so_luong,
       SUM(tong_tien) AS tong_tien
FROM emr_db_tong_hop_thuoc_noi_ngoai
WHERE ma_csyt = :ma_csyt
  AND loai_dieu_tri IN ('1', '2')
  AND ngay_su_dung >= :from_date
  AND ngay_su_dung < :to_date
GROUP BY loai_dieu_tri;

-- =============================================================================
-- 9) Kháng sinh ngoại trú theo tháng — emr_db_tong_hop_thuoc_noi_ngoai
-- =============================================================================
SELECT nam,
       thang_su_dung,
       SUM(so_luong)  AS so_luong,
       SUM(tong_tien) AS tong_tien
FROM emr_db_tong_hop_thuoc_noi_ngoai
WHERE ma_csyt = :ma_csyt
  AND loai_dieu_tri = '1'
  AND nam = :nam
  AND ngay_su_dung >= :from_date
  AND ngay_su_dung < :to_date
GROUP BY nam, thang_su_dung
ORDER BY thang_su_dung;

-- =============================================================================
-- 10) Kháng sinh nội trú theo tháng — emr_db_tong_hop_thuoc_noi_ngoai
-- =============================================================================
SELECT nam,
       thang_su_dung,
       SUM(so_luong)  AS so_luong,
       SUM(tong_tien) AS tong_tien
FROM emr_db_tong_hop_thuoc_noi_ngoai
WHERE ma_csyt = :ma_csyt
  AND loai_dieu_tri = '2'
  AND nam = :nam
  AND ngay_su_dung >= :from_date
  AND ngay_su_dung < :to_date
GROUP BY nam, thang_su_dung
ORDER BY thang_su_dung;

-- =============================================================================
-- 11) Tiền kháng sinh theo phân nhóm TDDL — emr_db_tong_hop_thuoc_phan_nhom
-- =============================================================================
SELECT phan_nhom,
       SUM(so_luong)  AS so_luong,
       SUM(tong_tien) AS tong_tien
FROM emr_db_tong_hop_thuoc_phan_nhom
WHERE ma_csyt = :ma_csyt
  AND ngay_su_dung >= :from_date
  AND ngay_su_dung < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY phan_nhom
ORDER BY tong_tien DESC;

-- =============================================================================
-- 12) Tiền kháng sinh theo khoa và phân nhóm TDDL — emr_db_tong_hop_thuoc_phan_nhom
-- =============================================================================
SELECT khoa,
       phan_nhom,
       SUM(so_luong)  AS so_luong,
       SUM(tong_tien) AS tong_tien
FROM emr_db_tong_hop_thuoc_phan_nhom
WHERE ma_csyt = :ma_csyt
  AND ngay_su_dung >= :from_date
  AND ngay_su_dung < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY khoa, phan_nhom
ORDER BY khoa, tong_tien DESC;

-- =============================================================================
-- 13) Tiền kháng sinh theo xuất xứ — emr_db_tong_hop_thuoc_xuat_xu
-- =============================================================================
SELECT xuat_xu,
       SUM(so_luong)  AS so_luong,
       SUM(tong_tien) AS tong_tien
FROM emr_db_tong_hop_thuoc_xuat_xu
WHERE ma_csyt = :ma_csyt
  AND ngay_su_dung >= :from_date
  AND ngay_su_dung < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY xuat_xu
ORDER BY tong_tien DESC;

-- =============================================================================
-- 14) DDD/100 ngày giường theo khoa — emr_db_tong_hop_ddd_khoa. Tìm theo năm
-- =============================================================================
SELECT khoa,
       ma_thuoc,
       ten_biet_duoc,
       ddd_who,
       ham_luong_qui_doi,
       SUM(so_luong) AS tong_so_luong,
       MAX(so_ngay_giuong) AS tong_so_ngay_giuong,
       ham_luong_qui_doi * SUM(so_luong) / NULLIF(ddd_who, 0) AS so_ddd,
       ham_luong_qui_doi * SUM(so_luong) / NULLIF(ddd_who, 0) * 100
           / NULLIF(MAX(so_ngay_giuong), 0) AS so_ddd_100
FROM emr_db_tong_hop_ddd_khoa
WHERE ma_csyt = :ma_csyt
  AND nam = :nam
GROUP BY khoa, ma_thuoc, ten_biet_duoc, ddd_who, ham_luong_qui_doi;

-- =============================================================================
-- 15) DDD/100 ngày giường theo phân nhóm tác dụng dược lý — emr_db_tong_hop_ddd_khoa
-- =============================================================================
SELECT khoa,
       phan_nhom,
       ma_thuoc,
       ten_biet_duoc,
       ddd_who,
       ham_luong_qui_doi,
       SUM(so_luong) AS tong_so_luong,
       MAX(so_ngay_giuong) AS tong_so_ngay_giuong,
       ham_luong_qui_doi * SUM(so_luong) / NULLIF(ddd_who, 0) AS so_ddd,
       ham_luong_qui_doi * SUM(so_luong) / NULLIF(ddd_who, 0) * 100
           / NULLIF(MAX(so_ngay_giuong), 0) AS so_ddd_100
FROM emr_db_tong_hop_ddd_khoa
WHERE ma_csyt = :ma_csyt
  AND nam = :nam
GROUP BY khoa, phan_nhom, ma_thuoc, ten_biet_duoc, ddd_who, ham_luong_qui_doi;

-- =============================================================================
-- 16) DDD/100 ngày giường theo hoạt chất quy đổi — emr_db_tong_hop_ddd_khoa
-- =============================================================================
SELECT khoa,
       hoat_chat,
       ten_biet_duoc,
       ddd_who,
       ham_luong_qui_doi,
       SUM(so_luong) AS tong_so_luong,
       MAX(so_ngay_giuong) AS tong_so_ngay_giuong,
       ham_luong_qui_doi * SUM(so_luong) / NULLIF(ddd_who, 0) AS so_ddd,
       ham_luong_qui_doi * SUM(so_luong) / NULLIF(ddd_who, 0) * 100
           / NULLIF(MAX(so_ngay_giuong), 0) AS so_ddd_100
FROM emr_db_tong_hop_ddd_khoa
WHERE ma_csyt = :ma_csyt
  AND nam = :nam
GROUP BY khoa, hoat_chat, ten_biet_duoc, ddd_who, ham_luong_qui_doi;

-- =============================================================================
-- 17) DDD/100 ngày giường theo tháng — emr_db_tong_hop_ddd_khoa_thang
--     :thang = '01'-'12'. Kèm :nam để không gộp cùng tháng của nhiều năm
-- =============================================================================
SELECT khoa,
       ma_thuoc,
       ten_biet_duoc,
       ddd_who,
       ham_luong_qui_doi,
       SUM(so_luong) AS tong_so_luong,
       MAX(so_ngay_giuong) AS tong_so_ngay_giuong,
       ham_luong_qui_doi * SUM(so_luong) / NULLIF(ddd_who, 0) AS so_ddd,
       ham_luong_qui_doi * SUM(so_luong) / NULLIF(ddd_who, 0) * 100
           / NULLIF(MAX(so_ngay_giuong), 0) AS so_ddd_100
FROM emr_db_tong_hop_ddd_khoa_thang
WHERE ma_csyt = :ma_csyt
  AND nam = :nam
  AND thang = :thang
GROUP BY khoa, ma_thuoc, ten_biet_duoc, ddd_who, ham_luong_qui_doi;
