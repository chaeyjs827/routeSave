<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"
    
    
import="geomate.TomaTrans"
    %>
<%
String x = request.getParameter("xpos");
String y = request.getParameter("ypos");
double xpos = Double.parseDouble(x); // 변환할 WGS84 x좌표
double ypos = Double.parseDouble(y); // 변환할 WGS84 y좌표

TomaTrans.Coord coord = new TomaTrans.Coord(); // 변환된 좌표 받는 클래스

//TomaTrans.WGS84_to_KATECH(xpos, ypos, coord);
TomaTrans.KATECH_to_WGS84(xpos, ypos, coord);
double getX = coord.xlon;
double getY = coord.ylat;

%>
[{
"x":<%=getX %>,"y":<%=getY %>
}]