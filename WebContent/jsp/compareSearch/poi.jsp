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
				 // System.out.println("���� �ð� : "+ startTime);
				
			URL daumReq = new URL("http://map.daum.net/route/carset.json?roadside=ON&carMode="+SearchTypeD+"&carOption="+carOption+"&sX="+sx+"&sY="+sy+"&eX="+ex+"&eY="+ey+"");

			HttpURLConnection con = (HttpURLConnection)daumReq.openConnection();
			Object obj = JSONValue.parse(new InputStreamReader(con.getInputStream(),"UTF-8"));
			JSONObject jObj = (JSONObject)obj;
			if(JSONObject.toJSONString(jObj)=="null"){
				System.out.println("���û�Դϴ�.");
				daumReq = new URL("http://map.daum.net/route/carset.json?roadside=ON&carMode="+SearchTypeD+"&carOption="+carOption+"&sX="+sx+"&sY="+sy+"&eX="+ex+"&eY="+ey+"");
				con = (HttpURLConnection)daumReq.openConnection();
				obj = JSONValue.parse(new InputStreamReader(con.getInputStream(),"UTF-8"));
			}
			i=i/8;
			objResult = obj;
			
			//System.out.println(objResult.toString());
			long endTime = System.currentTimeMillis();    
			//  System.out.println("���� �ð� : "+ endTime + "\t�ɸ��ð� : " + (endTime-startTime));
			
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
			System.out.println("���û�Դϴ�.");
			daumReq = new URL("http://map.daum.net/route/carset.json?roadside=ON&carMode="+SearchTypeD+"&carOption="+carOption+"&sX="+sx+"&sY="+sy+"&eX="+ex+"&eY="+ey+"");
			con = (HttpURLConnection)daumReq.openConnection();
			obj = JSONValue.parse(new InputStreamReader(con.getInputStream(),"UTF-8"));
			System.out.println("���û�Ϸ�.");
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
     	System.out.println("�̰��� ��ġŸ��"+searchType);
     	String carOption = "car";
     	String searchTypeD ="";
		if (searchType == 1) {//�ִܰŸ�
			searchTypeD = "SHORTEST_DIST";
		} else if (searchType == 2) {//����
			searchTypeD = "SHORTEST_TIME";
		} else if (searchType == 3) { //����
			searchTypeD = "SHORTEST_REALTIME";
			carOption = "FREEWAY";
		} else if (searchType == 4) { //�ڵ��� ���뵵�� ����
			searchTypeD = "SHORTEST_REALTIME";
			carOption = "BIKE";
		} else if (searchType == 5) {
			searchTypeD = "SHORTEST_REALTIME";
		}
		
		
		DecimalFormat df3 = new DecimalFormat("###0");
		FileInputStream fis=new FileInputStream(multi.getFile("filename"));
		XSSFWorkbook workbook=new XSSFWorkbook(fis); //�б�W
		//XSSFWorkbook workbook=new XSSFWorkbook(request.getInputStream(),"UTF-8"); //�б�
		ArrayList<String> columnList=new ArrayList<String>(); //�б� �迭
		//ArrayList resultList=new ArrayList(); //����迭
		ArrayList<Object> objList=new ArrayList<Object>();
		ArrayList<Integer> errorList=new ArrayList<Integer>();
		ArrayList<Integer> indexList=new ArrayList<Integer>(); //���� 1�� �ε���
		ArrayList<String> categoryList=new ArrayList<String>(); //���� 2�� �з�
		ArrayList<String> startAreaList=new ArrayList<String>(); //���� 3�� ��� �ּ�
		ArrayList<String> arriveAreaList=new ArrayList<String>(); //���� 4�� �����ּ�
		ArrayList<Double> sxList=new ArrayList<Double>(); //5�� �����ǥx
		ArrayList<Double> syList=new ArrayList<Double>(); //6�� �����ǥy
		ArrayList<Double> exList=new ArrayList<Double>(); //7�� ������ǥx
		ArrayList<Double> eyList=new ArrayList<Double>(); //8�� ������ǥy
		
		ArrayList<Long> daumLengthList=new ArrayList<Long>(); //�б� �迭
		ArrayList<Long> sktLengthList=new ArrayList<Long>(); //�б� �迭
		ArrayList<Long> mappyLengthList=new ArrayList<Long>(); //�б� �迭
		ArrayList<Long> ollehLengthList=new ArrayList<Long>(); //�б� �迭
		ArrayList<Long> daumTimeList=new ArrayList<Long>(); //�б� �迭
		ArrayList<Long> sktTimeList=new ArrayList<Long>(); //�б� �迭
		ArrayList<Long> mappyTimeList=new ArrayList<Long>(); //�б� �迭
		ArrayList<Long> ollehTimeList=new ArrayList<Long>(); //�б� �迭
		
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
		//��Ʈ �� (ù��°���� �����ϹǷ� 0�� �ش�)
		//���� �� ��Ʈ�� �б����ؼ��� FOR���� �ѹ��� �����ش�
		XSSFSheet sheet=workbook.getSheetAt(0); //�б� ù��°��Ʈ�� 0
		//////////
		//������ �� 
		//XSSFRow wrow=null; //��� ���� ��
		//������ �� 
		//XSSFCell wcell=null; //��� ���� ��
		//Pattern p = Pattern.compile("zz");
		//���� ��
		int rows=sheet.getPhysicalNumberOfRows();
		for(rowindex=0;rowindex<rows;rowindex++){
		    //�����д´�
		    XSSFRow row=sheet.getRow(rowindex);
		    if(row !=null){
		        //���� ��
		        int cells=row.getPhysicalNumberOfCells();
		        for(columnindex=0;columnindex<=cells;columnindex++){
		            //������ �д´�
		            XSSFCell cell=row.getCell(columnindex);
		            String value="";
		            //���� ���ϰ�츦 ���� ��üũ
		            if(cell==null){
		                continue;
		            }else{
		                //Ÿ�Ժ��� ���� �б�
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
		System.out.println("�÷�����Ʈ"+columnList.size());
		 
		RouteParameters param = new RouteParameters();

		// ��θ� ��õ��η� Ž��
			if(searchType != 2 && searchType != 1 && searchType != 5){
				searchType = 2;
			}
			param.setRouteMode(searchType);
			param.setMakeGuide(false);

			//String serverAddr = "211.240.36.72";
			//int serverPort = 4781;
		
			RouteClient client = new RouteClient();		// ��ü ����
			//client.setServer(serverAddr, serverPort);	// ������������ ����
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
				//System.out.println("����ð�:"+(end-start));
				
			}
			long a1 = System.currentTimeMillis();
			for(Future<Object> futureInteger : llist){
				int i = 0;
				objList.add(futureInteger.get());
				i++;
			}
			long a2 = System.currentTimeMillis();
			System.out.println("objList�ɸ��ð�"+(a2-a1));
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
					System.out.println("2��°:"+(s3-s2));
				// �������� json �޾ƿ��� �κ�	
				
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
					String whatSource = whatSource1.intern(); //����� �����Ͽ� ���Ǯ�� �ö� ���� �ƴ϶� ==�� �� �Ұ�, ���� ���Ǯ�� ��ü�� ����� whatSource1�� ���
					String daum = "daum";
					String skp = "skp";
					String mn = "mn";
					String kt = "kt";
					if(whatSource == daum){
						daumLength = (Long)forObj.get("totalLength"); // ��������
						daumTime = (Long)forObj.get("expectedTime"); // ��������
					}else if(whatSource == skp){
						sktLength = (Long)forObj.get("totalLength"); // ��������
						sktTime = (Long)forObj.get("expectedTime"); // ��������
					}else if(whatSource == mn){
						mappyLength = (Long)forObj.get("totalLength"); // ��������
						mappyTime = (Long)forObj.get("expectedTime"); // ��������
					}else if(whatSource == kt){
						ollehLength = (Long)forObj.get("totalLength"); // ��������
						ollehTime = (Long)forObj.get("expectedTime"); // ��������
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
		System.out.println("����κ�");
	XSSFWorkbook wb = new XSSFWorkbook(); //�����
	//2���� sheet���� 
	XSSFSheet sht = wb.createSheet("new sheet"); //�����
	//������ �� 
	XSSFRow wrow = null; //��� ���� ��
	//������ �� 
	XSSFCell wcell = null; //��� ���� ��
	//���� ��
	
	//�������� ��Ÿ������
	XSSFCellStyle cellStyle = wb.createCellStyle();
	XSSFFont font = wb.createFont();
	font.setColor(new XSSFColor(new java.awt.Color(255, 0, 0)));
	font.setFontName("���� ���");
	cellStyle.setFont(font);
	//ù�� ī�װ��� ��Ÿ������
	XSSFCellStyle categoryCellStyle = wb.createCellStyle();
	XSSFFont categoryFont = wb.createFont();
	categoryFont.setBold(true);
	categoryCellStyle.setFont(categoryFont);
	categoryCellStyle.setFillBackgroundColor(new XSSFColor(new java.awt.Color(61, 183, 204)));
	categoryCellStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);
	
	//ù��
	wrow = sht.createRow(0);
	for(int i=0;i<18; i++){
	wcell = wrow.createCell(i);
		switch (i) {
		case 0:
			wcell.setCellValue("����");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 1:
			wcell.setCellValue("�з�");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 2:
			wcell.setCellValue("�����");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 3:
			wcell.setCellValue("������");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 4:
			wcell.setCellValue("����� X��ǥ");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 5:
			wcell.setCellValue("����� Y��ǥ");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 6:
			wcell.setCellValue("������ X��ǥ");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 7:
			wcell.setCellValue("������ Y��ǥ");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 8:
			wcell.setCellValue("���� ����ð�");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 9:
			wcell.setCellValue("���� ����ð�");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 10:
			wcell.setCellValue("SKT ����ð�");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 11:
			wcell.setCellValue("���� ����ð�");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 12:
			wcell.setCellValue("�÷� ����ð�");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 13:
			wcell.setCellValue("���� �����Ÿ�");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 14:
			wcell.setCellValue("���� �����Ÿ�");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 15:
			wcell.setCellValue("SKT �����Ÿ�");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 16:
			wcell.setCellValue("���� �����Ÿ�");
			wcell.setCellStyle(categoryCellStyle);
			break;
		case 17:
			wcell.setCellValue("�÷� �����Ÿ�");
			wcell.setCellStyle(categoryCellStyle);
			break;
			
		}
	}


	for (int q = 0; q < indexList.size(); q++) { // ũ�⸸ŭ �׷�����

		wrow = sht.createRow(q+1);
		for (int w = 0; w < 18; w++) { //�� 18��
			wcell = wrow.createCell(w);
			for(int e=0;e<errorList.size(); e++){ //�����ϰ�� �׷��ִ� �κ�
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
			if(chkCell == null || chkCell.getCellType() == XSSFCell.CELL_TYPE_BLANK){ //ä�缿�� ����������,�� ������ �ƴҰ��
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
	// ù�� ī�װ� ũ�⿡ �°� �� ũ�� ����
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
	//������ ����
	wb.write(fileoutputstream);
	//�ʼ��� �ݾ��־���� 
	fileoutputstream.close();
	System.out.println("�������ϻ�������");
	
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