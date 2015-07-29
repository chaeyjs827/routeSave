<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"
    
import ="java.io.FileInputStream"
import ="java.io.InputStreamReader"
import = "java.io.FileOutputStream"
import = "java.io.IOException"
import = "java.text.DecimalFormat"
import = "java.util.ArrayList"
import = "java.util.regex.Pattern"

import = "org.apache.poi.xssf.usermodel.XSSFCell"
import = "org.apache.poi.xssf.usermodel.XSSFRow"
import = "org.apache.poi.xssf.usermodel.XSSFSheet"
import = "org.apache.poi.xssf.usermodel.XSSFWorkbook"
import="org.apache.poi.xssf.usermodel.XSSFCellStyle"
import="org.apache.poi.xssf.usermodel.XSSFFont"
import="org.apache.poi.xssf.usermodel.XSSFColor"

import = "rsearch.connector.RouteClient"
import = "rsearch.connector.RouteParameters"
import = "rsearch.connector.RouteResult"

import = "java.net.URL"
import = "java.net.HttpURLConnection"
import = "java.net.MalformedURLException"
import = "org.json.simple.JSONObject"
import = "org.json.simple.JSONValue"
import = "org.json.simple.JSONArray"
import = "org.json.simple.parser.JSONParser"
import = "org.json.simple.parser.ParseException"

import = "java.awt.geom.Point2D"
import = "com.jhlabs.map.proj.Projection"
import = "com.jhlabs.map.proj.ProjectionFactory"

import="com.oreilly.servlet.MultipartRequest"
import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"

import="java.util.concurrent.Callable"
import="java.util.concurrent.ExecutionException"
import="java.util.concurrent.ExecutorService"
import="java.util.concurrent.Executors"
import="java.util.concurrent.Future"
import="java.util.concurrent.ThreadPoolExecutor"
 %>


<%
	/* JSONObject obj = (JSONObject)JSONValue.parse(request.getParameter("excelData"));
	System.out.println(obj.toJSONString());
	
	ArrayList<Integer> indexList = new ArrayList<Integer>();
	System.out.println("저장부분");
	XSSFWorkbook wb = new XSSFWorkbook(); //결과용
	//2차는 sheet생성 
	XSSFSheet sht = wb.createSheet("new sheet"); //결과용
	//엑셀의 행 
	XSSFRow wrow = null; //결과 엑셀 행
	//엑셀의 셀 
	XSSFCell wcell = null; //결과 엑셀 열
	//행의 수
	
	//에러셀의 스타일지정
	XSSFCellStyle cellStyle = wb.createCellStyle();
	XSSFFont font = wb.createFont();
	font.setColor(new XSSFColor(new java.awt.Color(255, 0, 0)));
	font.setFontName("맑은 고딕");
	cellStyle.setFont(font);
	//첫줄 카테고리의 스타일지정
	XSSFCellStyle categoryCellStyle = wb.createCellStyle();
	XSSFFont categoryFont = wb.createFont();
	categoryFont.setBold(true);
	categoryCellStyle.setFont(categoryFont);
	categoryCellStyle.setFillBackgroundColor(new XSSFColor(new java.awt.Color(61, 183, 204)));
	categoryCellStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);
	
	//첫줄
	wrow = sht.createRow(0);
	for(int i=0;i<18; i++){
	wcell = wrow.createCell(i);
		switch (i) {
		case 0:
			wcell.setCellValue("순번");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 1:
			wcell.setCellValue("분류");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 2:
			wcell.setCellValue("출발지");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 3:
			wcell.setCellValue("도착지");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 4:
			wcell.setCellValue("출발지 X좌표");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 5:
			wcell.setCellValue("출발지 Y좌표");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 6:
			wcell.setCellValue("도착지 X좌표");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 7:
			wcell.setCellValue("도착지 Y좌표");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 8:
			wcell.setCellValue("지센 운행시간");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 9:
			wcell.setCellValue("다음 운행시간");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 10:
			wcell.setCellValue("SKT 운행시간");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 11:
			wcell.setCellValue("맵피 운행시간");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 12:
			wcell.setCellValue("올레 운행시간");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 13:
			wcell.setCellValue("지센 구간거리");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 14:
			wcell.setCellValue("다음 구간거리");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 15:
			wcell.setCellValue("SKT 구간거리");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 16:
			wcell.setCellValue("맵피 구간거리");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 17:
			wcell.setCellValue("올레 구간거리");
			wcell.setCellStyle(categoryCellStyle);
			break;
			
		}
	}


	for (int q = 0; q < indexList.size(); q++) { // 크기만큼 그려낸다

		wrow = sht.createRow(q+1);
		for (int w = 0; w < 18; w++) { //총 18열
			wcell = wrow.createCell(w);
			for(int e=0;e<errorList.size(); e++){ //에러일경우 그려주는 부분
				if(indexList.get(q) == errorList.get(e)){
					switch (w) {
					case 0:
						wcell.setCellValue(((Integer) indexList.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					case 1:
						if(categoryList.get(q).equals("false")){
							
							categoryList.set(q, "");
							wcell.setCellValue(String.valueOf(categoryList.get(q)));
						}else{
						wcell.setCellValue(String.valueOf(categoryList.get(q)));
						}
						break;
					case 2:
						wcell.setCellValue(String.valueOf(startAreaList.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					case 3:
						wcell.setCellValue(String.valueOf(arriveAreaList.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					case 4:
						wcell.setCellValue(((Double) sxList.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					case 5:
						wcell.setCellValue(((Double) syList.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					case 6:
						wcell.setCellValue(((Double) exList.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					case 7:
						wcell.setCellValue(((Double) eyList.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					case 8:
						wcell.setCellValue(((Integer) gcenTime.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					case 9:
						wcell.setCellValue(((Long) daumTimeList.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					case 10:
						wcell.setCellValue(((Long) sktTimeList.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					case 11:
						wcell.setCellValue(((Long) mappyTimeList.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					case 12:
						wcell.setCellValue(((Long) ollehTimeList.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					case 13:
						wcell.setCellValue(((Integer) gcenDistance.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					case 14:
						wcell.setCellValue(((Long) daumLengthList.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					case 15:
						wcell.setCellValue(((Long) sktLengthList.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					case 16:
						wcell.setCellValue(((Long) mappyLengthList.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					case 17:
						wcell.setCellValue(((Long) ollehLengthList.get(q)));
						wcell.setCellStyle(cellStyle);
						break;
					}
				}
			};
			XSSFCell chkCell = wrow.getCell(w);
			if(chkCell == null || chkCell.getCellType() == XSSFCell.CELL_TYPE_BLANK){ //채당셀이 비어있을경우,즉 에러가 아닐경우
			switch (w) {
			case 0:
				wcell.setCellValue(((Integer) indexList.get(q)));
				break;
			case 1:
				if(categoryList.get(q).equals("false")){
					categoryList.set(q, "");
					wcell.setCellValue(String.valueOf(categoryList.get(q)));
				}else{
				wcell.setCellValue(String.valueOf(categoryList.get(q)));
				}
				break;
			case 2:
				wcell.setCellValue(String.valueOf(startAreaList.get(q)));
				break;
			case 3:
				wcell.setCellValue(String.valueOf(arriveAreaList.get(q)));
				break;
			case 4:
				wcell.setCellValue(((Double) sxList.get(q)));
				break;
			case 5:
				wcell.setCellValue(((Double) syList.get(q)));
				break;
			case 6:
				wcell.setCellValue(((Double) exList.get(q)));
				break;
			case 7:
				wcell.setCellValue(((Double) eyList.get(q)));
				break;
			case 8:
				wcell.setCellValue(((Integer) gcenTime.get(q)));
				break;
			case 9:
				wcell.setCellValue(((Long) daumTimeList.get(q)));
				break;
			case 10:
				wcell.setCellValue(((Long) sktTimeList.get(q)));
				break;
			case 11:
				wcell.setCellValue(((Long) mappyTimeList.get(q)));
				break;
			case 12:
				wcell.setCellValue(((Long) ollehTimeList.get(q)));
				break;
			case 13:
				wcell.setCellValue(((Integer) gcenDistance.get(q)));
				break;
			case 14:
				wcell.setCellValue(((Long) daumLengthList.get(q)));
				break;
			case 15:
				wcell.setCellValue(((Long) sktLengthList.get(q)));
				break;
			case 16:
				wcell.setCellValue(((Long) mappyLengthList.get(q)));
				break;
			case 17:
				wcell.setCellValue(((Long) ollehLengthList.get(q)));
				break;
			}
		}
		}
	}
	// 첫줄 카테고리 크기에 맞게 셀 크기 지정
	XSSFRow row = wb.getSheetAt(0).getRow(0);
	for(int colNum = 0; colNum<row.getLastCellNum();colNum++){
		//wb.getSheetAt(0).autoSizeColumn(colNum);
		switch(colNum){
		case 0:
			wb.getSheetAt(0).setColumnWidth(colNum, 4*256);
			break;
		case 1:
			wb.getSheetAt(0).setColumnWidth(colNum, 14*256);
			break;
		case 2:
			wb.getSheetAt(0).setColumnWidth(colNum, 36*256);
			break;
		case 3:
			wb.getSheetAt(0).setColumnWidth(colNum, 36*256);
			break;
		case 4:
			wb.getSheetAt(0).setColumnWidth(colNum, 12*256);
			break;
		case 5:
			wb.getSheetAt(0).setColumnWidth(colNum, 12*256);
			break;
		case 6:
			wb.getSheetAt(0).setColumnWidth(colNum, 12*256);
			break;
		case 7:
			wb.getSheetAt(0).setColumnWidth(colNum, 12*256);
			break;
		case 8:
			wb.getSheetAt(0).setColumnWidth(colNum, 13*256);
			break;
		case 9:
			wb.getSheetAt(0).setColumnWidth(colNum, 13*256);
			break;
		case 10:
			wb.getSheetAt(0).setColumnWidth(colNum, 13*256);
			break;
		case 11:
			wb.getSheetAt(0).setColumnWidth(colNum, 13*256);
			break;
		case 12:
			wb.getSheetAt(0).setColumnWidth(colNum, 13*256);
			break;
		case 13:
			wb.getSheetAt(0).setColumnWidth(colNum, 13*256);
			break;
		case 14:
			wb.getSheetAt(0).setColumnWidth(colNum, 13*256);
			break;
		case 15:
			wb.getSheetAt(0).setColumnWidth(colNum, 13*256);
			break;
		case 16:
			wb.getSheetAt(0).setColumnWidth(colNum, 13*256);
			break;
		case 17:
			wb.getSheetAt(0).setColumnWidth(colNum, 13*256);
			break;
		}
		
	}
	
	FileOutputStream fileoutputstream = new FileOutputStream("D:\\resultExcel.xlsx");
	//파일을 쓴다
	wb.write(fileoutputstream);
	//필수로 닫아주어야함 
	fileoutputstream.close();
	System.out.println("엑셀파일생성성공");
	
	//categoryList.add("\""+category+"\"");
	//startAreaList.add("\""+startArea+"\"");
	//arriveAreaList.add("\""+arriveArea+"\"");
	for(int c=0;c<categoryList.size();c++){
		categoryList.set(c,"\""+categoryList.get(c)+"\"");
		startAreaList.set(c,"\""+startAreaList.get(c)+"\"");
		arriveAreaList.set(c,"\""+arriveAreaList.get(c)+"\"");
	}
	long bb= System.currentTimeMillis();
	System.out.println(bb-aa); */
 %>