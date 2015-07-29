<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"
    
    
import="geomate.TomaTrans"
    %>
<%
String x = request.getParameter("xpos");
String y = request.getParameter("ypos");
double xpos = Double.parseDouble(x); // º¯È¯ÇÒ WGS84 xÁÂÇ¥
double ypos = Double.parseDouble(y); // º¯È¯ÇÒ WGS84 yÁÂÇ¥

TomaTrans.Coord coord = new TomaTrans.Coord(); // º¯È¯µÈ ÁÂÇ¥ ¹Þ´Â Å¬·¡½º

//TomaTrans.WGS84_to_KATECH(xpos, ypos, coord);
TomaTrans.KATECH_to_WGS84(xpos, ypos, coord);
double getX = coord.xlon;
double getY = coord.ylat;

%>
[{
"x":<%=getX %>,"y":<%=getY %>
}]