<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"


import ="java.io.FileInputStream"
import ="java.io.InputStreamReader"
import = "java.io.FileOutputStream"
import = "java.io.IOException"
import = "java.text.DecimalFormat"
import = "java.util.ArrayList"
import = "java.util.regex.Pattern"
import = "java.util.regex.Matcher"

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


%>
<%		
		System.out.println("Naver");
		
		int maxPostSize = 10 * 1024 * 1024; // 10MB
		String savePath = "D:/downloads";
     	MultipartRequest multi = new MultipartRequest(request,savePath,maxPostSize,"utf-8");
     	//MultipartRequest multi = new MultipartRequest(request,savePath,maxPostSize,"utf-8",new DefaultFileRenamePolicy());
     	System.out.println(multi.getParameter("searchType"));
     	System.out.println(multi.getFilesystemName("filename"));
     	
		
		
		DecimalFormat df3 = new DecimalFormat("###0");
		FileInputStream fis=new FileInputStream(multi.getFile("filename"));
		XSSFWorkbook workbook=new XSSFWorkbook(fis); //읽기W
		//XSSFWorkbook workbook=new XSSFWorkbook(request.getInputStream(),"UTF-8"); //읽기
		ArrayList<String> columnList=new ArrayList<String>(); //읽기 배열
		//ArrayList resultList=new ArrayList(); //쓰기배열
		
		ArrayList<Integer> errorList=new ArrayList<Integer>();
		ArrayList<Integer> indexList=new ArrayList<Integer>(); //샘플 1열 인덱스
		ArrayList<String> categoryList=new ArrayList<String>(); //샘플 2열 분류
		ArrayList<String> startAreaList=new ArrayList<String>(); //샘플 3열 출발 주소
		ArrayList<String> arriveAreaList=new ArrayList<String>(); //샘플 4열 도착주소
		ArrayList<Double> sxList=new ArrayList<Double>(); //5월 출발좌표x
		ArrayList<Double> syList=new ArrayList<Double>(); //6열 출발좌표y
		ArrayList<Double> exList=new ArrayList<Double>(); //7열 도착좌표x
		ArrayList<Double> eyList=new ArrayList<Double>(); //8열 도착좌표y
		
		ArrayList<Long> naverLengthList=new ArrayList<Long>(); //읽기 배열
		
		ArrayList<Long> naverTimeList=new ArrayList<Long>(); //읽기 배열
		
		
		ArrayList<Integer> gcenDistance=new ArrayList<Integer>();
		ArrayList<Integer> gcenTime=new ArrayList<Integer>();
		
		String[] projParams5181 = {   
			    "+proj=tmerc",   
			    "+lat_0=38",  
			    "+lon_0=127",
			    "+k=1",   
			    "+x_0=200000",
			    "+y_0=500000",
			    "+ellps=GRS80",
			    "+units=m"
			};  
		Projection proj5181 
			= ProjectionFactory.fromPROJ4Specification(projParams5181);
		
		String List ="";
		int rowindex=0;
		int columnindex=0;
		//시트 수 (첫번째에만 존재하므로 0을 준다)
		//만약 각 시트를 읽기위해서는 FOR문을 한번더 돌려준다
		XSSFSheet sheet=workbook.getSheetAt(0); //읽기 첫번째시트면 0
		//////////
		//엑셀의 행 
		//XSSFRow wrow=null; //결과 엑셀 행
		//엑셀의 셀 
		//XSSFCell wcell=null; //결과 엑셀 열
		//Pattern p = Pattern.compile("zz");
		//행의 수
		int rows=sheet.getPhysicalNumberOfRows();
		//System.out.println(rows);
		for(rowindex=0;rowindex<rows;rowindex++){
		    //행을읽는다
		    XSSFRow row=sheet.getRow(rowindex);
		    if(row !=null){
		        //셀의 수
		        int cells=row.getPhysicalNumberOfCells();
		       // System.out.println(cells);
		        for(columnindex=0;columnindex<=cells;columnindex++){
		            //셀값을 읽는다
		            XSSFCell cell=row.getCell(columnindex);
		            String value="";
		            //셀이 빈값일경우를 위한 널체크
		            if(cell==null){
		                continue;
		            }else{
		                //타입별로 내용 읽기
		                switch (cell.getCellType()){
		                case XSSFCell.CELL_TYPE_FORMULA:
		                	columnList.add(cell.getCellFormula());
		                    break;
		                case XSSFCell.CELL_TYPE_NUMERIC:
		                	columnList.add(cell.getNumericCellValue()+"");
		                    break;
		                case XSSFCell.CELL_TYPE_STRING:
		                	columnList.add(cell.getStringCellValue()+"");
		                    break;
		                case XSSFCell.CELL_TYPE_BLANK:
		                	columnList.add(cell.getBooleanCellValue()+"");
		                    break;
		                case XSSFCell.CELL_TYPE_ERROR:
		                	columnList.add(cell.getErrorCellValue()+"");
		                    break;
		                }
		            }
		        }
		    }
		}
		//workbook.close();
		System.out.println("컬럼리스트"+columnList.size());
		 

		for(int j=8;j<columnList.size();j+=8){
				double index1 = Double.valueOf(columnList.get(j)).doubleValue();
				int index = (int)index1;
				String category = columnList.get(j+1);
				String startArea = columnList.get(j+2);
				String arriveArea = columnList.get(j+3);
				double sx = Double.valueOf(columnList.get(j+4)).doubleValue();
				double sy = Double.valueOf(columnList.get(j+5)).doubleValue();
				double ex = Double.valueOf(columnList.get(j+6)).doubleValue();
				double ey = Double.valueOf(columnList.get(j+7)).doubleValue();
					 
				
				// 네이버에서 json 받아오는 부분	
				URL naverReq = new URL("http://map.naver.com/spirra/findCarRoute.nhn?route=route3&output=json&result=web3&coord_type=naver&search=1&car=3&mileage=11.4&start="+sx+"%2C"+sy+"%2CS&destination="+ex+"%2C"+ey+"%2CS");
				//URL daumReq = new URL("http://map.daum.net/route/carset.json?roadside=ON&carMode=SHORTEST_REALTIME&carOption=NONE&sX=512197&sY=1122466&eX=503113&eY=1050750");
				//URL daumReq = new URL("http://localhost:8080/demo/jsp/compareSearch/search.jsp?startText=127.052529,37.547145&arriveText=127.059629,37.545002&searchType=2");
	
				HttpURLConnection con = (HttpURLConnection)naverReq.openConnection();
				Object obj = JSONValue.parse(new InputStreamReader(con.getInputStream(),"UTF-8"));
				JSONObject jObj = (JSONObject)obj;
				System.out.println(JSONObject.toJSONString(jObj));
				String data = JSONObject.toJSONString(jObj);
				
				if(data.contains("{\"error")){
					System.out.println("네이버에서 경로탐색에 실패하여 0으로 치환합니다.");
					String aa = "{\"routes\":[{\"summary\":{\"route_option\":1,\"distance\":0,\"copyrights\":\"nhn\",\"duration\":0}}]}";
					obj = JSONValue.parse(aa);
					jObj = (JSONObject)obj;
				}
				
				long naverLength = 0;
				long naverTime = 0;
				
				JSONArray JsonList = (JSONArray)jObj.get("routes"); 
				JSONObject routeZero = (JSONObject)JsonList.get(0);
				JSONObject summary = (JSONObject)routeZero.get("summary");
				
				naverLength = (Long)summary.get("distance"); // 숫자형식
				naverTime = (Long)summary.get("duration"); // 숫자형식
				

				
				naverLengthList.add(naverLength);
				naverTimeList.add(naverTime);
				
				

				System.out.println(j);
		 }
		/////////////////////////////////////////////
		
		System.out.println("저장부분");
	XSSFWorkbook wb = new XSSFWorkbook(); //결과용
	//2차는 sheet생성 
	XSSFSheet sht = wb.createSheet("new sheet"); //결과용
	//엑셀의 행 
	XSSFRow wrow = null; //결과 엑셀 행
	//엑셀의 셀 
	XSSFCell wcell = null; //결과 엑셀 열
	//행의 수
	
	for (int q = 0; q < naverLengthList.size(); q++) { // 크기만큼 그려낸다

		wrow = sht.createRow(q);
		for (int w = 0; w < 2; w++) { //총 18열
			wcell = wrow.createCell(w);
			switch (w) {
			case 0:
				wcell.setCellValue(((Long) naverTimeList.get(q)));
				break;
			case 1:
				wcell.setCellValue(((Long) naverLengthList.get(q)));
				break;
			
			}
		
		}
	}
	// 첫줄 카테고리 크기에 맞게 셀 크기 지정
	
	FileOutputStream fileoutputstream = new FileOutputStream("D:\\resultExcel.xlsx");
	//파일을 쓴다
	wb.write(fileoutputstream);
	//필수로 닫아주어야함 
	fileoutputstream.close();
	System.out.println("엑셀파일생성성공");
	
	//categoryList.add("\""+category+"\"");
	//startAreaList.add("\""+startArea+"\"");
	//arriveAreaList.add("\""+arriveArea+"\"");

 %>
