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
	
	/* class custom extends Thread {
		private int i;
		private String SearchTypeD;
		private String carOption;
		private double sx;
		private double sy;
		private double ex;
		private double ey;
		private Object objResult;
		
		public custom(String getType, String getOption,double getSx, double getSy, double getEx, double getEy, int getI){
			this.SearchTypeD = getType;
			this.carOption = getOption;
			this.sx=getSx;
			this.sy=getSy;
			this.ex=getEx;
			this.ey=getEy;
			this.i=getI;
			
		}
	
		public void run(){
			try{
				
				 long startTime = System.currentTimeMillis();    
				 // System.out.println("시작 시간 : "+ startTime);
				
			URL daumReq = new URL("http://map.daum.net/route/carset.json?roadside=ON&carMode="+SearchTypeD+"&carOption="+carOption+"&sX="+sx+"&sY="+sy+"&eX="+ex+"&eY="+ey+"");

			HttpURLConnection con = (HttpURLConnection)daumReq.openConnection();
			Object obj = JSONValue.parse(new InputStreamReader(con.getInputStream(),"UTF-8"));
			JSONObject jObj = (JSONObject)obj;
			if(JSONObject.toJSONString(jObj)=="null"){
				System.out.println("재요청입니다.");
				daumReq = new URL("http://map.daum.net/route/carset.json?roadside=ON&carMode="+SearchTypeD+"&carOption="+carOption+"&sX="+sx+"&sY="+sy+"&eX="+ex+"&eY="+ey+"");
				con = (HttpURLConnection)daumReq.openConnection();
				obj = JSONValue.parse(new InputStreamReader(con.getInputStream(),"UTF-8"));
			}
			i=i/8;
			objResult = obj;
			
			//System.out.println(objResult.toString());
			long endTime = System.currentTimeMillis();    
			//  System.out.println("종료 시간 : "+ endTime + "\t걸린시간 : " + (endTime-startTime));
			
			}catch(MalformedURLException e){
				e.printStackTrace();
			}catch(IOException e){
				e.printStackTrace();
			} 
		}
		public Object getResult() {
			return objResult;
		}
	} */
	
class customCall implements Callable<Object> {
	private String SearchTypeD;
	private String carOption;
	private double sx;
	private double sy;
	private double ex;
	private double ey;
	private Object objResult;
	
	public customCall(String getType, String getOption,double getSx, double getSy, double getEx, double getEy){
		this.SearchTypeD = getType;
		this.carOption = getOption;
		this.sx=getSx;
		this.sy=getSy;
		this.ex=getEx;
		this.ey=getEy;
				
	}

	public Object call() throws Exception{
		
			
		long aa= System.currentTimeMillis();	
		URL daumReq = new URL("http://map.daum.net/route/carset.json?roadside=ON&carMode="+SearchTypeD+"&carOption="+carOption+"&sX="+sx+"&sY="+sy+"&eX="+ex+"&eY="+ey+"");

		HttpURLConnection con = (HttpURLConnection)daumReq.openConnection();
		Object obj = JSONValue.parse(new InputStreamReader(con.getInputStream(),"UTF-8"));
		JSONObject jObj = (JSONObject)obj;
		if(JSONObject.toJSONString(jObj)=="null"){
			System.out.println("재요청입니다.");
			daumReq = new URL("http://map.daum.net/route/carset.json?roadside=ON&carMode="+SearchTypeD+"&carOption="+carOption+"&sX="+sx+"&sY="+sy+"&eX="+ex+"&eY="+ey+"");
			con = (HttpURLConnection)daumReq.openConnection();
			obj = JSONValue.parse(new InputStreamReader(con.getInputStream(),"UTF-8"));
			System.out.println("재요청완료.");
		}
		objResult = obj;
		long bb= System.currentTimeMillis();
		System.out.println(bb-aa);
		return objResult;
	}
	
}
		long aa= System.currentTimeMillis();
		System.out.println("POI2");
		
		int maxPostSize = 10 * 1024 * 1024; // 10MB
		String savePath = "D:/downloads";
     	MultipartRequest multi = new MultipartRequest(request,savePath,maxPostSize,"utf-8");
     	//MultipartRequest multi = new MultipartRequest(request,savePath,maxPostSize,"utf-8",new DefaultFileRenamePolicy());
     	
     	int searchType = Integer.parseInt(multi.getParameter("searchType"));
     	System.out.println("이것은 서치타입"+searchType);
     	String carOption = "car";
     	String searchTypeD ="";
		if (searchType == 1) {//최단거리
			searchTypeD = "SHORTEST_DIST";
		} else if (searchType == 2) {//최적
			searchTypeD = "SHORTEST_TIME";
		} else if (searchType == 3) { //무료
			searchTypeD = "SHORTEST_REALTIME";
			carOption = "FREEWAY";
		} else if (searchType == 4) { //자동차 전용도로 제외
			searchTypeD = "SHORTEST_REALTIME";
			carOption = "BIKE";
		} else if (searchType == 5) {
			searchTypeD = "SHORTEST_REALTIME";
		}
		
		
		DecimalFormat df3 = new DecimalFormat("###0");
		FileInputStream fis=new FileInputStream(multi.getFile("filename"));
		XSSFWorkbook workbook=new XSSFWorkbook(fis); //읽기W
		//XSSFWorkbook workbook=new XSSFWorkbook(request.getInputStream(),"UTF-8"); //읽기
		ArrayList<String> columnList=new ArrayList<String>(); //읽기 배열
		//ArrayList resultList=new ArrayList(); //쓰기배열
		ArrayList<Object> objList=new ArrayList<Object>();
		ArrayList<Integer> errorList=new ArrayList<Integer>();
		ArrayList<Integer> indexList=new ArrayList<Integer>(); //샘플 1열 인덱스
		ArrayList<String> categoryList=new ArrayList<String>(); //샘플 2열 분류
		ArrayList<String> startAreaList=new ArrayList<String>(); //샘플 3열 출발 주소
		ArrayList<String> arriveAreaList=new ArrayList<String>(); //샘플 4열 도착주소
		ArrayList<Double> sxList=new ArrayList<Double>(); //5월 출발좌표x
		ArrayList<Double> syList=new ArrayList<Double>(); //6열 출발좌표y
		ArrayList<Double> exList=new ArrayList<Double>(); //7열 도착좌표x
		ArrayList<Double> eyList=new ArrayList<Double>(); //8열 도착좌표y
		
		ArrayList<Long> daumLengthList=new ArrayList<Long>(); //읽기 배열
		ArrayList<Long> sktLengthList=new ArrayList<Long>(); //읽기 배열
		ArrayList<Long> mappyLengthList=new ArrayList<Long>(); //읽기 배열
		ArrayList<Long> ollehLengthList=new ArrayList<Long>(); //읽기 배열
		ArrayList<Long> daumTimeList=new ArrayList<Long>(); //읽기 배열
		ArrayList<Long> sktTimeList=new ArrayList<Long>(); //읽기 배열
		ArrayList<Long> mappyTimeList=new ArrayList<Long>(); //읽기 배열
		ArrayList<Long> ollehTimeList=new ArrayList<Long>(); //읽기 배열
		
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
		for(rowindex=0;rowindex<rows;rowindex++){
		    //행을읽는다
		    XSSFRow row=sheet.getRow(rowindex);
		    if(row !=null){
		        //셀의 수
		        int cells=row.getPhysicalNumberOfCells();
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
		 
		RouteParameters param = new RouteParameters();

		// 경로를 추천경로로 탐색
			if(searchType != 2 && searchType != 1 && searchType != 5){
				searchType = 2;
			}
			param.setRouteMode(searchType);
			param.setMakeGuide(false);

			//String serverAddr = "211.240.36.72";
			//int serverPort = 4781;
		
			RouteClient client = new RouteClient();		// 개체 생성
			//client.setServer(serverAddr, serverPort);	// 서버연결정보 설정
			client.setServer("origin.gcen.co.kr", 4701);
			
			//ExecutorService executorService = Executors.newFixedThreadPool(100);
			ThreadPoolExecutor executor = (ThreadPoolExecutor) Executors.newFixedThreadPool(10);
			ArrayList<Future<Object>> llist = new ArrayList<Future<Object>>();
			
			for(int j=8;j<columnList.size();j+=8){
				double sx = Double.valueOf(columnList.get(j+4)).doubleValue();
				double sy = Double.valueOf(columnList.get(j+5)).doubleValue();
				double ex = Double.valueOf(columnList.get(j+6)).doubleValue();
				double ey = Double.valueOf(columnList.get(j+7)).doubleValue();
				
				Point2D.Double start4326 = new Point2D.Double(sx, sy);
				Point2D.Double start5181 = new Point2D.Double();
				proj5181.transform(start4326,start5181);
				start5181.x = start5181.x*2.5;
				start5181.y = start5181.y*2.5;
				
				Point2D.Double arrive4326 = new Point2D.Double(ex, ey);
				Point2D.Double arrive5181 = new Point2D.Double();
				proj5181.transform(arrive4326,arrive5181);
				arrive5181.x = arrive5181.x*2.5;
				arrive5181.y = arrive5181.y*2.5;
				long start = System.currentTimeMillis();
				//custom thread = new custom(searchTypeD,carOption,start5181.x,start5181.y,arrive5181.x,arrive5181.y, j);
				//thread.start();
				customCall customC = new customCall(searchTypeD,carOption,start5181.x,start5181.y,arrive5181.x,arrive5181.y);
				//Future<Object> futureObject = executorService.submit(thread.getResult());
				Future<Object> futureObject = executor.submit(customC);
				//Future<Object> futureObject = executor.invokeAll(customC);
				
				llist.add(futureObject);
				long end = System.currentTimeMillis();
				//System.out.println("저장시간:"+(end-start));
				
			}
			long a1 = System.currentTimeMillis();
			for(Future<Object> futureInteger : llist){
				int i = 0;
				objList.add(futureInteger.get());
				i++;
			}
			long a2 = System.currentTimeMillis();
			System.out.println("objList걸린시간"+(a2-a1));
			System.out.println(objList.size());
			
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
				long s2 = System.currentTimeMillis();
				 	param.setStart(sx, sy);
					param.setGoal(ex, ey);
					RouteResult result = client.routeCalc(param);
					
					long s3 = System.currentTimeMillis();
					System.out.println("2번째:"+(s3-s2));
				// 다음에서 json 받아오는 부분	
				
				Object obj=objList.get((j/8)-1);
				JSONObject jObj = (JSONObject)obj;
				//System.out.println(jObj.toJSONString());
				
				long daumLength = 0;
				long daumTime = 0;
				long sktLength = 0;
				long sktTime = 0;
				long mappyLength = 0;
				long mappyTime = 0;
				long ollehLength = 0;
				long ollehTime = 0;
				JSONArray JsonList = (JSONArray)jObj.get("list"); 
				for(int k=0;k<JsonList.size();k++){
					JSONObject forObj = (JSONObject)JsonList.get(k);
					String whatSource1 = (String)forObj.get("source");
					String whatSource = whatSource1.intern(); //상수로 선언하여 상수풀에 올라간 것이 아니라서 ==로 비교 불가, 따라서 상수풀에 객체로 선언된 whatSource1을 등록
					String daum = "daum";
					String skp = "skp";
					String mn = "mn";
					String kt = "kt";
					if(whatSource == daum){
						daumLength = (Long)forObj.get("totalLength"); // 숫자형식
						daumTime = (Long)forObj.get("expectedTime"); // 숫자형식
					}else if(whatSource == skp){
						sktLength = (Long)forObj.get("totalLength"); // 숫자형식
						sktTime = (Long)forObj.get("expectedTime"); // 숫자형식
					}else if(whatSource == mn){
						mappyLength = (Long)forObj.get("totalLength"); // 숫자형식
						mappyTime = (Long)forObj.get("expectedTime"); // 숫자형식
					}else if(whatSource == kt){
						ollehLength = (Long)forObj.get("totalLength"); // 숫자형식
						ollehTime = (Long)forObj.get("expectedTime"); // 숫자형식
					}
				}
				int stack = 0;
				if(daumLength != 0){
					stack++;
				}
				if(sktLength != 0){
					stack++;
				}
				if(mappyLength != 0){
					stack++;
				}
				if(ollehLength != 0){
					stack++;
				}
				long avgDistance = (daumLength+sktLength+mappyLength+ollehLength)/stack;
				int gd = (int)result.totalDistance;
				long avgTime = (daumTime+sktTime+mappyTime+ollehTime)/stack;
				int gt = (int)result.totalTraveTime;
				if(gd > avgDistance+30*(avgDistance/100) || gd < avgDistance-30*(avgDistance/100)){
					errorList.add(index);
				}else if(gt > avgTime+30*(avgTime/100) || gd < avgTime-30*(avgTime/30)){
					errorList.add(index);
				}
				
				daumLengthList.add(daumLength);
				daumTimeList.add(daumTime);
				sktLengthList.add(sktLength);
				sktTimeList.add(sktTime);
				mappyLengthList.add(mappyLength);
				mappyTimeList.add(mappyTime);
				ollehLengthList.add(ollehLength);
				ollehTimeList.add(ollehTime);
				
					//int spendTime = (int) (end-start);
				indexList.add(index);
				//categoryList.add("\""+category+"\"");
				//startAreaList.add("\""+startArea+"\"");
				//arriveAreaList.add("\""+arriveArea+"\"");
				categoryList.add(category);
				startAreaList.add(startArea);
				arriveAreaList.add(arriveArea);
				sxList.add(sx);
				syList.add(sy);
				exList.add(ex);
				eyList.add(ey);
					
				//gcenDistance.add((df3.format(result.totalDistance)));
				gcenDistance.add((int)result.totalDistance);
				gcenTime.add((int)result.totalTraveTime);
				System.out.println(j);
		 }
		/////////////////////////////////////////////
		
	/* 	
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
	
	*/
	for(int c=0;c<categoryList.size();c++){
		categoryList.set(c,"\""+categoryList.get(c)+"\"");
		startAreaList.set(c,"\""+startAreaList.get(c)+"\"");
		arriveAreaList.set(c,"\""+arriveAreaList.get(c)+"\"");
	}
	long bb= System.currentTimeMillis();
	System.out.println(bb-aa); 
 %>
[{
"indexList": <%=indexList %>,"categoryList": <%=categoryList %>,"startAreaList": <%=startAreaList %>,"arriveAreaList": <%=arriveAreaList %>,
"sxList": <%=sxList %>,"syList": <%=syList %>,"exList": <%=exList %>,"eyList": <%=eyList %>,"gcenDistance": <%=gcenDistance %>, "gcenTime":<%=gcenTime %>,
"lengthList":{"daumLengthList": <%=daumLengthList %>,"sktLengthList": <%=sktLengthList %>,"mappyLengthList": <%=mappyLengthList %>,
"ollehLengthList": <%=ollehLengthList %>},"timeList":{"daumTimeList": <%=daumTimeList %>,"sktTimeList": <%=sktTimeList %>,"mappyTimeList": <%=mappyTimeList %>,
"ollehTimeList": <%=ollehTimeList %>},"errorList": <%=errorList %>
}]