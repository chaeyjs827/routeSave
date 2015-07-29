<%@ page import="java.io.File" %>
<%@ page import="java.io.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>파일다운로드</title>
</head>
<body>
<%!
	public String getFilePath(String... filePath) {
	/*...은 가변인자(Varialble Argument.)인자가 몇개가 될지 확실치 않을 때 확장성 있게 정해진 갯수가 아닌, 
	caller 쪽에서 정하는 갯수의 argument 를 갯수 상관없이 마음껏 받을 수 있다, 간단하게말하면 filePath는 array형식이 된다.*/
		String file = "";	
	
		for(String s : filePath) { //향상된 for문으로 배열의 내용 만큼 s에 저장하는 형식.[0]부터 [lastIndex]까지
			File f = new File(s);
			
			if(f.exists()) {
				file = s;
				break;
			}
		}
		
		return file;
	}
%>	
<%
	String fileName = "resultExcel.xlsx";
	
	ServletContext context = getServletContext();
	
	String realFolder = "D:\\";
	//String realFolder2 = context.getRealPath("D:\\");
	
	String filePath = realFolder + "/" + fileName;
	
	
	//String s = getFilePath(filePath, filePath2);
	String s = getFilePath(filePath);
	
	if(s==null || s.equals("") || s.equals("null")) {
		//out.write(fileName + " 파일이 존재하지 않습니다");
		return;
	}

	try{
		out.clear();
		out = pageContext.pushBody();
		//java.lang.IllegalStateException: getOutputStream() has already been called for this response
		// 아래 사용될 response.getOutputStream()때문에 생기는 에러를 잡기위한 구문으로, jsp자체의 outputStream을 제거해주는 구문이다.
		//반드시 getOutputStream()앞에 위치 시킬것
		
		File file = new File(s);
		
		byte b[] = new byte[4096];
		
		response.reset();
		response.setContentType("application/octet-stream");
		
		String Encoding = new String(fileName.getBytes("UTF-8"), "8859_1");
		response.setHeader("Content-Disposition", "attatchment; filename = " + Encoding);
		response.setHeader("Content-Length", String.valueOf((int)file.length()));
		
		FileInputStream is = new FileInputStream(filePath);
		ServletOutputStream sos = response.getOutputStream();
		
		int numRead;
		while((numRead = is.read(b,0,b.length)) != -1){
			sos.write(b,0,numRead);
		}
		
		sos.flush();
		sos.close();
		is.close();
	} catch(Exception e){
		e.printStackTrace();
	}
%>	
	
</body>
</html>