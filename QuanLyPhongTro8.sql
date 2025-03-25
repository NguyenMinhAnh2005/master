Create Database Nhom5_DA1;
Go
Use Nhom5_DA1;
go

--Tạo bảng

--1. Tầng
Go
Create Table Tang(
TangSo int not null,
SoPhong int not null,
GhiChu nvarchar(250) null,
Primary key(TangSo),
); 

--2. Phòng trọ
Go
Create Table PhongTro(
TangSo int not null,
MaPhong varchar(10) not null,
LoaiPhong nvarchar(50) not null,
DienTich float not null,
GiaPhong float not null,
TienNghi nvarchar(100) not null,
TrangThai int not null,--(0-còn trống : 1-Đã thuê : 2-Đang sửa chữa)
Anh nvarchar(200) null,
Primary Key(MaPhong),
Foreign Key(TangSo) References Tang(TangSo)
);

--3. Khách thuê
GO
Create Table KhachThue(
IdKhach int identity(1, 1) not null,
MaPhong varchar(10) not null, -- lấy ra mã phòng
HoTen nvarchar(50) not null,
NgaySinh date not null,
GioiTinh bit not null, --(0-Nam : 1-Nu)
DienThoai varchar(10),
Email varchar(50) not null,
DiaChi nvarchar(50) not null,
CCCD varchar(12) not null,
Primary key(IdKhach),
Foreign Key(MaPhong) References PhongTro(MaPhong)
);

--4. Nhân Viên
Go
Create Table NhanVien( ---
MaNhanVien varchar(10) not null, --mã định danh nhân viên(sửa, xóa mã nhân viên trong việc nhầm lẫn khi tạo)
HoTen nvarchar(50) not null,
NgaySinh date not null,
GioiTinh bit not null, -- 0:Nam : 1: Nữ
DienThoai varchar(10) not null,
CCCD varchar(12) not null,
NgayBatDau date not null,
NgayKetThuc date null,
ThoiHan int not null,
anh nvarchar(200) null,
TrangThai int not null, --0 Đã nghỉ làm , 1 Đang làm việc 
Primary key(MaNhanVien)
);
CREATE TABLE LichLamViec (
    IDLichLamViec INT PRIMARY KEY IDENTITY(1,1),
    NgayLamViec DATE NOT NULL,
    MaNhanVien VARCHAR(10) NOT NULL,
    CongViec NVARCHAR(255) NOT NULL,
    GhiChu NVARCHAR(255) NULL,
	TrangThai int not null
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien)
);
--5. Hợp đồng
Go
Create Table HopDong( ---
IdHopDong int identity(1, 1) not null,
MaPhong varchar(10) not null,--lấy ra số phòng
IdKhach int not null, --lấy ra tên khách, sodienthoai, cccd (thông tin cơ bản để liên hệ, phải có 3 mục này)
SoNguoi int not null,
NgayBatDau date not null,
NgayKetThuc date null,
ThoiHan int not null, --Tháng
GiaPhong float not null,
SoTienCoc float not null,
DieuKhoan nvarchar(150) not null,
TrangThai bit not null, --(0-Còn hạn : 1-Hết hạn)
Primary Key(IdHopDong),
Foreign Key(MaPhong) References PhongTro(MaPhong),
Foreign Key(IdKhach) References KhachThue(IdKhach),
);

--6. Hóa đơn
Go
Create Table HoaDon( ---
IdHoaDon int identity(1, 1) not null,
MaPhong varchar(10) not null,
MaNhanVien varchar(10) not null,
NgayLap date not null,
HanThanhToan date not null,
TrangThai bit not null, --(0-chưa thanh tóan : 1-Đã thanh toán)
NgayThanhToan date null,
TongTien Float NOT NULL,
Primary Key(IdHoaDon),
Foreign Key(MaPhong) References PhongTro(MaPhong),
Foreign key(MaNhanVien) References NhanVien(MaNhanVien)
);

--7. Tiền dịch vụ
Go
Create Table TienDichVu( --- 
IdDichVu int identity(1, 1) not null,
IdHoaDon int not null,
MaPhong varchar(10) not null,
TenDichVu nvarchar(50) not null,
NgayBatDau date not null,
NgayKetThuc date not null,
GiaTien float not null,
DauNguoi int not null,
ThanhTien as (GiaTien * DauNguoi),
TrangThai BIT NOT NULL, -- 0 chưa chỉnh sửa -- 1 đã chỉnh sửa
Primary Key(IdDichVu),
Foreign Key(MaPhong) References PhongTro(MaPhong),
FOREIGN KEY(IdDichVu) REFERENCES dbo.HoaDon(IdHoaDon)
);


--8. Tiền điện
Go
Create Table TienDien(
IdTienDien int identity(1, 1) not null,
IdHoaDon int not null,
MaPhong varchar(10) not null,
NgayBatDau date not null,
NgayKetThuc date not null,
ChiSoDau int not null,
ChiSoCuoi int not null,
SoDien as (ChiSoCuoi - ChiSoDau),
GiaTien float not null,
ThanhTien as (ChiSoCuoi - ChiSoDau) * GiaTien,
TrangThai BIT NOT NULL, -- 0 chưa chỉnh sửa -- 1 đã chỉnh sửa
Primary key(IdTienDien),
Foreign key(IdHoaDon) References HoaDon(IdHoaDon),
Foreign key(MaPhong) References PhongTro(MaPhong)
);

--9. Tiền nước
Go
Create Table TienNuoc(
IdTienNuoc int identity(1, 1) not null,
IdHoaDon int not null,
MaPhong varchar(10) not null,
NgayBatDau date not null,
NgayKetThuc date not null,
DauNguoi int not null,
GiaTien float not null,
ThanhTien as (DauNguoi * GiaTien),
TrangThai BIT NOT NULL, -- 0 chưa chỉnh sửa -- 1 đã chỉnh sửa
Primary key(IdTienNuoc),
Foreign key(IdHoaDon) References HoaDon(IdHoaDon),
Foreign key(MaPhong) References PhongTro(MaPhong)
);

--10. Tài sản
Go
Create Table TaiSan(
IdTaiSan int identity(1, 1) not null,
TenTaiSan nvarchar(50) not null,
GiaTaiSan float not null, --load lên table, dể cột này thành Giá/chiếc(cái)
SoLuong int not null,
Ghichu nvarchar(150) null,
Primary Key(IdTaiSan),
);

--11. Tài sản phòng
Go 
Create Table TaiSanPhong(
IdTaiSanPhong int identity(1, 1) not null,
IdTaiSan int not null,
MaPhong varchar(10) not null,
SoLuong int not null,
TinhTrang bit not null, --(0-Còn hoạt động : 1-Đang bảo dưỡng)
GhiChu nvarchar(150) null,
Primary key(IdTaiSanPhong),
Foreign key(IdTaiSan) References TaiSan(IdTaiSan),
Foreign key(MaPhong) References PhongTro(MaPhong)
);

--12. Đăng nhập
Go
Create Table DangNhap(
TenDangNhap varchar(50) not null,
MatKhau varchar(50) not null,
VaiTro bit not null, -- 0-Chủ trọ : 1-nhân viên
MaNhanVien varchar(10),
Primary key(TenDangNhap),
FOREIGN KEY(MaNhanVien) REFERENCES dbo.NhanVien(MaNhanVien)
);
Go

--Insert Dữ liệu
Go
INSERT INTO Tang (TangSo, SoPhong, GhiChu) VALUES
(1, 4, N''),
(2, 4, N'có ban công'),
(3, 4, N''),
(4, 4, N'có sân phơi đồ và máy giặt');

-- Bảng PhongTro
INSERT INTO PhongTro (TangSo, MaPhong, LoaiPhong, DienTich, GiaPhong, TienNghi, TrangThai, Anh) VALUES
(1, 'P101', N'Phòng đơn', 20.0, 5000000, N'Điều hòa, Nóng lạnh, máy giặt', 0 , ''),
(1, 'P102', N'Phòng đôi', 25.0, 4000000, N'Điều hòa, Tủ lạnh, máy giặt', 2, ''),
(1, 'P103', N'Phòng đơn', 20.0, 4000000, N'Điều hòa, Nóng lạnh, máy giặt', 1, ''),
(1, 'P104', N'Phòng đôi', 25.0, 3500000, N'Điều hòa, Tủ lạnh, máy giặt', 1, ''),
(2, 'P201', N'Phòng đơn', 20.0, 3800000, N'Điều hòa, Nóng lạnh, máy giặt', 1, ''),
(2, 'P202', N'Phòng đôi', 25.0, 3500000, N'Điều hòa, Tủ lạnh, máy giặt', 0 , ''),
(2, 'P203', N'Phòng đơn', 22.0, 4000000, N'Điều hòa, Nóng lạnh, máy giặt', 1, ''),
(2, 'P204', N'Phòng đôi', 27.0, 5000000, N'Điều hòa, Tủ lạnh, máy giặt', 1, ''),
(3, 'P301', N'Phòng đơn', 22.0, 4000000, N'Điều hòa, Nóng lạnh, máy giặt', 1, ''),
(3, 'P302', N'Phòng đôi', 27.0, 5000000, N'Điều hòa, Tủ lạnh, máy giặt', 1, ''),
(3, 'P303', N'Phòng đơn', 20.0, 4000000, N'Điều hòa, Nóng lạnh, máy giặt', 2, ''),
(3, 'P304', N'Phòng đôi', 25.0, 3500000, N'Điều hòa, Tủ lạnh, máy giặt', 2, ''),
(4, 'P401', N'Phòng đơn', 20.0, 4000000, N'Điều hòa, Nóng lạnh, máy giặt', 2, ''),
(4, 'P402', N'Phòng đôi', 25.0, 3500000, N'Điều hòa, Tủ lạnh, máy giặt', 2, ''),
(4, 'P403', N'Phòng đơn', 22.0, 4000000, N'Điều hòa, Nóng lạnh, máy giặt', 1, ''),
(4, 'P404', N'Phòng đôi', 27.0, 5000000, N'Điều hòa, Tủ lạnh, máy giặt', 0 , '');

Go
-- Bảng KhachThue
INSERT INTO KhachThue (MaPhong, HoTen, NgaySinh, GioiTinh, DienThoai, Email, DiaChi, CCCD) VALUES
    ('P101', N'Nguyễn Văn A', '1990-01-01', 0 , '0901234567', 'nguyenvana@gmail.com', N'123 Đường ABC, Quận 1, TP.HCM', '012345678901'),
    ('P101', N'Lê Văn N', '1984-03-01', 0 , '0923344556', 'levann@gmail.com', N'789 Đường QRS, Quận 3, TP.HCM', '334455667788'),
    ('P102', N'Trần Thị B', '1992-02-01', 1, '0912345678', 'tranthib@gmail.com', N'456 Đường XYZ, Quận 2, TP.HCM', '023456789012'),
    ('P102', N'Phạm Thị O', '1986-04-01', 1, '0934455667', 'phamthio@gmail.com', N'159 Đường TUV, Quận 4, TP.HCM', '445566778899'),
    ('P103', N'Trần Thị M', '1982-02-01', 1, '0912233445', 'tranthim@gmail.com', N'456 Đường NOP, Quận 2, TP.HCM', '223344556677'),
    ('P103', N'Phạm Văn I', '2006-09-01', 0 , '0989012345', 'phamvani@gmail.com', N'357 Đường EFG, Quận 1, TP.HCM', '090123456789'),
    ('P104', N'Hoàng Thị K', '2008-10-01', 1, '0990123456', 'hoangthik@gmail.com', N'951 Đường HIJ, Quận 2, TP.HCM', '101234567890'),
    ('P104', N'Nguyễn Văn L', '1980-01-01', 0 , '0901122334', 'nguyenvanl@gmail.com', N'123 Đường KLM, Quận 1, TP.HCM', '112233445566'),
    ('P201', N'Lê Văn C', '1994-03-01', 0 , '0923456789', 'levanc@gmail.com', N'789 Đường PQR, Quận 3, TP.HCM', '034567890123'),
    ('P201', N'Hoàng Văn P', '1988-05-01', 0 , '0945566778', 'hoangvanp@gmail.com', N'753 Đường WXY, Quận 5, TP.HCM', '556677889900'),
    ('P202', N'Phạm Thị D', '1996-04-01', 1, '0934567890', 'phamthid@gmail.com', N'159 Đường LMN, Quận 4, TP.HCM', '045678901234'),
    ('P202', N'Nguyễn Văn M', '1997-05-01', 0 , '0935678901', 'nguyenvanm@gmail.com', N'258 Đường OPQ, Quận 6, TP.HCM', '123456789012'),
    ('P301', N'Hoàng Văn E', '1998-05-01', 0 , '0945678901', 'hoangvane@gmail.com', N'753 Đường STU, Quận 5, TP.HCM', '056789012345'),
    ('P301', N'Trần Văn H', '2001-06-01', 0 , '0956789012', 'tranvanh@gmail.com', N'159 Đường DEF, Quận 7, TP.HCM', '234567890123'),
    ('P302', N'Nguyễn Thị F', '2000-06-01', 1, '0956789012', 'nguyenthif@gmail.com', N'357 Đường VWX, Quận 6, TP.HCM', '067890123456'),
    ('P302', N'Lê Văn K', '1999-07-01', 0 , '0957890123', 'levank@gmail.com', N'951 Đường CBA, Quận 8, TP.HCM', '345678901234'),
    ('P401', N'Trần Văn G', '2002-07-01', 0 , '0967890123', 'tranvang@gmail.com', N'951 Đường YZA, Quận 7, TP.HCM', '078901234567'),
    ('P401', N'Phạm Thị L', '2003-08-01', 1, '0968901234', 'phamthil@gmail.com', N'753 Đường FGH, Quận 9, TP.HCM', '456789012345'),
    ('P402', N'Lê Thị H', '2004-08-01', 1, '0978901234', 'lethih@gmail.com', N'753 Đường BCD, Quận 8, TP.HCM', '089012345678'),
    ('P402', N'Nguyễn Văn T', '2005-09-01', 0 , '0979901234', 'nguyenvant@gmail.com', N'123 Đường HIJ, Quận 10, TP.HCM', '567890123456'),
    ('P403', N'Trần Văn X', '2006-10-01', 0 , '0980901234', 'tranvanx@gmail.com', N'456 Đường KLM, Quận 11, TP.HCM', '678901234567'),
    ('P403', N'Phạm Thị Z', '2007-11-01', 1, '0981901234', 'phamthiz@gmail.com', N'789 Đường NOP, Quận 12, TP.HCM', '789012345678'),
    ('P404', N'Lê Văn Y', '2008-12-01', 0 , '0982901234', 'levany@gmail.com', N'951 Đường QRS, Quận 13, TP.HCM', '890123456789'),
    ('P404', N'Nguyễn Thị U', '2009-01-01', 1, '0983901234', 'nguyenthiu@gmail.com', N'753 Đường TUV, Quận 14, TP.HCM', '901234567890');
GO

--trigger
CREATE TRIGGER Update_HopDong_count_after_Insert
ON KhachThue
AFTER INSERT
as
BEGIN
	declare @MaPhong varchar(10);
	SELECT @MaPhong = MaPhong FROM inserted;
	UPDATE HopDong set SoNguoi=SoNguoi+1 where MaPhong = @MaPhong;
END
--------


Go
INSERT INTO NhanVien (MaNhanVien, HoTen, NgaySinh, GioiTinh, DienThoai, CCCD, NgayBatDau, NgayKetThuc, ThoiHan, anh, TrangThai)
VALUES
    ('NV001', N'Nguyễn Văn A', '1990-05-15', 0 , '0987654321', '123456789012', '2022-01-01', '2023-12-31', 24, NULL, 1),
    ('NV002', N'Trần Thị B', '1995-09-20', 1, '0123456789', '987654321012', '2023-03-01', NULL, 36, NULL, 1);

Go 
INSERT INTO LichLamViec(NgayLamViec,MaNhanVien,CongViec,GhiChu,TrangThai) values 
('2023-11-10', 'NV001', 'Quét tất cả các hành lang', 'Quét thật sạch sẽ',0),
('2023-11-11', 'NV002', 'Kiểm tra vòi nước từng phòng', 'Hư báo cho tôi',0);
go
	
INSERT INTO HopDong (MaPhong, IdKhach, SoNguoi, NgayBatDau, NgayKetThuc, ThoiHan, GiaPhong, SoTienCoc, DieuKhoan, TrangThai) VALUES
    ('P101', 1, 2, '2023-01-01', '2024-01-01', 12, 5000000, 5000000, N'Không nuôi thú cưng.',0 ),
    ('P102', 3, 2, '2023-02-01', '2024-02-01', 12, 4000000, 4000000, N'Không gây ồn ào.', 0),
    ('P103', 5, 2, '2023-03-01', '2024-03-01', 12, 3800000, 3800000, N'Không hút thuốc.', 0),
    ('P104', 7, 1, '2023-04-01', '2024-04-01', 12, 3500000, 3500000, N'Không làm hư hỏng tài sản.', 0),
    ('P201', 8, 1, '2023-05-01', '2024-05-01', 12, 4000000, 4000000, N'Thanh toán đúng hạn.', 0 ),
    ('P202', 9, 1, '2023-06-01', '2024-06-01', 12, 5000000, 5000000, N'Không tổ chức tiệc tùng.', 0),
    ('P203', 10, 1, '2023-07-01', '2024-07-01', 12, 4000000, 4000000, N'Không gây mất trật tự.', 0 ),
    ('P204', 11, 1, '2023-08-01', '2024-08-01', 12, 3500000, 3500000, N'Không xả rác bừa bãi.', 0 ),
    ('P301', 12, 2, '2023-09-01', '2024-09-01', 12, 4000000, 4000000, N'Không nuôi thú cưng.', 0 ),
    ('P302', 14, 2, '2023-10-01', '2024-10-01', 12, 3500000, 3500000, N'Không gây ồn ào.', 0),
    ('P303', 15, 1, '2023-11-01', '2024-11-01', 12, 3800000, 3800000, N'Không hút thuốc.', 0 ),
    ('P304', 16, 2, '2023-12-01', '2024-12-01', 12, 5000000, 5000000, N'Không tổ chức tiệc tùng.', 0 ),
    ('P401', 17, 1, '2024-01-01', '2025-01-01', 12, 4000000, 4000000, N'Thanh toán đúng hạn.', 0),
    ('P402', 18, 2, '2024-02-01', '2025-02-01', 12, 3500000, 3500000, N'Không gây mất trật tự.', 0 ),
    ('P403', 19, 1, '2024-03-01', '2025-03-01', 12, 4000000, 4000000, N'Không nuôi thú cưng.', 0 ),
    ('P404', 20, 2, '2024-04-01', '2025-04-01', 12, 3500000, 3500000, N'Không gây ồn ào.', 0);


Go
INSERT INTO HoaDon (MaPhong, MaNhanVien, NgayLap, HanThanhToan, TrangThai, NgayThanhToan, TongTien) VALUES
    ('P101', 'NV001', '2023-08-01', '2023-08-16', 1, '2023-08-10', 400000 + 250000 + 200000), -- Tổng tiền: 850000
    ('P102', 'NV001', '2023-08-01', '2023-08-16', 1, '2023-08-12', 600000 + 300000 + 300000), -- Tổng tiền: 1200000
    ('P103', 'NV001', '2023-08-01', '2023-08-16', 1, '2023-08-13', 200000 + 250000 + 100000), -- Tổng tiền: 550000
    ('P104', 'NV001', '2023-08-01', '2023-08-16', 1, '2023-08-07', 400000 + 250000 + 200000), -- Tổng tiền: 850000
    ('P201', 'NV001', '2023-08-01', '2023-08-16', 1, '2023-08-05', 200000 + 250000 + 100000), -- Tổng tiền: 550000
    ('P202', 'NV001', '2023-08-01', '2023-08-16', 1, '2023-08-14', 400000 + 250000 + 200000), -- Tổng tiền: 850000
    ('P203', 'NV001', '2023-08-01', '2023-08-16', 1, '2023-08-08', 600000 + 250000 + 300000), -- Tổng tiền: 1150000
    ('P204', 'NV001', '2023-08-01', '2023-08-16', 1, '2023-08-06', 200000 + 250000 + 100000), -- Tổng tiền: 550000
    ('P301', 'NV001', '2023-08-01', '2023-08-16', 1, '2023-08-11', 400000 + 250000 + 200000), -- Tổng tiền: 850000
    ('P302', 'NV001', '2023-08-01', '2023-08-16', 1, '2023-08-09', 200000 + 250000 + 100000), -- Tổng tiền: 550000
    ('P303', 'NV001', '2023-08-01', '2023-08-16', 1, '2023-08-13', 600000 + 250000 + 300000), -- Tổng tiền: 1150000
    ('P304', 'NV001', '2023-08-01', '2023-08-16', 1, '2023-08-07', 400000 + 250000 + 200000), -- Tổng tiền: 850000
    ('P401', 'NV001', '2023-08-01', '2023-08-16', 1, '2023-08-10', 200000 + 250000 + 100000), -- Tổng tiền: 550000
    ('P402', 'NV001', '2023-08-01', '2023-08-16', 1, '2023-08-12', 400000 + 250000 + 200000), -- Tổng tiền: 850000
    ('P403', 'NV001', '2023-08-01', '2023-08-16', 1, '2023-08-13', 600000 + 250000 + 300000), -- Tổng tiền: 1150000
    ('P404', 'NV001', '2023-08-01', '2023-08-16', 1, '2023-08-14', 400000 + 250000 + 200000); -- Tổng tiền: 850000

GO
INSERT INTO TienDichVu (IdHoaDon, MaPhong, TenDichVu, NgayBatDau, NgayKetThuc, GiaTien, DauNguoi, TrangThai) VALUES
    (1, 'P101', N'Dịch vụ chung', '2023-07-01', '2023-07-31', 200000, 2, 1), -- Giá tiền: 400000 (200000 * 2)
    (2, 'P102', N'Dịch vụ chung', '2023-07-01', '2023-07-31', 200000, 3, 1), -- Giá tiền: 600000 (200000 * 3)
    (3, 'P103', N'Dịch vụ chung', '2023-07-01', '2023-07-31', 200000, 1, 1), -- Giá tiền: 200000 (200000 * 1)
    (4, 'P104', N'Dịch vụ chung', '2023-07-01', '2023-07-31', 200000, 2, 1), -- Giá tiền: 400000 (200000 * 2)
    (5, 'P201', N'Dịch vụ chung', '2023-07-01', '2023-07-31', 200000, 1, 1), -- Giá tiền: 200000 (200000 * 1)
    (6, 'P202', N'Dịch vụ chung', '2023-07-01', '2023-07-31', 200000, 2, 1), -- Giá tiền: 400000 (200000 * 2)
    (7, 'P203', N'Dịch vụ chung', '2023-07-01', '2023-07-31', 200000, 3, 1), -- Giá tiền: 600000 (200000 * 3)
    (8, 'P204', N'Dịch vụ chung', '2023-07-01', '2023-07-31', 200000, 1, 1), -- Giá tiền: 200000 (200000 * 1)
    (9, 'P301', N'Dịch vụ chung', '2023-07-01', '2023-07-31', 200000, 2, 1), -- Giá tiền: 400000 (200000 * 2)
    (10, 'P302', N'Dịch vụ chung', '2023-07-01', '2023-07-31', 200000, 1, 1), -- Giá tiền: 200000 (200000 * 1)
    (11, 'P303', N'Dịch vụ chung', '2023-07-01', '2023-07-31', 200000, 3, 1), -- Giá tiền: 600000 (200000 * 3)
    (12, 'P304', N'Dịch vụ chung', '2023-07-01', '2023-07-31', 200000, 2, 1), -- Giá tiền: 400000 (200000 * 2)
    (13, 'P401', N'Dịch vụ chung', '2023-07-01', '2023-07-31', 200000, 1, 1), -- Giá tiền: 200000 (200000 * 1)
    (14, 'P402', N'Dịch vụ chung', '2023-07-01', '2023-07-31', 200000, 2, 1), -- Giá tiền: 400000 (200000 * 2)
    (15, 'P403', N'Dịch vụ chung', '2023-07-01', '2023-07-31', 200000, 3, 1), -- Giá tiền: 600000 (200000 * 3)
    (16, 'P404', N'Dịch vụ chung', '2023-07-01', '2023-07-31', 200000, 2, 1); -- Giá tiền: 400000 (200000 * 2)

Go
INSERT INTO TienDien (IdHoaDon, MaPhong, NgayBatDau, NgayKetThuc, ChiSoDau, ChiSoCuoi, GiaTien, TrangThai) VALUES
    (1, 'P101', '2023-07-01', '2023-07-31', 100, 150, 5000, 1), -- Tiền điện: (150 - 100) * 5000 = 250000
    (2, 'P102', '2023-07-01', '2023-07-31', 120, 180, 5000, 1), -- Tiền điện: (180 - 120) * 5000 = 300000
    (3, 'P103', '2023-07-01', '2023-07-31', 80, 130, 5000, 1),  -- Tiền điện: (130 - 80) * 5000 = 250000
    (4, 'P104', '2023-07-01', '2023-07-31', 90, 140, 5000, 1),  -- Tiền điện: (140 - 90) * 5000 = 250000
    (5, 'P201', '2023-07-01', '2023-07-31', 110, 160, 5000, 1), -- Tiền điện: (160 - 110) * 5000 = 250000
    (6, 'P202', '2023-07-01', '2023-07-31', 120, 170, 5000, 1), -- Tiền điện: (170 - 120) * 5000 = 250000
    (7, 'P203', '2023-07-01', '2023-07-31', 130, 180, 5000, 1), -- Tiền điện: (180 - 130) * 5000 = 250000
    (8, 'P204', '2023-07-01', '2023-07-31', 140, 190, 5000, 1), -- Tiền điện: (190 - 140) * 5000 = 250000
    (9, 'P301', '2023-07-01', '2023-07-31', 100, 150, 5000, 1), -- Tiền điện: (150 - 100) * 5000 = 250000
    (10, 'P302', '2023-07-01', '2023-07-31', 110, 160, 5000, 1), -- Tiền điện: (160 - 110) * 5000 = 250000
    (11, 'P303', '2023-07-01', '2023-07-31', 120, 170, 5000, 1), -- Tiền điện: (170 - 120) * 5000 = 250000
    (12, 'P304', '2023-07-01', '2023-07-31', 130, 180, 5000, 1), -- Tiền điện: (180 - 130) * 5000 = 250000
    (13, 'P401', '2023-07-01', '2023-07-31', 140, 190, 5000, 1), -- Tiền điện: (190 - 140) * 5000 = 250000
    (14, 'P402', '2023-07-01', '2023-07-31', 150, 200, 5000, 1), -- Tiền điện: (200 - 150) * 5000 = 250000
    (15, 'P403', '2023-07-01', '2023-07-31', 160, 210, 5000, 1), -- Tiền điện: (210 - 160) * 5000 = 250000
    (16, 'P404', '2023-07-01', '2023-07-31', 170, 220, 5000, 1); -- Tiền điện: (220 - 170) * 5000 = 250000
	
Go
INSERT INTO TienNuoc (IdHoaDon, MaPhong, NgayBatDau, NgayKetThuc, DauNguoi, GiaTien, TrangThai) VALUES
    (1, 'P101', '2023-07-01', '2023-07-31', 2, 100000, 1), -- Tiền nước: 2 * 100000 = 200000
    (2, 'P102', '2023-07-01', '2023-07-31', 3, 100000, 1), -- Tiền nước: 3 * 100000 = 300000
    (3, 'P103', '2023-07-01', '2023-07-31', 1, 100000, 1), -- Tiền nước: 1 * 100000 = 100000
    (4, 'P104', '2023-07-01', '2023-07-31', 2, 100000, 1), -- Tiền nước: 2 * 100000 = 200000
    (5, 'P201', '2023-07-01', '2023-07-31', 1, 100000, 1), -- Tiền nước: 1 * 100000 = 100000
    (6, 'P202', '2023-07-01', '2023-07-31', 2, 100000, 1), -- Tiền nước: 2 * 100000 = 200000
    (7, 'P203', '2023-07-01', '2023-07-31', 3, 100000, 1), -- Tiền nước: 3 * 100000 = 300000
    (8, 'P204', '2023-07-01', '2023-07-31', 1, 100000, 1), -- Tiền nước: 1 * 100000 = 100000
    (9, 'P301', '2023-07-01', '2023-07-31', 2, 100000, 1), -- Tiền nước: 2 * 100000 = 200000
    (10, 'P302', '2023-07-01', '2023-07-31', 1, 100000, 1), -- Tiền nước: 1 * 100000 = 100000
    (11, 'P303', '2023-07-01', '2023-07-31', 3, 100000, 1), -- Tiền nước: 3 * 100000 = 300000
    (12, 'P304', '2023-07-01', '2023-07-31', 2, 100000, 1), -- Tiền nước: 2 * 100000 = 200000
    (13, 'P401', '2023-07-01', '2023-07-31', 1, 100000, 1), -- Tiền nước: 1 * 100000 = 100000
    (14, 'P402', '2023-07-01', '2023-07-31', 2, 100000, 1), -- Tiền nước: 2 * 100000 = 200000
    (15, 'P403', '2023-07-01', '2023-07-31', 3, 100000, 1), -- Tiền nước: 3 * 100000 = 300000
    (16, 'P404', '2023-07-01', '2023-07-31', 2, 100000, 1); -- Tiền nước: 2 * 100000 = 200000


Go
INSERT INTO TaiSan (TenTaiSan, GiaTaiSan, SoLuong, Ghichu) VALUES
    (N'Tivi', 5000000, 10, N'Đã kiểm tra chất lượng.'),
    (N'Tủ lạnh', 8000000, 5, N'Đã bảo trì tháng trước.'),
    (N'Máy giặt', 4000000, 8, N'Giá chưa bao gồm phí vận chuyển.'),
    (N'Bàn học', 1500000, 12, N'Chất liệu gỗ tự nhiên.'),
    (N'Giường ngủ', 3000000, 7, N'Có sẵn gối và đệm.');

Go
INSERT INTO TaiSanPhong (IdTaiSan, MaPhong, SoLuong, TinhTrang, GhiChu) VALUES
    (1, 'P101', 2, 0, N'Tivi hoạt động bình thường.'),
    (1, 'P102', 1, 0 , N'Tivi lạnh còn mới.'),
    (1, 'P103', 1, 1, N'Tivi đang bảo dưỡng.'),
    (2, 'P103', 1, 0 , N'Tủ lạnh hoạt động bình thường.'),
    (2, 'P201', 1, 0 , N'Tủ lạnh đã bảo trì.'),
    (2, 'P202', 1, 1, N'Tủ lạnh đang chờ sửa chữa.'),
    (3, 'P202', 1, 0 , N'Máy giặt hoạt động bình thường.'),
    (3, 'P301', 2, 0 , N'Máy giặt đã kiểm tra chất lượng.'),
    (3, 'P302', 1, 1, N'Máy giặt đang bảo dưỡng.'),
    (4, 'P401', 2, 0, N'Bàn ăn có chút xước nhỏ.'),
    (4, 'P402', 1, 0 , N'Bàn ăn còn mới.'),
    (4, 'P101', 1, 1, N'Bàn ăn đang chờ sửa chữa.'),
    (5, 'P102', 2, 0 , N'Giường ngủ hoạt động bình thường.'),
    (5, 'P104', 1, 0 , N'Giường ngủ có sẵn gối và đệm.'),
    (5, 'P104', 1, 1, N'Giường ngủ đang bảo dưỡng.');

Go
INSERT INTO DangNhap (TenDangNhap, MatKhau, VaiTro, MaNhanVien)
VALUES
    ('chu_tro', 'password123', 0 , NULL),
    ('nhan_vien1', 'password456', 1, 'NV001'),
    ('nhan_vien2', 'password789', 1, 'NV002');

--Go
--INSERT INTO ChamCong (IdNhanVien, NgayCong, DiemDanh) VALUES
--    (1, '2024-07-01', 0 ),
--    (1, '2024-07-02', 0 ),
--    (1, '2024-07-03', 1),
--    (1, '2024-07-04', 0 ),
--    (1, '2024-07-05', 0 ),
--    (2, '2024-07-01', 1),
--    (2, '2024-07-02', 0 ),
--    (2, '2024-07-03', 0 ),
--    (2, '2024-07-04', 1),
--    (2, '2024-07-05', 0 );


--Go
--INSERT INTO LuongNhanVien (IdNhanVien, LuongCoBan, LuongThuong, PhuCap, Thang, Nam) VALUES
--    (1, 7000000, 1500000, 500000, 7, 2024),
--    (2, 8000000, 1000000, 600000, 7, 2024);

--Go
--End
Select * From Tang;
Select * From PhongTro;
Select * From KhachThue;
Select * From HopDong;
Select * From HoaDon;
Select * From TienDichVu;
Select * From TienDien;
Select * From TienNuoc;
Select * From NhanVien;
--Select * From ChamCong;
--Select * From LuongNhanVien;
Select * From TaiSan;
Select * From TaiSanPhong;
Select * From DangNhap;

--Select HoaDon.MaHoaDon, HoaDon.NgayLap, PhongTro.GiaPhong, TienDien.ThanhTien, TienNuoc.ThanhTien, TienDichVu.ThanhTien,
--(PhongTro.GiaPhong + TienDien.ThanhTien + TienNuoc.ThanhTien + TienDichVu.ThanhTien) as 'TongTien'
--From HoaDon 
--inner join TienDien on TienDien.MaHoaDon = HoaDon.MaHoaDon
--inner join TienNuoc on TienNuoc.MaHoaDon = HoaDon.MaHoaDon
--inner join TienDichVu on TienDichVu.MaHoaDon = HoaDon.MaHoaDon
--inner join PhongTro on PhongTro.MaPT = HoaDon.MaPT;

--DELETE FROM TienDichVu WHERE MaPhong = 'P302';
--DELETE FROM TienDien WHERE MaPhong = 'P302';
--DELETE FROM TienNuoc WHERE MaPhong = 'P302';
--DELETE FROM TaiSanPhong WHERE MaPhong = 'P302';
--DELETE FROM HoaDon WHERE MaPhong = 'P302';
--DELETE FROM HopDong WHERE MaPhong = 'P302';
--DELETE FROM KhachThue WHERE MaPhong = 'P302';
--DELETE FROM PhongTro WHERE MaPhong = 'P302';

---- Xóa các bản ghi trong bảng HopDong tham chiếu tới P302
--DELETE FROM HopDong WHERE MaPhong = 'P301';

---- Xóa các bản ghi trong bảng KhachThue tham chiếu tới P302
--DELETE FROM KhachThue WHERE MaPhong = 'P301';

---- Xóa các bản ghi trong bảng HoaDon tham chiếu tới P302
--DELETE FROM HoaDon WHERE MaPhong = 'P301';

---- Xóa các bản ghi trong bảng TienDichVu tham chiếu tới P302
--DELETE FROM TienDichVu WHERE MaPhong = 'P301';

---- Xóa các bản ghi trong bảng TienDien tham chiếu tới P302
--DELETE FROM TienDien WHERE MaPhong = 'P301';

---- Xóa các bản ghi trong bảng TienNuoc tham chiếu tới P302
--DELETE FROM TienNuoc WHERE MaPhong = 'P301';

---- Xóa các bản ghi trong bảng TaiSanPhong tham chiếu tới P302
--DELETE FROM TaiSanPhong WHERE MaPhong = 'P301';

---- Cuối cùng, xóa bản ghi từ bảng PhongTro
--DELETE FROM PhongTro WHERE MaPhong = 'P301';


GO
CREATE PROCEDURE InsertHoaDon
    @MaPhong NVARCHAR(50),
    @MaNhanVien NVARCHAR(50),
	@GiaTienTienDien FLOAT,
	@GiaTienTienNuoc FLOAT,
	@GiaTienTienDichVu FLOAT
AS
BEGIN
	DECLARE @NgayBatDau DATE = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()) - 1, 1);
    DECLARE @NgayKetThuc DATE = EOMONTH(DATEADD(MONTH, -1, GETDATE()));

    INSERT INTO dbo.HoaDon (MaPhong, MaNhanVien, NgayLap, HanThanhToan, TrangThai, NgayThanhToan, TongTien)
    VALUES (@MaPhong, @MaNhanVien, GETDATE(), DATEADD(DAY, 15, GETDATE()), 0, NULL, 0.0);

    DECLARE @IdHoaDon INT;
    SET @IdHoaDon = SCOPE_IDENTITY();

	--tien dien
	DECLARE @getChiSoCuoi INT;
	SELECT @getChiSoCuoi = ISNULL(SubQuery.ChiSoCuoi, 0)
	FROM (
		SELECT TOP 1 ChiSoCuoi
		FROM dbo.TienDien 
		WHERE MaPhong = @MaPhong
		ORDER BY IdTienDien DESC
	) AS SubQuery;

	--tien nuoc
	DECLARE @getDauNguoiTienNuoc INT;
	SELECT @getDauNguoiTienNuoc = ISNULL(SubQuery.DauNguoi, 0)
	FROM (
		SELECT TOP 1 DauNguoi
		FROM dbo.TienNuoc
		WHERE MaPhong = @MaPhong
		ORDER BY IdTienNuoc DESC
	) AS SubQuery;

	--tien dich vu
	DECLARE @getDauNguoiTienDV INT;
	SELECT @getDauNguoiTienDV = ISNULL(SubQuery.DauNguoi, 0)
	FROM (
		SELECT TOP 1 DauNguoi
		FROM dbo.TienDichVu
		WHERE MaPhong = @MaPhong
		ORDER BY IdDichVu DESC
	) AS SubQuery;

    INSERT INTO dbo.TienDien (IdHoaDon, MaPhong, NgayBatDau, NgayKetThuc, ChiSoDau, ChiSoCuoi, GiaTien, TrangThai)
    VALUES (@IdHoaDon, @MaPhong, @NgayBatDau, @NgayKetThuc, @getChiSoCuoi, @getChiSoCuoi, @GiaTienTienDien, 0);

	INSERT INTO dbo.TienNuoc (IdHoaDon, MaPhong, NgayBatDau, NgayKetThuc, DauNguoi, GiaTien, TrangThai)
	VALUES (@IdHoaDon, @MaPhong, @NgayBatDau, @NgayKetThuc, @getDauNguoiTienNuoc, @GiaTienTienNuoc, 0);

	INSERT INTO dbo.TienDichVu (IdHoaDon, MaPhong, TenDichVu, NgayBatDau, NgayKetThuc, GiaTien, DauNguoi, TrangThai)
	VALUES(@IdHoaDon, @MaPhong, N'Dịch vụ chung', @NgayBatDau, @NgayKetThuc, @GiaTienTienDichVu, @getDauNguoiTienDV, 0);
END;

GO
CREATE TRIGGER trigger_UpdateTongTien_HoaDon
ON HoaDon
AFTER INSERT
AS
BEGIN
    UPDATE HoaDon
	SET TongTien = ISNULL((SELECT ThanhTien FROM TienDien WHERE IdHoaDon = HoaDon.IdHoaDon), 0) +
                    ISNULL((SELECT ThanhTien FROM TienNuoc WHERE IdHoaDon = HoaDon.IdHoaDon), 0) +
                    ISNULL((SELECT ThanhTien FROM TienDichVu WHERE IdHoaDon = HoaDon.IdHoaDon), 0)
    FROM HoaDon
    INNER JOIN inserted ON HoaDon.IdHoaDon = inserted.IdHoaDon
    WHERE HoaDon.IdHoaDon = inserted.IdHoaDon;
END

GO
CREATE TRIGGER trigger_UpdateTongTien_TienDien
ON TienDien
AFTER UPDATE
AS
BEGIN
    UPDATE HoaDon
    SET TongTien = ISNULL((SELECT ThanhTien FROM TienDien WHERE IdHoaDon = HoaDon.IdHoaDon), 0) +
                    ISNULL((SELECT ThanhTien FROM TienNuoc WHERE IdHoaDon = HoaDon.IdHoaDon), 0) +
                    ISNULL((SELECT ThanhTien FROM TienDichVu WHERE IdHoaDon = HoaDon.IdHoaDon), 0)
    FROM HoaDon
    INNER JOIN inserted ON HoaDon.IdHoaDon = inserted.IdHoaDon
    WHERE HoaDon.IdHoaDon = inserted.IdHoaDon;
END;
GO

CREATE TRIGGER trigger_UpdateTongTien_TienNuoc
ON TienNuoc
AFTER UPDATE
AS
BEGIN
    UPDATE HoaDon
    SET TongTien = ISNULL((SELECT ThanhTien FROM TienDien WHERE IdHoaDon = HoaDon.IdHoaDon), 0) +
                    ISNULL((SELECT ThanhTien FROM TienNuoc WHERE IdHoaDon = HoaDon.IdHoaDon), 0) +
                    ISNULL((SELECT ThanhTien FROM TienDichVu WHERE IdHoaDon = HoaDon.IdHoaDon), 0)
    FROM HoaDon
    INNER JOIN inserted ON HoaDon.IdHoaDon = inserted.IdHoaDon
    WHERE HoaDon.IdHoaDon = inserted.IdHoaDon;
END;
GO

CREATE TRIGGER trg_UpdateTongTien_TienDichVu
ON TienDichVu
AFTER UPDATE
AS
BEGIN
    UPDATE HoaDon
      SET TongTien = ISNULL((SELECT ThanhTien FROM TienDien WHERE IdHoaDon = HoaDon.IdHoaDon), 0) +
                    ISNULL((SELECT ThanhTien FROM TienNuoc WHERE IdHoaDon = HoaDon.IdHoaDon), 0) +
                    ISNULL((SELECT ThanhTien FROM TienDichVu WHERE IdHoaDon = HoaDon.IdHoaDon), 0)
    FROM HoaDon
    INNER JOIN inserted ON HoaDon.IdHoaDon = inserted.IdHoaDon
    WHERE HoaDon.IdHoaDon = inserted.IdHoaDon;
END;
GO


GO
CREATE PROCEDURE CheckExistHoaDon
    @ngayBD DATE,
    @ngayKT DATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM dbo.TienDien WHERE NgayBatDau = @ngayBD AND NgayKetThuc = @ngayKT)
    BEGIN
        SELECT 1 AS Exist;
    END
    ELSE IF EXISTS (SELECT 1 FROM dbo.TienDichVu WHERE NgayBatDau = @ngayBD AND NgayKetThuc = @ngayKT)
    BEGIN
        SELECT 1 AS Exist;
    END
    ELSE IF EXISTS (SELECT 1 FROM dbo.TienNuoc WHERE NgayBatDau = @ngayBD AND NgayKetThuc = @ngayKT)
    BEGIN
        SELECT 1 AS Exist;
    END
    ELSE
    BEGIN
        SELECT 0 AS Exist;
    END
END


--SELECT
--	hd.IdHoaDon,
--	hd.MaPhong,
--	hd.MaNhanVien,
--	hd.NgayLap,
--	hd.HanThanhToan,
--	hd.NgayThanhToan,
--	td.ThanhTien AS TienDien,
--	tn.ThanhTien AS TienNuoc,
--	dv.ThanhTien AS TienDichVu,
--	hd.TongTien,
--	hd.TrangThai
--FROM dbo.HoaDon hd 
--JOIN dbo.TienDien td ON td.IdHoaDon = hd.IdHoaDon
--JOIN dbo.TienNuoc tn ON tn.IdHoaDon = hd.IdHoaDon
--JOIN dbo.TienDichVu dv ON dv.IdDichVu = hd.IdHoaDon



-- Trigger mã nhân viên
IF OBJECT_ID('trg_InsertNhanVien', 'TR') IS NOT NULL
    DROP TRIGGER trg_InsertNhanVien;
GO
CREATE TRIGGER trg_InsertNhanVien
ON NhanVien
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @NextID int;
    DECLARE @MaNhanVien varchar(10);
    
    -- Tìm giá trị lớn nhất của MaNhanVien hiện có
    SELECT @NextID = ISNULL(MAX(CAST(SUBSTRING(MaNhanVien, 3, 3) AS int)), 0) + 1 FROM NhanVien;

    -- Tạo MaNhanVien từ số tiếp theo
    SET @MaNhanVien = 'NV' + RIGHT('000' + CAST(@NextID AS varchar(3)), 3);

    -- Chèn dữ liệu vào bảng NhanVien
    INSERT INTO NhanVien (MaNhanVien, HoTen, NgaySinh, GioiTinh, DienThoai, CCCD, NgayBatDau, NgayKetThuc, ThoiHan, anh, TrangThai)
    SELECT @MaNhanVien, HoTen, NgaySinh, GioiTinh, DienThoai, CCCD, NgayBatDau, NgayKetThuc, ThoiHan, anh, TrangThai
    FROM inserted;
END;