<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"
    
    
import="geomate.TomaTrans"
    %>
<%
String x = request.getParameter("xpos");
String y = request.getParameter("ypos");
double xpos = Double.parseDouble(x); // ��ȯ�� WGS84 x��ǥ
double ypos = Double.parseDouble(y); // ��ȯ�� WGS84 y��ǥ

TomaTrans.Coord coord = new TomaTrans.Coord(); // ��ȯ�� ��ǥ �޴� Ŭ����

//TomaTrans.WGS84_to_KATECH(xpos, ypos, coord);
TomaTrans.KATECH_to_WGS84(xpos, ypos, coord);
double getX = coord.xlon;
double getY = coord.ylat;

%>
[{
"x":<%=getX %>,"y":<%=getY %>
}]