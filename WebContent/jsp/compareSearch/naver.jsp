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
		XSSFWorkbook workbook=new XSSFWorkbook(fis); //�б�W
		//XSSFWorkbook workbook=new XSSFWorkbook(request.getInputStream(),"UTF-8"); //�б�
		ArrayList<String> columnList=new ArrayList<String>(); //�б� �迭
		//ArrayList resultList=new ArrayList(); //����迭
		
		ArrayList<Integer> errorList=new ArrayList<Integer>();
		ArrayList<Integer> indexList=new ArrayList<Integer>(); //���� 1�� �ε���
		ArrayList<String> categoryList=new ArrayList<String>(); //���� 2�� �з�
		ArrayList<String> startAreaList=new ArrayList<String>(); //���� 3�� ��� �ּ�
		ArrayList<String> arriveAreaList=new ArrayList<String>(); //���� 4�� �����ּ�
		ArrayList<Double> sxList=new ArrayList<Double>(); //5�� �����ǥx
		ArrayList<Double> syList=new ArrayList<Double>(); //6�� �����ǥy
		ArrayList<Double> exList=new ArrayList<Double>(); //7�� ������ǥx
		ArrayList<Double> eyList=new ArrayList<Double>(); //8�� ������ǥy
		
		ArrayList<Long> naverLengthList=new ArrayList<Long>(); //�б� �迭
		
		ArrayList<Long> naverTimeList=new ArrayList<Long>(); //�б� �迭
		
		
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
		//System.out.println(rows);
		for(rowindex=0;rowindex<rows;rowindex++){
		    //�����д´�
		    XSSFRow row=sheet.getRow(rowindex);
		    if(row !=null){
		        //���� ��
		        int cells=row.getPhysicalNumberOfCells();
		       // System.out.println(cells);
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
					 
				
				// ���̹����� json �޾ƿ��� �κ�	
				URL naverReq = new URL("http://map.naver.com/spirra/findCarRoute.nhn?route=route3&output=json&result=web3&coord_type=naver&search=1&car=3&mileage=11.4&start="+sx+"%2C"+sy+"%2CS&destination="+ex+"%2C"+ey+"%2CS");
				//URL daumReq = new URL("http://map.daum.net/route/carset.json?roadside=ON&carMode=SHORTEST_REALTIME&carOption=NONE&sX=512197&sY=1122466&eX=503113&eY=1050750");
				//URL daumReq = new URL("http://localhost:8080/demo/jsp/compareSearch/search.jsp?startText=127.052529,37.547145&arriveText=127.059629,37.545002&searchType=2");
	
				HttpURLConnection con = (HttpURLConnection)naverReq.openConnection();
				Object obj = JSONValue.parse(new InputStreamReader(con.getInputStream(),"UTF-8"));
				JSONObject jObj = (JSONObject)obj;
				System.out.println(JSONObject.toJSONString(jObj));
				String data = JSONObject.toJSONString(jObj);
				
				if(data.contains("{\"error")){
					System.out.println("���̹����� ���Ž���� �����Ͽ� 0���� ġȯ�մϴ�.");
					String aa = "{\"routes\":[{\"summary\":{\"route_option\":1,\"distance\":0,\"copyrights\":\"nhn\",\"duration\":0}}]}";
					obj = JSONValue.parse(aa);
					jObj = (JSONObject)obj;
				}
				
				long naverLength = 0;
				long naverTime = 0;
				
				JSONArray JsonList = (JSONArray)jObj.get("routes"); 
				JSONObject routeZero = (JSONObject)JsonList.get(0);
				JSONObject summary = (JSONObject)routeZero.get("summary");
				
				naverLength = (Long)summary.get("distance"); // ��������
				naverTime = (Long)summary.get("duration"); // ��������
				

				
				naverLengthList.add(naverLength);
				naverTimeList.add(naverTime);
				
				

				System.out.println(j);
		 }
		/////////////////////////////////////////////
		
		System.out.println("����κ�");
	XSSFWorkbook wb = new XSSFWorkbook(); //�����
	//2���� sheet���� 
	XSSFSheet sht = wb.createSheet("new sheet"); //�����
	//������ �� 
	XSSFRow wrow = null; //��� ���� ��
	//������ �� 
	XSSFCell wcell = null; //��� ���� ��
	//���� ��
	
	for (int q = 0; q < naverLengthList.size(); q++) { // ũ�⸸ŭ �׷�����

		wrow = sht.createRow(q);
		for (int w = 0; w < 2; w++) { //�� 18��
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
	// ù�� ī�װ� ũ�⿡ �°� �� ũ�� ����
	
	FileOutputStream fileoutputstream = new FileOutputStream("D:\\resultExcel.xlsx");
	//������ ����
	wb.write(fileoutputstream);
	//�ʼ��� �ݾ��־���� 
	fileoutputstream.close();
	System.out.println("�������ϻ�������");
	
	//categoryList.add("\""+category+"\"");
	//startAreaList.add("\""+startArea+"\"");
	//arriveAreaList.add("\""+arriveArea+"\"");

 %>
