/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package repository.HopDong;

import dao.DBContext;
import java.sql.*;
import java.util.ArrayList;
import model.HopDong.ModelHopDong;

/**
 *
 * @author X1
 */
public class repositoryHopDong {

    private Connection con = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;
    private String sql = null;

    public repositoryHopDong() {
        try {
            con = DBContext.getConnection();
        } catch (Exception e) {
            e.printStackTrace();

        }

    }

    public ArrayList<model.HopDong.ModelHopDong> getAll(int td) {
        ArrayList<model.HopDong.ModelHopDong> arrHD = new ArrayList<>();
        sql = "select IdHopDong, MaPhong, IdKhach, SoNguoi, NgayBatDau, NgayKetThuc, ThoiHan, GiaPhong, SoTienCoc, DieuKhoan, TrangThai from HopDong where TrangThai = ?";
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            ps.setObject(1, td);
            rs = ps.executeQuery();
            while (rs.next()) {
                String maHD, maPT, maKT, dieuKhoan;
                int soNguoi, thoiHan;
                Date ngayBD, ngayKT;
                float giaPhong, tienCoc;
                boolean trangThai;
                maHD = rs.getString(1).trim();
                maPT = rs.getString(2).trim();
                maKT = rs.getString(3).trim();
                soNguoi = rs.getInt(4);
                ngayBD = rs.getDate(5);
                ngayKT = rs.getDate(6);
                thoiHan = rs.getInt(7);
                giaPhong = rs.getFloat(8);
                tienCoc = rs.getFloat(9);
                dieuKhoan = rs.getString(10);
                trangThai = rs.getBoolean(11);
                model.HopDong.ModelHopDong hd = new ModelHopDong(maHD, maPT, maKT, soNguoi, ngayBD, ngayKT, thoiHan, giaPhong, tienCoc, dieuKhoan, trangThai);
                arrHD.add(hd);

            }
            return arrHD;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public ArrayList<model.HopDong.ModelHopDong> getCbbMaPhong() {
        ArrayList<model.HopDong.ModelHopDong> arrCBBmaphong = new ArrayList<>();
        sql = "select MaPhong from PhongTro order by MaPhong";
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                String mapt;
                mapt = rs.getString(1).trim();

                ModelHopDong hdg = new ModelHopDong(mapt, mapt);
                arrCBBmaphong.add(hdg);
            }
            return arrCBBmaphong;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public ArrayList<model.HopDong.ModelHopDong> getCbbKT() {
        ArrayList<model.HopDong.ModelHopDong> arrCBBKT = new ArrayList<>();
        sql = "select IdKhach from KhachThue order by IdKhach desc";
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                String makt;
                makt = rs.getString(1);

                ModelHopDong hd = new ModelHopDong(makt, makt);
                arrCBBKT.add(hd);
            }
            return arrCBBKT;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public int them(model.HopDong.ModelHopDong x) {
        sql = "INSERT INTO HopDong (MaPhong, IdKhach, SoNguoi, NgayBatDau, NgayKetThuc, ThoiHan, GiaPhong, SoTienCoc, DieuKhoan, TrangThai) VALUES (?,?,?,?,?,?,?,?,?,?)";
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);

            ps.setObject(1, x.getMaPT());
            ps.setObject(2, x.getMaKT());
            ps.setObject(3, x.getSoNguoi());
            ps.setObject(4, x.getNgayBatDau());
            ps.setObject(5, x.getNgayKetThuc());
            ps.setObject(6, x.getThoiHan());
            ps.setObject(7, x.getGiaPhong());
            ps.setObject(8, x.getSoTienCoc());
            ps.setObject(9, x.getDieuKhoan());
            ps.setObject(10, x.isTrangThai());
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int sua(model.HopDong.ModelHopDong x) {
        sql = "update HopDong set MaPhong=?, IdKhach = ?, SoNguoi = ?, NgayBatDau = ?, NgayKetThuc = ?, ThoiHan = ?, GiaPhong = ?, SoTienCoc = ?, DieuKhoan =?, TrangThai =? where IdHopDong=?";
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);

            ps.setObject(1, x.getMaPT());
            ps.setObject(2, x.getMaKT());
            ps.setObject(3, x.getSoNguoi());
            ps.setObject(4, x.getNgayBatDau());
            ps.setObject(5, x.getNgayKetThuc());
            ps.setObject(6, x.getThoiHan());
            ps.setObject(7, x.getGiaPhong());
            ps.setObject(8, x.getSoTienCoc());
            ps.setObject(9, x.getDieuKhoan());
            ps.setObject(10, x.isTrangThai());
            ps.setObject(11, x.getMaHD());
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public ArrayList<model.HopDong.ModelHopDong> TimKiem(String ma, int tt) {
        ArrayList<model.HopDong.ModelHopDong> arrHD = new ArrayList<>();
        sql = "select IdHopDong, MaPhong, IdKhach, SoNguoi, NgayBatDau, NgayKetThuc, ThoiHan, GiaPhong, SoTienCoc, DieuKhoan, TrangThai from HopDong where (IdHopDong LIKE ? or  MaPhong LIKE ? or IdKhach LIKE ? or GiaPhong LIKE ?) and TrangThai=? ";
        try {
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            ps.setObject(1, "%" + ma + "%");//IdHopDong
            ps.setObject(2, "%" + ma + "%");//MaPhong
            ps.setObject(3, "%" + ma + "%");//IdKhach
            ps.setObject(4, "%" + ma + "%");//GiaPhong
            ps.setObject(5, tt);

            rs = ps.executeQuery();
            while (rs.next()) {
                String maHD, maPT, maKT, dieuKhoan;
                int soNguoi, thoiHan;
                Date ngayBD, ngayKT;
                float giaPhong, tienCoc;
                boolean trangThai;
                maHD = rs.getString(1).trim();
                maPT = rs.getString(2).trim();
                maKT = rs.getString(3).trim();
                soNguoi = rs.getInt(4);
                ngayBD = rs.getDate(5);
                ngayKT = rs.getDate(6);
                thoiHan = rs.getInt(7);
                giaPhong = rs.getFloat(8);
                tienCoc = rs.getFloat(9);
                dieuKhoan = rs.getString(10);
                trangThai = rs.getBoolean(11);
                ModelHopDong hd = new ModelHopDong(maHD, maPT, maKT, soNguoi, ngayBD, ngayKT, thoiHan, giaPhong, tienCoc, dieuKhoan, trangThai);
                arrHD.add(hd);
            }
            return arrHD;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public String check(String ma) {
        sql = "select MaPhong from HopDong where MaPhong=? and TrangThai=0";
        try {
            String mapt = null;
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            ps.setObject(1, ma);
//            ps.setObject(2, tt);
            rs = ps.executeQuery();
            while (rs.next()) {

                mapt = rs.getString(1);
            }
            return mapt;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public float getGiaPhong(String ma) {
        sql = "select GiaPhong from PhongTro where MaPhong=?";
        
        try {
            float gia = 0.0f;
            con = DBContext.getConnection();
            ps = con.prepareStatement(sql);
            ps.setObject(1, ma);

            rs = ps.executeQuery();
            while (rs.next()) {
                gia = rs.getFloat(1);
            }
            return gia;
        } catch (Exception e) {
            return 0;
        }
        

    }
}
