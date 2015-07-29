var hdms = 'a'; // 지도 클릭시 클릭한 좌표를 3857애서 4326으로 변환한 좌표
var map = ''; //지도
var startMLayer; // 출발점 마커
var viaMLayer; //경유지 마커
var arriveMLayer; //도착지 마커
var gcenLayer; //지센 엔진 경로
var daumLayer; //다음 엔진 경로
var sktLayer; //T맵 엔진 경로
var mappyLayer; //맵피 엔진 경로
var ollehLayer; //kt 엔진 경로
var gcenPoint;
var daumPoint;
var sktPoint;
var mappyPoint;
var ollehPoint;
var gcenOutLineLayer;
var daumOutLineLayer;
var sktOutLineLayer;
var mappyOutLineLayer;
var ollehOutLineLayer;

var params; // jsp로 넘길 파라미터
var arrJson2csv = [];
var arrayG = [];
var arrayD = [];
var arrayS = [];
var arrayM = [];
var arrayO = [];
var selectedMap;
// proj4js를 이용해 각 좌표의 설정
Proj4js.defs["E4326"] = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs";
Proj4js.defs["E5181"] = "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=500000 +ellps=GRS80 +units=m +no_defs";
Proj4js.defs["E3857"] = "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs";
Proj4js.defs['KATEC'] = '+proj=tmerc +lat_0=38 +lon_0=128 +ellps=bessel +x_0=400000 +y_0=600000 +k=0.9999 +towgs84=-146.43,507.89,681.46 +units=m +no_defs';
//Proj4js.defs["KATEC"] = "+proj=tmerc +lat_0=38 +lon_0=128 +ellps=bessel +x_0=400000 +y_0=600000 +k=0.9999 +towgs84=-146.43,507.89,681.46 +units=m +no_defs";
//Proj4js.defs["KATEC"] = "+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=bessel +units=m +no_defs +towgs84=-115.80,474.99,674.11,1.16,-2.31,-1.63,6.43";

var e4326 = new Proj4js.Proj("E4326");
var e5181 = new Proj4js.Proj("E5181");
var e3857 = new Proj4js.Proj("E3857");
var katec = new Proj4js.Proj("KATEC");
$(document)
		.ready(

				// 페이지가 켜지면 바로 지도 켜지게
				function() {
					/////////////sidebar resize
					var fw = $('#fileText').width();
					$('#files').css("width", fw + 26);

					var rh = $("#container").height()
							- ($("#myTab").height() + $("#my-tab-content")
									.height());
					$("#result").css("height", rh);

					var a = $('#container').width();
					$('.toggleOption').toggle(); //최초 숨김
					if (a >= 299) {
						$('#map').css("width", "calc(100% - 300px)");
						$('.toggleOption').css("left", "300px");
						$('.toggleButton').css("left", "299px");
					}
					/*
					else if(a < 299){
						$('#map').css("width","calc(100% - 30%)");
						$('.toggleOption').css("left","30%");
						$('.toggleButton').css("left","calc(30% - 1px)");
					}
					 */
					var container = document.getElementById('popup');
					var content = document.getElementById('popup-content');
					closer = document.getElementById('popup-closer');

					closer.onclick = function() { //팝업x눌렀을때 팝업 안보이게
						overlay.setPosition(undefined);
						closer.blur();
						return false;
					};

					/**
					 * Create an overlay to anchor the popup to the map.
					 */
					overlay = new ol.Overlay({
						element : container
					});

					/*
					var mousePositionControl = new ol.control.MousePosition({ //지도 위 마우스 위치 의 좌표를 4326으로 보여주기 위한 함수, 확인용도
						coordinateFormat : ol.coordinate.createStringXY(6),
						projection : 'EPSG:4326',
						// comment the following two lines to have the mouse position
						// be placed within the map.
						className : 'custom-mouse-position',
						target : document.getElementById('mouse-position'),
						undefinedHTML : '&nbsp;'
					});
					 */
					// create Layer Maps
					layerBingAerial = new ol.layer.Tile(
							{
								source : new ol.source.BingMaps(
										{
											key : 'Ak-dzM4wZjSqTlzveKz5u0d4IQ4bRzVI309GxmkgSVr1ewS6iPSrOvOKhA-CJlm3',
											imagerySet : 'AerialWithLabels'
										}),
								name : 'BingMaps'
							})

					layerBingRoad = new ol.layer.Tile(
							{
								source : new ol.source.BingMaps(
										{
											key : 'Ak-dzM4wZjSqTlzveKz5u0d4IQ4bRzVI309GxmkgSVr1ewS6iPSrOvOKhA-CJlm3',
											imagerySet : 'Road'
										}),
								name : 'BingMaps'
							})

					layerOSM = new ol.layer.Tile({
						source : new ol.source.OSM(),
						name : 'openStreetMap'
					})

					layerGMS = new ol.layer.Tile({
						title : "각종경로",
						source : new ol.source.XYZ({
							url : getBaseTileURL()
						}),
						name : 'GMS'
					})
					layerGoogleRoad = new ol.layer.Tile({
						title : "google",
						source : new ol.source.XYZ({
							url : getGoogleTileURL()
						}),
						name : 'GoogleRoad'
					})
					layerGoogleSatellite = new ol.layer.Tile({
						title : "google",
						source : new ol.source.XYZ({
							url : getGoogleSatTileURL()
						}),
						name : 'GoogleSatellite'
					})
					layerGoogleSatellitePOI = new ol.layer.Tile({
						title : "google",
						source : new ol.source.XYZ({
							url : getGoogleSatPOITileURL()
						}),
						name : 'GoogleSatellitePOI'
					})
					layerGoogleSatelliteGroup = new ol.layer.Group({
						layers : [ layerGoogleSatellite,
								layerGoogleSatellitePOI ]
					})

					selectedMap = layerGMS;

					view = new ol.View({ //처음 킬때 센터랑 지도 줌 상황, 민맥 지도 레벨
						center : ol.proj.transform([ 126.97835, 37.565841 ],
								"EPSG:4326", "EPSG:3857"),
						zoom : 9,
						maxZoom : 18,
						minZoom : 5

					});

					googleSatelliteView = new ol.View({ //처음 킬때 센터랑 지도 줌 상황, 민맥 지도 레벨
						center : ol.proj.transform([ 126.97835, 37.565841 ],
								"EPSG:4326", "EPSG:3857"),
						zoom : 9,
						maxZoom : 18,
						minZoom : 5

					});

					var olMapDiv = document.getElementById('map');
					map = new ol.Map({ // 지도를 뿌려주는 부분.
						interactions : ol.interaction.defaults().extend(
								[ new app.Drag() ]),
						controls : ol.control.defaults({
							attributionOptions : /** @type {olx.control.AttributionOptions} */
							({
								collapsible : false
							})
						}),//.extend([ mousePositionControl ]),//마우스포지션 컨트롤을 맵에 얹음

						target : olMapDiv, //'map'
						overlays : [ overlay ],
						layers : [ layerGMS ],
						view : view
					});

					//map.addLayer(layerOSM);
					map.on('click', function(evt) { //지도위에서 클릭 이벤트 발생했을때 , hdms에서 4326으로 변환한 좌표를 담는 용도, 팝업창에 내용 띄우는 용도.
						overlay.setPosition(undefined);
						closer.blur();
						
					});
					map.getViewport().addEventListener('contextmenu', function(evt){
						evt.preventDefault();
						var coordinate = map.getEventCoordinate(evt);//좌표  = 클릭 이벤트가 발생한 좌표 라는 뜻
						hdms = ol.coordinate.toStringXY(ol.proj.transform(
								coordinate, 'EPSG:3857', 'EPSG:4326'), 6);

						content.value = hdms;
						overlay.setPosition(coordinate); // 팝업 여기에 띄워
						//map.getView().setCenter(coordinate);////센타 잡기
					});
					/*window.oncontextmenu = function(evt) { //지도위에서 클릭 이벤트 발생했을때 , hdms에서 4326으로 변환한 좌표를 담는 용도, 팝업창에 내용 띄우는 용도.
						overlay.setPosition(undefined);
						closer.blur();
						return false;
						

					};
*/
					function getBaseTileURL() { //8081은 gmap3이 태워져있다.
						return "http://211.240.36.72:8081/tile/{z}/{x}/{y}";
						//return "http://localhost:8081/tile/{z}/{x}/{y}";
					}
					function getGoogleTileURL() { //구글 걍
						return "https://mts0.google.com/vt/lyrs=m@296000000&hl=ko&gl=KR&src=app&x={x}&y={y}&z={z}";
					}
					function getGoogleSatTileURL() { //구글 위성
						//return "https://khms1.google.co.kr/kh/v=169&src=app&x={x}&y={y}&z={z}"; //co.kr 버전/ 15레벨까지
						return "https://khms1.google.com/kh/v=169&src=app&x={x}&s=&y={y}&z={z}";
					}
					function getGoogleSatPOITileURL() { //위성POI
						//return "https://mts0.google.com/vt/lyrs=h@296000000&hl=ko&gl=KR&src=app&x={x}&y={y}&z={z}"; //한국 버전/ 15레벨까지
						return "https://mts0.google.com/vt/lyrs=h@296000000&hl=ko&src=app&x={x}&y={y}&z={z}"
					}

				});
/////////checkAll//////
//$("#result").delegate("input[name='check']", "click", function() {
$("#result").delegate("input[name='allCheck']", "click", function() {
	if ($("input[name='allCheck']").is(":checked") == true) {
		//$(this).is(":checked") == true
		$("input[name='check']").prop("checked", true);
		$("input[name='check']").trigger('change');
	} else {
		$("input[name='check']").prop("checked", false);
		$("input[name='check']").trigger('change');
	}
});
//wgs84 & katech//
function checkWgs84MBR(xpos, ypos) {
	if (xpos <= 131.8727 && xpos >= 124.6098 && ypos >= 33.1125
			&& ypos <= 38.6204) {
		return true;
	} else {
		return false;
	}
}

// 카텍좌표 유효성 체크
function checkKatechMBR(xpos, ypos) {
	//alert("카텍 유효성 체크 : " + xpos +" / " + ypos);
	if (xpos <= 743865 && xpos >= 102291 && ypos >= 58804 && ypos <= 668610) {
		return true;
	} else {
		return false;
	}
}

///////////////drag&drop////////
window.app = {};
var app = window.app;
/**
 * @constructor
 * @extends {ol.interaction.Pointer}
 */
app.Drag = function() {

	ol.interaction.Pointer.call(this, {
		handleDownEvent : app.Drag.prototype.handleDownEvent,
		handleDragEvent : app.Drag.prototype.handleDragEvent,
		handleMoveEvent : app.Drag.prototype.handleMoveEvent,
		handleUpEvent : app.Drag.prototype.handleUpEvent
	});

	this.coordinate_ = null;

	this.cursor_ = 'pointer';

	this.feature_ = null;

	this.previousCursor_ = undefined;

};
ol.inherits(app.Drag, ol.interaction.Pointer);

app.Drag.prototype.handleDownEvent = function(evt) { ////없으면 클릭모양은 되는데 안움직임
	var map = evt.map;

	var feature = map.forEachFeatureAtPixel(evt.pixel,
			function(feature, layer) {
				return feature.get('draggable') ? feature : undefined;
			});

	if (feature) {
		this.coordinate_ = evt.coordinate;
		this.feature_ = feature;
	}

	return !!feature;
};

app.Drag.prototype.handleDragEvent = function(evt) { //없으면 클릭되고 안움직;
	var map = evt.map;

	var feature = map.forEachFeatureAtPixel(evt.pixel,
			function(feature, layer) {
				return feature.get('draggable') ? feature : undefined;
			});

	var deltaX = evt.coordinate[0] - this.coordinate_[0];
	var deltaY = evt.coordinate[1] - this.coordinate_[1];

	var geometry = /** @type {ol.geom.SimpleGeometry} */
	(this.feature_.getGeometry());
	geometry.translate(deltaX, deltaY);

	this.coordinate_[0] = evt.coordinate[0];
	this.coordinate_[1] = evt.coordinate[1];
};

app.Drag.prototype.handleMoveEvent = function(evt) { // 클릭 손가락
	if (this.cursor_) {
		var map = evt.map;
		var feature = map.forEachFeatureAtPixel(evt.pixel, function(feature,
				layer) {
			return feature.get('draggable') ? feature : undefined;
		});
		var element = evt.map.getTargetElement();
		if (feature) {
			if (element.style.cursor != this.cursor_) {
				this.previousCursor_ = element.style.cursor;
				element.style.cursor = this.cursor_;
			}
		} else if (this.previousCursor_ !== undefined) {
			element.style.cursor = this.previousCursor_;
			this.previousCursor_ = undefined;
		}
	}
};

app.Drag.prototype.handleUpEvent = function(evt) {
	// this.feature_.values_.geometry.flatCoordinates ==== 해당 피쳐의 좌표 정보
	handUpHdms = ol.coordinate.toStringXY(ol.proj.transform(
			this.feature_.values_.geometry.flatCoordinates, 'EPSG:3857',
			'EPSG:4326'), 6);
	if (this.feature_.values_.id == "iconStart") {
		document.getElementById("startText").value = handUpHdms;
	} else if (this.feature_.values_.id == "iconArr") {
		document.getElementById("arriveText").value = handUpHdms;
	}
	if (document.getElementById("startText").value != "") {
		if (document.getElementById("arriveText").value != "") {
			search();
		}
	}
	this.coordinate_ = null;
	this.feature_ = null;
	return false;
};

//////////////////////샘플 엑셀 파일 관련
function readFile() {
	var files = document.getElementById("files").files;
	if (!files.length) {
		alert("파일을 선택해주세요");
		document.getElementById("fileText").value = "";
		return;
	}

	//document.getElementById("allFilePath").value = document.selection.createRange().text.toString();
	filename = files[0];

	var file = files[0];

	//파일 사이즈 나오게 하는 부분 document.getElementById("fileSize").textContent = file.size + "bytes";

	var reader = new FileReader();

	reader.onload = function(evt) {
		resultContent = event.target.result;
	};

	reader.onerror = function(event) {
		var errcode = event.target.error.code;
		if (errcode == 1) {
			alert("file을 못찾음");
		} else if (errcode == 2) {
			alert("안전 못하거나file이 변경");
		} else if (errcode == 3) {
			alert("읽기 중지됨");
		} else if (errcode == 4) {
			alert("접근 권한 문제로 못읽음");
		} else if (errcode == 5) {
			alert("URL 길이 제한");
		}
	};

	reader.readAsText(file); //기본인코딩은 uft-8
	document.getElementById("fileText").value = file.name;
}
/*
function runRoute() {
	select = "runFiles";

	var repContentText = resultContent.replace(/\r\n/gi, ",");
	contentCoord = repContentText.split(",");
	searchType = 2;

	(function looper(i) {
		setTimeout(function() {
			startText = contentCoord[i] + ', ' + contentCoord[i + 1];
			arriveText = contentCoord[i + 2] + ', '
					+ contentCoord[i + 3];
			i += 3;
			searchAjax(startText, arriveText, searchType)
			if (contentCoord.length - 1 > ++i)
				looper(i);
		}, 2000)
	})(0);

}
 */
function runRoute() {
	if (typeof filename == "undefined") {
		alert("파일을 선택해주세요");
		return;
	}
	var filen = filename;
	var formData = new FormData();

	searchType = $('select[name="sampleSearchType"] > option:selected').val();
	if ($("#sampleTraffic").is(":checked") == true && searchType == 2) {
		searchType = 5;
	}
	formData.append("filename", filen);
	formData.append("searchType", searchType);
	//data.append("searchType",searchType);
	sampleSearchAjax(formData);
}
function sampleSearchAjax(formData) {
	$
			.ajax({
				url : "poi.jsp",
				type : "post",
				data : formData,
				dataType : "json",
				processData : false,
				contentType : false,
				beforeSend : function() {
					//이미지 보여주기 처리
					loading = $(
							'<div id="loading" class="loading"></div><img id="loading_img" alt="loading" src="../../img/compareSearch/loader.gif" />')
							.appendTo(document.body).hide();
					loading.show();
				},
				success : function(data) {
					loading.hide();
					changeErrorSelect(data);
				},
				error : function(jqXHR, textStatus, errorThrown) {
					var errorMsg = 'status(code) : ' + jqXHR.status + '\n';
					errorMsg += 'statusText : ' + jqXHR.statusText + '\n';
					errorMsg += 'responseText : ' + jqXHR.responseText + '\n';
					errorMsg += 'textStatus : ' + textStatus + '\n';
					errorMsg += 'errorThrown : ' + errorThrown;
					console.log(errorMsg);
					loading.hide();
				}
			});
}
function changeErrorSelect(data) {
	
	$("#inFileList").html("");
	$("#inFileList").append("<option value='select'>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp::: 선택 :::</option>");
	//var arrSxList = data[0].sxList.split(",");
	for (var i = 0; i < data[0].indexList.length; i++) {
		var chk;

		for (var j = 0; j < data[0].errorList.length; j++) {
			if (data[0].indexList[i] == data[0].errorList[j]) {
				$("#inFileList").append(
						"<option style=" + "color:red;" + " value='" + i + "'>"
								+ data[0].startAreaList[i] + "->"
								+ data[0].arriveAreaList[i] + "</option>");
				chk = i;
				break;
			}
		}
		if (chk != i) {
			$("#inFileList").append(
					"<option value='" + i + "'>" + data[0].startAreaList[i]
							+ "->" + data[0].arriveAreaList[i] + "</option>");
		}
		//$("#inFileList").append("<option value='"+i+"'>"+data[0].sxList[i]+","+data[0].syList[i]+"->"+data[0].exList[i]+","+data[0].eyList[i]+"</option>");
	}
	//listSearch(data);
	excelData = data;

	// changeOnlyErrorSelect(data);
}

$("#errorOnly").click(
		function() {
			if (typeof excelData != "undefined") {
				if ($("#errorOnly").is(":checked") == true) {
					$("#inFileList").html("");
					$("#inFileList").append("<option value='select'>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp::: 선택 :::</option>");
					for (var i = 0; i < excelData[0].errorList.length; i++) {
						var j = excelData[0].errorList[i] - 1;
						$("#inFileList").append(
								"<option style=" + "color:red;" + " value='"
										+ j + "'>"
										+ excelData[0].startAreaList[j] + "->"
										+ excelData[0].arriveAreaList[j]
										+ "</option>");
						//$("#inFileList").append("<option value='"+i+"'>"+data[0].sxList[i]+","+data[0].syList[i]+"->"+data[0].exList[i]+","+data[0].eyList[i]+"</option>");
					}
					//listSearch(exceldata);
				} else {
					changeErrorSelect(excelData);
				}
			}
		});

$("#inFileList").change(function() {
	
	var index = $(this).val();
	if(index == "select"){
		return;
	}else{
		var s = excelData[0].sxList[index] + "," + excelData[0].syList[index];
		var e = excelData[0].exList[index] + "," + excelData[0].eyList[index];
		searchType = $('select[name="sampleSearchType"] > option:selected').val();
		if ($("#sampleTraffic").is(":checked") == true && searchType == 2) {
			searchType = 5;
		}
		drawIconStart(s);
		drawIconArr(e);
		searchAjax(s, e, searchType);
	}
})

function selectType() { //경로비교
	if ($('select[name="searchType"] > option:selected')[0].id == "optimum") {
		$('#traffic').attr("disabled", false);
	} else {
		$('#traffic').attr("disabled", true);
	}
}
function sampleSelectType() { //샘플비교
	if ($('select[name="sampleSearchType"] > option:selected')[0].id == "sampleOptimum") {
		$('#sampleTraffic').attr("disabled", false);
	} else {
		$('#sampleTraffic').attr("disabled", true);
	}
}

////Select MAP////
function selectMap() {
	var selectMap = eval($('select[name="mapSelect"]>option:selected').val());
	if (selectedMap != selectMap) {

		//raiseMaps(selectedMap, selectMap);
		if (selectMap == layerGoogleSatelliteGroup) {
			googleSatelliteView.setCenter(view.getCenter());
			googleSatelliteView.setZoom(view.getZoom());
			map.setView(googleSatelliteView);

		} else {
			if (selectedMap == layerGoogleSatelliteGroup) {
				view.setCenter(googleSatelliteView.getCenter());
				view.setZoom(googleSatelliteView.getZoom());
			}
			map.setView(view);
		}
		raiseMaps(selectedMap, selectMap);
	}
}

/////////////////////탭 메뉴
jQuery(document).ready(function($) {
	$('#tabs').tab();
});
///////////////////////지도 리사이즈
$(window)
		.resize(
				function() {
					var a = $('#container').width();
					if (a >= 299) {
						$('#map').css("width", "calc(100% - 300px)");
						$('.toggleOption').css("left", "300px");
						$('.toggleButton').css("left", "299px");
						var rh = $("#container").height()
								- ($("#myTab").height() + $("#my-tab-content")
										.height());
						$("#result").css("height", rh);
					}
					/*
					else if (a < 299) {
						$('#map').css("width", "calc(100% - 30%)");
						$('.toggleOption').css("left","30%");
						$('.toggleButton').css("left","calc(30% - 1px)");
					}
					 */
				});
///////////////////옵션메뉴 toggle
function displayOption() {
	if (hide_btn.style.display == "") {
		hide_btn.style.display = "none";
		show_btn.style.display = "";
		$('.toggleOption').toggle();
	} else if (show_btn.style.display == "") {
		show_btn.style.display = "none";
		hide_btn.style.display = "";
		$('.toggleOption').toggle();
	}
}
//////////좌표  변경 부분
function get3857(x, y) { //wgs84(4326)을 오픈레이어 기분인 구굴(3857)으로 변환하는 부분, rsearch로 보내 처리 한 좌표 값을 다시 오픈레이어에 뿌리기위해 사용
	return ol.proj.transform([ x, y ], "EPSG:4326", "EPSG:3857");
}
function get5to3(x, y) { // 다음 맵은 tm(중부원점)을 변형하여 사용한다. 그 값을 다시 3857로변환하는 함수
	x = x / 2.5; //변환 식은 tm *2.5
	y = y / 2.5;
	var get5 = new Proj4js.Point(x, y); //하나의 x,y좌표로 받아
	Proj4js.transform(e5181, e3857, get5); //5181을 3857로 변환 한다.
	return [ get5.x, get5.y ]; //
}
/*
function getKtoW(x, y) {
	var getK = new Proj4js.Point(x, y);
	Proj4js.transform(katec, e4326, getK);
	return [ getK.x, getK.y ];
}
 */
function getKtoW(x, y) {
	var x;
	var y;
	$.ajax({
		url : "transPos.jsp",
		type : "post",
		async : false,
		data : {
			//roadside : 'ON',
			xpos : x,
			ypos : y
		},
		dataType : "json",
		success : function(data) {
			x = data[0].x;
			y = data[0].y;
			//return [ data[0].x, data[0].y ];
		},
		error : function(jqXHR, textStatus, errorThrown) {
			var errorMsg = 'status(code) : ' + jqXHR.status + '\n';
			errorMsg += 'statusText : ' + jqXHR.statusText + '\n';
			errorMsg += 'responseText : ' + jqXHR.responseText + '\n';
			errorMsg += 'textStatus : ' + textStatus + '\n';
			errorMsg += 'errorThrown : ' + errorThrown;
			console.log(errorMsg);
		}
	});
	return [ x, y ];
}
///////////
function drawIconStart(startText) {

	map.removeLayer(startMLayer); // 처음에 지우는 이유 = 지우고 찍어야 옮겨가는느낌이 든다.
	var vectorSource = new ol.source.Vector();
	startMLayer = new ol.layer.Vector({
		source : vectorSource,
		style : new ol.style.Style({
			image : new ol.style.Icon({
				anchor : [ 0.5, 46 ],
				anchorXUnits : 'fraction',
				anchorYUnits : 'pixels',
				opacity : 0.75,
				src : '../../img/compareSearch/pin_red.png'
			})
		})
	});

	map.addLayer(startMLayer); //지도상에 마커 얹기 ////////여기까지  얹는 부분

	var startCoordArr = startText.split(",");
	startCoordArrX = parseFloat(startCoordArr[0], 10); //숫자형으로 바꿔지고
	startCoordArrY = parseFloat(startCoordArr[1], 10);

	if (checkKatechMBR(startCoordArrX, startCoordArrY) == true) {
		var s = getKtoW(startCoordArrX, startCoordArrY);
		startCoordArrX = s[0];
		startCoordArrY = s[1];
	}

	iconFeatureSt = new ol.Feature({
		id : "iconStart",
		geometry : new ol.geom.Point(get3857(startCoordArrX, //그값 은 4326이니까 3857로 변환 
		startCoordArrY)),
		draggable : true
	});

	vectorSource.addFeature(iconFeatureSt);

	overlay.setPosition(undefined);
	closer.blur();

}

function startPoint() { // 출발지 버튼 클릭시 해당좌표에 마커 올리는 부분

	document.getElementById("startText").value = hdms; //출발지 버튼을 클릭하면 텍스트부분에  좌표를 뿌려준다. 나중엔 주소로..?
	var startText = document.getElementById("startText").value;
	drawIconStart(startText);
	if (document.getElementById("startText").value != "") {
		if (document.getElementById("arriveText").value != "") {
			search();
		}
	}
}
function drawIconArr(arriveText) {
	map.removeLayer(arriveMLayer);

	var vectorSource = new ol.source.Vector();
	arriveMLayer = new ol.layer.Vector({
		source : vectorSource,
		style : new ol.style.Style({
			image : new ol.style.Icon({
				anchor : [ 0.5, 46 ],
				anchorXUnits : 'fraction',
				anchorYUnits : 'pixels',
				opacity : 0.75,
				src : '../../img/compareSearch/pin_blue.png'
			})
		})
	});

	map.addLayer(arriveMLayer);
	//var arriveCoodArr = document.getElementById("arriveText").value;
	var arriveCoordArr = arriveText.split(",");
	arriveCoordArrX = parseFloat(arriveCoordArr[0], 10);
	arriveCoordArrY = parseFloat(arriveCoordArr[1], 10);

	if (checkKatechMBR(arriveCoordArrX, arriveCoordArrY) == true) {
		var s = getKtoW(arriveCoordArrX, arriveCoordArrY);
		arriveCoordArrX = s[0];
		arriveCoordArrY = s[1];
	}

	var iconFeatureArr = new ol.Feature(
			{
				id : "iconArr",
				geometry : new ol.geom.Point(get3857(arriveCoordArrX,
						arriveCoordArrY)),
				draggable : true
			});
	vectorSource.addFeature(iconFeatureArr);
	overlay.setPosition(undefined);
	closer.blur();
	//return false;
}
function arrivePoint() {
	document.getElementById("arriveText").value = hdms;
	var arriveText = document.getElementById("arriveText").value;
	drawIconArr(arriveText);
	if (document.getElementById("startText").value != "") {
		if (document.getElementById("arriveText").value != "") {
			search();
		}
	}
}

/*
$(function (){
	//selectButton
	
	$("#selectButton").delegate("#via", "click", function(){
		
		$("#divVia").append('<div class = "appVia">경유지 <input type="text" id="viaText" name="viaText" value="" /><input type="button" id="delVia" name="delVia" value="-"/></div>');
			

				$("input[name='viaText']").val(hdms);
				//document.getElementById("viaText").value = hdms;
				map.removeLayer(viaMLayer);
				
				var vectorSource = new ol.source.Vector(); 
				viaMLayer  = new ol.layer.Vector({
					source: vectorSource,
					style: new ol.style.Style({
						image: new ol.style.Icon ({
						    anchor: [0.5, 46],
						    anchorXUnits: 'fraction',
						    anchorYUnits: 'pixels',
						    opacity: 0.75,
							src: './image/icon.png'
						})
					})
				});
				
				map.addLayer(viaMLayer);
				//aa();
				
				//document.getElementById("viaText").value = hdms;
				//var viaCoodArr = document.getElementById("viaText").value;
				var viaCoordArr = document.getElementById("viaText").value.split(",");
				viaCoordArrX = parseFloat(viaCoordArr[0], 10);
				viaCoordArrY = parseFloat(viaCoordArr[1], 10);
				
				var iconFeature = new ol.Feature({
					geometry: new ol.geom.Point(get3857(viaCoordArrX, viaCoordArrY)) 
				});

				vectorSource.addFeature(iconFeature);
		
			//document.getElementById("viaText").value = hdms;
		
		//aa = $("input[name='delVia']");
		//len = aa.length;
		//alert(len);
	});
		//for(var i=0;i<=len;i++){
		$("#divVia").delegate("input[name='delVia']", "click", function(){
			var i = $("input[name='delVia']").index(this);
			//alert(i);
			$(".appVia").eq(i).remove();
			
			//alert("흐흐흐흐");
		});
		//}
});
 */

function route(allRoutes) { // search.jsp에서 받아온 경로좌표(allRoutes)를 지도상에 뿌려주는 부분//4326
	allRoute = allRoutes.split(",");//x,y,x,y,x,y... 형식이다.
	array = []; //3857로 변환한 좌표값을 담을 배열

	for (i = 0; i < allRoute.length; i += 2) { // [x, y], [x, y], [x, y]..형식으로 배열에 담는다(LineStirng형식에 맞게) 
		coordX = parseFloat(allRoute[i], 10);
		coordY = parseFloat(allRoute[i + 1], 10);
		array.push(get3857(coordX, coordY));
	}
	lineFeature = new ol.Feature({
		geometry : new ol.geom.LineString(array)
	//배열을 넣는다. 1,2,3... 이면 1부터 2그리고, 2부터 3그리고 3부터 4그리고.. 형식임
	});

	lineSource = new ol.source.Vector();
	gcenLayer = new ol.layer.Vector({
		source : lineSource,
		style : new ol.style.Style({
			stroke : new ol.style.Stroke({
				color : "rgba(255,0,0,1)",//선 색 빨간색으로
				width : 5
			})
		})
	});
	//그려주는부분, 로딩 div지움

	gcenOutLineLayer = new ol.layer.Vector({
		source : lineSource,
		style : new ol.style.Style({
			stroke : new ol.style.Stroke({
				color : "rgba(1,1,1,1)",
				width : 8
			})
		})
	});
	map.addLayer(gcenLayer);
	map.addLayer(gcenOutLineLayer);
	gcenOutLineLayer.setVisible(false);

	lineSource.addFeature(lineFeature);
}

function daumsRoute(json) {
	var arrayJ = (json);
	var arrayJD = [];
	for (var j = 0; j < arrayJ.list.length; j++) {

		coords = "";
		for (var i = 0; i < arrayJ.list[j].sections[0].links.length; i++) {
			coords += (arrayJ.list[j].sections[0].links[i].points + ",");
		}
		var time = arrayJ.list[j].expectedTime;
		var realTime;
		if (parseInt(time / 3600) > 0) {
			realTime = "운행시간: " + parseInt(time / 3600) + "시간 "
					+ parseInt((time % 3600) / 60) + "분 "
					+ parseInt(((time % 3600) % 60) % 60) + "초";
		} else {
			realTime = "운행시간: " + parseInt((time % 3600) / 60) + "분 "
					+ parseInt(((time % 3600) % 60) % 60) + "초";
		}
		var distance = String(arrayJ.list[j].totalLength);
		var distance = distance.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
		var realDistance = "구간거리: " + distance + " m";
		var taxiCost = "택시비 : " + arrayJ.list[j].expectedTaxiCost + "원";
		var whatRoute = "";

		if (arrayJ.list[j].source == "daum")
			whatRoute = "daumLayer";
		else if (arrayJ.list[j].source == "skp")
			whatRoute = "sktLayer";
		else if (arrayJ.list[j].source == "mn")
			whatRoute = "mappyLayer";
		else if (arrayJ.list[j].source == "kt")
			whatRoute = "ollehLayer";

		var jsondata = {
			"whatRoute" : whatRoute,
			"coords" : coords,
			"time" : time,
			"realTime" : realTime,
			"distance" : distance,
			"realDistance" : realDistance,
			"taxiCost" : taxiCost
		}
		//var array1 = (jsondata);
		//arrayJD = JSON.parse(jsondata);
		arrayJD.push(jsondata);
		//array1 += (jsondata);

	}
	drawRoute(arrayJD);

}
function drawRoute(arrayJD) {//다슼맵올
	for (var i = 0; i < arrayJD.length; i++) {

		var repCoords = arrayJD[i].coords.replace(/ /gi, ",");
		repCoords = repCoords.replace(",,", ",");
		coord = repCoords.split(",");

		array = [];
		for (var ji = 0; ji < coord.length - 1; ji += 2) {
			//map.removeLayer(lineLayer);
			coordX = parseFloat(coord[ji], 10);
			coordY = parseFloat(coord[ji + 1], 10);
			array.push(get5to3(coordX, coordY));
		}
		lineFeature = new ol.Feature({
			geometry : new ol.geom.LineString(array)
		});

		lineSource = new ol.source.Vector();
		lineSource.addFeature(lineFeature);

		if (arrayJD[i].whatRoute == "daumLayer") { /////////daum

			$("#result")
					.append(
							'<div class = "resultChk" style="float:left;height:1px;"><input type="checkbox" name="check" id="daumPoint"  value='
									+ arrayJD[i].whatRoute
									+ ' checked="checked" /></div><div class = "resultDiv" value='
									+ arrayJD[i].whatRoute
									+ ' style="border-right:3px solid #0054FF;">다음<div>'
									+ arrayJD[i].realTime
									+ '</div><div>'
									+ arrayJD[i].realDistance
									+ '</div><div>'
									+ arrayJD[i].taxiCost + '</div></div>');

			daumLayer = new ol.layer.Vector({
				source : lineSource,
				style : new ol.style.Style({
					stroke : new ol.style.Stroke({
						color : "rgba(0,84,255,1)",
						width : 5
					})
				})
			});
			daumOutLineLayer = new ol.layer.Vector({
				source : lineSource,
				style : new ol.style.Style({
					stroke : new ol.style.Stroke({
						color : "rgba(1,1,1,1)",
						width : 8
					})
				})
			});
			map.addLayer(daumLayer);
			map.addLayer(daumOutLineLayer);
			daumOutLineLayer.setVisible(false);

		} else if (arrayJD[i].whatRoute == "sktLayer") { ///////////skt

			$("#result")
					.append(
							'<div class = "resultChk" style="float:left;height:1px;"><input type="checkbox" name="check" id="sktPoint"  value='
									+ arrayJD[i].whatRoute
									+ ' checked="checked" /></div><div class = "resultDiv" value='
									+ arrayJD[i].whatRoute
									+ ' style="border-right:3px solid #1DDB16;">Tmap<div>'
									+ arrayJD[i].realTime
									+ '</div><div>'
									+ arrayJD[i].realDistance
									+ '</div><div>'
									+ arrayJD[i].taxiCost + '</div></div>');

			sktLayer = new ol.layer.Vector({
				source : lineSource,
				style : new ol.style.Style({
					stroke : new ol.style.Stroke({
						color : "rgba(0,255,0,1)",
						width : 5
					})
				})
			});
			sktOutLineLayer = new ol.layer.Vector({
				source : lineSource,
				style : new ol.style.Style({
					stroke : new ol.style.Stroke({
						color : "rgba(1,1,1,1)",
						width : 8
					})
				})
			});
			map.addLayer(sktLayer);
			map.addLayer(sktOutLineLayer);
			sktOutLineLayer.setVisible(false);
		} else if (arrayJD[i].whatRoute == "mappyLayer") { /////////mappy

			$("#result")
					.append(
							'<div class = "resultChk" style="float:left;height:1px;"><input type="checkbox" name="check" id="mappyPoint"  value='
									+ arrayJD[i].whatRoute
									+ ' checked="checked" /></div><div class = "resultDiv" value='
									+ arrayJD[i].whatRoute
									+ ' style="border-right:3px solid #FFBB00;">Mappy<div>'
									+ arrayJD[i].realTime
									+ '</div><div>'
									+ arrayJD[i].realDistance + '</div></div>');

			mappyLayer = new ol.layer.Vector({
				source : lineSource,
				style : new ol.style.Style({
					stroke : new ol.style.Stroke({
						color : "rgba(255,187,0,1)",
						width : 5
					})
				})
			});

			mappyOutLineLayer = new ol.layer.Vector({
				source : lineSource,
				style : new ol.style.Style({
					stroke : new ol.style.Stroke({
						color : "rgba(1,1,1,1)",
						width : 8
					})
				})
			});
			map.addLayer(mappyLayer);
			map.addLayer(mappyOutLineLayer);
			mappyOutLineLayer.setVisible(false);
		} else if (arrayJD[i].whatRoute == "ollehLayer") { /////////////olleh

			$("#result")
					.append(
							'<div class = "resultChk" style="float:left;height:1px;"><input type="checkbox" name="check" id="ollehPoint"  value='
									+ arrayJD[i].whatRoute
									+ ' checked="checked" /></div><div class = "resultDiv" value='
									+ arrayJD[i].whatRoute
									+ ' style="border-right:3px solid #FF00DD;">올레<div>'
									+ arrayJD[i].realTime
									+ '</div><div>'
									+ arrayJD[i].realDistance + '</div></div>');

			ollehLayer = new ol.layer.Vector({
				source : lineSource,
				style : new ol.style.Style({
					stroke : new ol.style.Stroke({
						color : "rgba(255,0,255,1)",
						width : 5
					})
				})
			});
			ollehOutLineLayer = new ol.layer.Vector({
				source : lineSource,
				style : new ol.style.Style({
					stroke : new ol.style.Stroke({
						color : "rgba(1,1,1,1)",
						width : 8
					})
				})
			});
			map.addLayer(ollehLayer);
			map.addLayer(ollehOutLineLayer);
			ollehOutLineLayer.setVisible(false);
		}

	}

}
function guideGcen(guidesSearch) {
	arrayG = [];
	var gguides = guidesSearch.replace(/\/{2}/gi, "/");
	var gguide = gguides.split(",");
	$("#gcenGuide")
			.append(
					'<div name = "guidesTop" class = "guidesTop" style="background:#FF0000; height:10px;"></div>');
	for (var i = 0; i < gguide.length - 1; i++) {
		var ggguide = gguide[i].split("/");
		var gcX = parseFloat(ggguide[1], 10);
		var gcY = parseFloat(ggguide[2], 10);
		var gCoordC = get3857(gcX, gcY);
		var point = new ol.Feature({
			geometry : new ol.geom.Point(gCoordC)
		});
		point.setId(i + 1);
		arrayG.push(point);
		$("#gcenGuide").append(
				'<div name = "guides" class = "guides">' + (i + 1) + ', '
						+ ggguide[4] + ' ' + ggguide[0] + ' ' + ggguide[3]
						+ 'm 이동<input type="hidden" name="xyHidden" value = "'
						+ ggguide[1] + ', ' + ggguide[2] + '" /></div>');
	}
	drawGcenPoint(arrayG);
}
function guideRoute(json) {
	var arrayJ = (json);
	arrayD = [];
	arrayS = [];
	arrayM = [];
	arrayO = [];

	for (var j = 0; j < arrayJ.list.length; j++) {
		var guidesTopColor;

		if (arrayJ.list[j].source == "daum") {
			whatGuide = "daumGuide";
			guidesTopColor = "#0054FF";
		} else if (arrayJ.list[j].source == "skp") {
			whatGuide = "sktGuide";
			guidesTopColor = "#1DDB16"
		} else if (arrayJ.list[j].source == "mn") {
			whatGuide = "mappyGuide";
			guidesTopColor = "#FFBB00"
		} else if (arrayJ.list[j].source == "kt") {
			whatGuide = "ollehGuide";
			guidesTopColor = "#FF00DD"
		}
		$("#" + whatGuide).append(
				'<div name = "guidesTop" class = "guidesTop" style="background:'
						+ guidesTopColor + '; height:10px;"></div>');
		for (var l = 0; l < arrayJ.list[j].nodes.length; l++) {

			var info = arrayJ.list[j].nodes[l].info;
			var name = arrayJ.list[j].nodes[l].name;
			var guideX = arrayJ.list[j].nodes[l].x;
			var guideY = arrayJ.list[j].nodes[l].y;
			var guideCoord = guideX, guideY;
			var indexNum = arrayJ.list[j].nodes[l].seq;
			var gcX = parseFloat(guideX, 10);
			var gcY = parseFloat(guideY, 10);
			var gCoordC = get5to3(gcX, gcY);
			var point = new ol.Feature({
				geometry : new ol.geom.Point(gCoordC)
			});
			point.setId(indexNum);
			if (info != 0) {
				$("#" + whatGuide)
						.append(
								'<div name = "guides" class = "guides">'
										+ indexNum
										+ ','
										+ info
										+ '<input type="hidden" name="xyHidden" value = "'
										+ guideX + ', ' + guideY + '" /></div>');
				if (arrayJ.list[j].source == "daum") {
					arrayD.push(point);
				} else if (arrayJ.list[j].source == "skp") {
					arrayS.push(point);
				} else if (arrayJ.list[j].source == "mn") {
					arrayM.push(point);
				} else if (arrayJ.list[j].source == "kt") {
					arrayO.push(point);
				}
			}
			if (name == "도착지점") {
				$("#" + whatGuide)
						.append(
								'<div name = "guides" class = "guides">'
										+ indexNum
										+ ', '
										+ name
										+ '<input type="hidden" name="xyHidden" value = "'
										+ guideX + ', ' + guideY + '" /></div>');
				//drawPoint(guideX,guideY,whatGuide,indexNum);
				if (arrayJ.list[j].source == "daum") {
					arrayD.push(point);
				} else if (arrayJ.list[j].source == "skp") {
					arrayS.push(point);
				} else if (arrayJ.list[j].source == "mn") {
					arrayM.push(point);
				} else if (arrayJ.list[j].source == "kt") {
					arrayO.push(point);
				}
			}
		}
		drawPoint(arrayD, arrayS, arrayM, arrayO, whatGuide);
	}
}

///////////////////////////////////////해당 가이드 정보의 좌표!///////////////////
$("#gcenGuide").delegate(".guides", "click", function() {
	if (gcenLayer.getVisible() == true) {
		var gca = $(this)[0].lastChild.value.split(",");
		var gcX = parseFloat(gca[0], 10);
		var gcY = parseFloat(gca[1], 10);
		var gCoordC = get3857(gcX, gcY);
		map.getView().setCenter(gCoordC);
		map.getView().setZoom(16);
		gc();
	} else {
		return false;
	}
});
$("#daumGuide").delegate(".guides", "click", function() {
	if (daumLayer.getVisible() == true) {
		var gca = $(this)[0].lastChild.value.split(",");
		var gcX = parseFloat(gca[0], 10);
		var gcY = parseFloat(gca[1], 10);
		var gCoordC = get5to3(gcX, gcY);
		map.getView().setCenter(gCoordC);
		map.getView().setZoom(16);
		dc();
	} else {
		return false;
	}
});
$("#sktGuide").delegate(".guides", "click", function() {
	if (sktLayer.getVisible() == true) {
		var gca = $(this)[0].lastChild.value.split(",");
		var gcX = parseFloat(gca[0], 10);
		var gcY = parseFloat(gca[1], 10);
		var gCoordC = get5to3(gcX, gcY);
		map.getView().setCenter(gCoordC);
		map.getView().setZoom(16);
		sc();
	} else {
		return false;
	}
});
$("#mappyGuide").delegate(".guides", "click", function() {
	if (mappyLayer.getVisible() == true) {
		var gca = $(this)[0].lastChild.value.split(",");
		var gcX = parseFloat(gca[0], 10);
		var gcY = parseFloat(gca[1], 10);
		var gCoordC = get5to3(gcX, gcY);
		map.getView().setCenter(gCoordC);
		map.getView().setZoom(16);
		mc();
	} else {
		return false;
	}
});
$("#ollehGuide").delegate(".guides", "click", function() {
	if (ollehLayer.getVisible() == true) {
		var gca = $(this)[0].lastChild.value.split(",");
		var gcX = parseFloat(gca[0], 10);
		var gcY = parseFloat(gca[1], 10);
		var gCoordC = get5to3(gcX, gcY);
		map.getView().setCenter(gCoordC);
		map.getView().setZoom(16);
		oc();
	} else {
		return false;
	}

});

function gc() {
	gcenPoint.setVisible(true);
	daumPoint.setVisible(false);
	if (sktPoint != null) // 서울-부산처럼 해당 레이어가 아예 없을경우
		sktPoint.setVisible(false);
	if (mappyPoint != null)
		mappyPoint.setVisible(false);
	if (ollehPoint != null)
		ollehPoint.setVisible(false);
	gcenOutLineLayer.setVisible(true);
	daumOutLineLayer.setVisible(false);
	if (sktOutLineLayer != null)
		sktOutLineLayer.setVisible(false);
	if (mappyOutLineLayer != null)
		mappyOutLineLayer.setVisible(false);
	if (ollehOutLineLayer != null)
		ollehOutLineLayer.setVisible(false);
	raiseLayerTh(gcenOutLineLayer);
	raiseLayerSe(gcenLayer);
	raiseLayer(gcenPoint);
}
function dc() {
	gcenPoint.setVisible(false);
	daumPoint.setVisible(true);
	if (sktPoint != null)
		sktPoint.setVisible(false);
	if (mappyPoint != null)
		mappyPoint.setVisible(false);
	if (ollehPoint != null)
		ollehPoint.setVisible(false);
	gcenOutLineLayer.setVisible(false);
	daumOutLineLayer.setVisible(true);
	if (sktOutLineLayer != null)
		sktOutLineLayer.setVisible(false);
	if (mappyOutLineLayer != null)
		mappyOutLineLayer.setVisible(false);
	if (ollehOutLineLayer != null)
		ollehOutLineLayer.setVisible(false);
	raiseLayerTh(daumOutLineLayer);
	raiseLayerSe(daumLayer);
	raiseLayer(daumPoint);
}
function sc() {
	gcenPoint.setVisible(false);
	daumPoint.setVisible(false);
	if (sktPoint != null)
		sktPoint.setVisible(true);
	if (mappyPoint != null)
		mappyPoint.setVisible(false);
	if (ollehPoint != null)
		ollehPoint.setVisible(false);
	gcenOutLineLayer.setVisible(false);
	daumOutLineLayer.setVisible(false);
	if (sktOutLineLayer != null)
		sktOutLineLayer.setVisible(true);
	if (mappyOutLineLayer != null)
		mappyOutLineLayer.setVisible(false);
	if (ollehOutLineLayer != null)
		ollehOutLineLayer.setVisible(false);
	raiseLayerTh(sktOutLineLayer);
	raiseLayerSe(sktLayer);
	raiseLayer(sktPoint);
}
function mc() {
	gcenPoint.setVisible(false);
	daumPoint.setVisible(false);
	if (sktPoint != null)
		sktPoint.setVisible(false);
	if (mappyPoint != null)
		mappyPoint.setVisible(true);
	if (ollehPoint != null)
		ollehPoint.setVisible(false);
	gcenOutLineLayer.setVisible(false);
	daumOutLineLayer.setVisible(false);
	if (sktOutLineLayer != null)
		sktOutLineLayer.setVisible(false);
	if (mappyOutLineLayer != null)
		mappyOutLineLayer.setVisible(true);
	if (ollehOutLineLayer != null)
		ollehOutLineLayer.setVisible(false);
	raiseLayerTh(mappyOutLineLayer);
	raiseLayerSe(mappyLayer);
	raiseLayer(mappyPoint);
}
function oc() {
	gcenPoint.setVisible(false);
	daumPoint.setVisible(false);
	if (sktPoint != null)
		sktPoint.setVisible(false);
	if (mappyPoint != null)
		mappyPoint.setVisible(false);
	if (ollehPoint != null)
		ollehPoint.setVisible(true);
	gcenOutLineLayer.setVisible(false);
	daumOutLineLayer.setVisible(false);
	if (sktOutLineLayer != null)
		sktOutLineLayer.setVisible(false);
	if (mappyOutLineLayer != null)
		mappyOutLineLayer.setVisible(false);
	if (ollehOutLineLayer != null)
		ollehOutLineLayer.setVisible(true);
	raiseLayerTh(ollehOutLineLayer);
	raiseLayerSe(ollehLayer);
	raiseLayer(ollehPoint);
}
function drawGcenPoint(arrayG) {
	//map.removeLayer(gcenPoint);
	var vectorSource = new ol.source.Vector();
	gcenPoint = new ol.layer.Vector({
		id : "gcenPointLayer", // 명시적으로 주는게 좋음				
		source : vectorSource,
		style : function(feature, resolution) {
			var style = new ol.style.Style({
				text : new ol.style.Text({
					font : '14px helvetica,sans-serif',
					text : feature.getId() + "", // id를 숫자형식으로 주면 에러...문자열로 해야됨
					fill : new ol.style.Fill({
						color : 'rgba(0, 84, 255, 1)'
					}),
					stroke : new ol.style.Stroke({
						color : 'rgba(0, 0, 0, 1)',
						width : 0.5
					})
				}),
				fill : new ol.style.Fill({
					color : 'rgba(255, 255, 255, 1)'
				}),
				stroke : new ol.style.Stroke({
					color : 'rgba(213, 213, 213, 1)',
					width : 1
				}),
				image : new ol.style.Circle({
					radius : 9,
					fill : new ol.style.Fill({
						color : 'rgba(213, 213, 213, 1)'
					}),
					stroke : new ol.style.Stroke({
						color : 'rgba(0, 0, 0, 1)',
						width : 1
					})
				}),
				zIndex : feature.getId()
			});

			return [ style ];
		}
	});
	map.addLayer(gcenPoint);
	vectorSource.addFeatures(arrayG);
	gcenPoint.setVisible(false);

}

function drawPoint(arrayD, arrayS, arrayM, arrayO, whatGuide) {

	//var gca = $(this)[0].lastChild.value.split(",");
	//indexNum = String(indexNum);

	if (whatGuide == "daumGuide") {
		var vectorSource = new ol.source.Vector();
		daumPoint = new ol.layer.Vector({
			id : "daumPointLayer", // 명시적으로 주는게 좋음				
			source : vectorSource,
			style : function(feature, resolution) {
				var style = new ol.style.Style({
					text : new ol.style.Text({
						font : '14px helvetica,sans-serif',
						text : feature.getId() + "", // id를 숫자형식으로 주면 에러...문자열로 해야됨
						fill : new ol.style.Fill({
							color : '#0054FF'
						}),
						stroke : new ol.style.Stroke({
							color : '#000',
							width : 0.5
						})
					}),
					fill : new ol.style.Fill({
						color : 'rgba(255, 255, 255, 1)'
					}),
					stroke : new ol.style.Stroke({
						color : '#D5D5D5',
						width : 1
					}),
					image : new ol.style.Circle({
						radius : 9,
						fill : new ol.style.Fill({
							color : '#D5D5D5'
						}),
						stroke : new ol.style.Stroke({
							color : '#000',
							width : 1
						})
					}),
					zIndex : feature.getId()
				});

				return [ style ];
			}
		});
		map.addLayer(daumPoint);
		vectorSource.addFeatures(arrayD);
		daumPoint.setVisible(false);
	} else if (whatGuide == "sktGuide") {
		var vectorSource = new ol.source.Vector();
		sktPoint = new ol.layer.Vector({
			id : "sktPointLayer", // 명시적으로 주는게 좋음				
			source : vectorSource,
			style : function(feature, resolution) {
				var style = new ol.style.Style({
					text : new ol.style.Text({
						font : '14px helvetica,sans-serif',
						text : feature.getId() + "", // id를 숫자형식으로 주면 에러...문자열로 해야됨
						fill : new ol.style.Fill({
							color : '#0054FF'
						}),
						stroke : new ol.style.Stroke({
							color : '#000',
							width : 0.5
						})
					}),
					fill : new ol.style.Fill({
						color : 'rgba(255, 255, 255, 1)'
					}),
					stroke : new ol.style.Stroke({
						color : '#D5D5D5',
						width : 1
					}),
					image : new ol.style.Circle({
						radius : 9,
						fill : new ol.style.Fill({
							color : '#D5D5D5'
						}),
						stroke : new ol.style.Stroke({
							color : '#000',
							width : 1
						})
					}),
					zIndex : feature.getId()
				});

				return [ style ];
			}
		});
		map.addLayer(sktPoint);
		vectorSource.addFeatures(arrayS);
		sktPoint.setVisible(false);
	} else if (whatGuide == "mappyGuide") {
		var vectorSource = new ol.source.Vector();
		mappyPoint = new ol.layer.Vector({
			id : "mappyPointLayer", // 명시적으로 주는게 좋음				
			source : vectorSource,
			style : function(feature, resolution) {
				var style = new ol.style.Style({
					text : new ol.style.Text({
						font : '14px helvetica,sans-serif',
						text : feature.getId() + "", // id를 숫자형식으로 주면 에러...문자열로 해야됨
						fill : new ol.style.Fill({
							color : '#0054FF'
						}),
						stroke : new ol.style.Stroke({
							color : '#000',
							width : 0.5
						})
					}),
					fill : new ol.style.Fill({
						color : 'rgba(255, 255, 255, 1)'
					}),
					stroke : new ol.style.Stroke({
						color : '#D5D5D5',
						width : 1
					}),
					image : new ol.style.Circle({
						radius : 9,
						fill : new ol.style.Fill({
							color : '#D5D5D5'
						}),
						stroke : new ol.style.Stroke({
							color : '#000',
							width : 1
						})
					}),
					zIndex : feature.getId()
				});

				return [ style ];
			}
		});
		map.addLayer(mappyPoint);
		vectorSource.addFeatures(arrayM);
		mappyPoint.setVisible(false);
	} else if (whatGuide == "ollehGuide") {
		var vectorSource = new ol.source.Vector();
		ollehPoint = new ol.layer.Vector({
			id : "ollehPointLayer", // 명시적으로 주는게 좋음				
			source : vectorSource,
			style : function(feature, resolution) {
				var style = new ol.style.Style({
					text : new ol.style.Text({
						font : '14px helvetica,sans-serif',
						text : feature.getId() + "", // id를 숫자형식으로 주면 에러...문자열로 해야됨
						fill : new ol.style.Fill({
							color : '#0054FF'
						}),
						stroke : new ol.style.Stroke({
							color : '#000',
							width : 0.5
						})
					}),
					fill : new ol.style.Fill({
						color : 'rgba(255, 255, 255, 1)'
					}),
					stroke : new ol.style.Stroke({
						color : '#D5D5D5',
						width : 1
					}),
					image : new ol.style.Circle({
						radius : 9,
						fill : new ol.style.Fill({
							color : '#D5D5D5'
						}),
						stroke : new ol.style.Stroke({
							color : '#000',
							width : 1
						})
					}),
					zIndex : feature.getId()
				});

				return [ style ];
			}
		});
		map.addLayer(ollehPoint);
		vectorSource.addFeatures(arrayO);
		ollehPoint.setVisible(false);
	}
}
function indexOf(layers, layer) {
	var length = layers.getLength();
	for (var i = 0; i < length; i++) {
		if (layer === layers.item(i)) {
			return i;
		}
	}
	return -1;
}
function raiseLayer(layer) {
	var layers = map.getLayers();
	var index = indexOf(layers, layer);
	var length = layers.getLength() - 1;
	if (index < layers.getLength() - 1) {
		var end = layers.item(length);
		layers.setAt(length, layer);
		layers.setAt(index, end);
	}
}
function raiseLayerSe(layer) {
	var layers = map.getLayers();
	var index = indexOf(layers, layer);
	var length = layers.getLength() - 1;
	if (index < layers.getLength() - 1) {
		var seEnd = layers.item(length - 1);
		layers.setAt(length - 1, layer);
		layers.setAt(index, seEnd);
	}
}
function raiseLayerTh(layer) {
	var layers = map.getLayers();
	var index = indexOf(layers, layer);
	var length = layers.getLength() - 1;
	if (index < layers.getLength() - 1) {
		var thEnd = layers.item(length - 2);
		layers.setAt(length - 2, layer);
		layers.setAt(index, thEnd);
	}
}
function raiseMaps(exLayer, layer) {
	map.addLayer(layer);
	var layers = map.getLayers();
	var index = indexOf(layers, layer);
	var indexEx = indexOf(layers, exLayer);
	//var length = layers.getLength() -1;
	//if(index < layers.getLength() -1){
	selectedMap = layer;
	var length = layers.getLength() - 1;
	layers.setAt(indexEx, layer);
	layers.setAt(index, exLayer);
	map.removeLayer(exLayer);

	//}
}
/////////////////////////////////////////////////////////////////////////
$("#result").delegate("input[name='check']", "change", function() {
	//var ischecked = $(this).attr('checked');
	//event.stopPropagation();
	var adtId = $(this)[0].id;//~point
	var adt = $(this).val();//~layer
	var outLine;
	if (adt == "gcenLayer") {
		outLine = "gcenOutLineLayer";
	} else if (adt == "daumLayer") {
		outLine = "daumOutLineLayer";
	} else if (adt == "sktLayer") {
		outLine = "sktOutLineLayer";
	} else if (adt == "mappyLayer") {
		outLine = "mappyOutLineLayer";
	} else if (adt == "ollehLayer") {
		outLine = "ollehOutLineLayer";
	}
	if ($(this).is(":checked") == true) {
		eval(adt).setVisible(true);
		//eval(adtId).setVisible(true);
	} else {
		eval(adt).setVisible(false);
		eval(adtId).setVisible(false);
		eval(outLine).setVisible(false);
	}

});
$("#result").delegate(".resultDiv", "click", function(event) {//side 에 각 경로 정보 클릭시
	//var ischecked = $(this).attr('checked');
	//event.stopPropagation();
	var adt = $(this);
	var lname = adt[0].attributes[1].nodeValue;
	if (lname == "gcenLayer") {
		if (eval(lname).getVisible() == true)
			gc();
	} else if (lname == "daumLayer") {
		if (eval(lname).getVisible() == true)
			dc();
	} else if (lname == "sktLayer") {
		if (eval(lname).getVisible() == true)
			sc();
	} else if (lname == "mappyLayer") {
		if (eval(lname).getVisible() == true)
			mc();
	} else if (lname == "ollehLayer") {
		if (eval(lname).getVisible() == true)
			oc();
	}

	//event.stopPropagation();
	//event.preventDefault();

});
////////////////////////////////////////////////////////////////
function searchAjax(startText, arriveText, searchType) {
	$
			.ajax({
				url : "search.jsp",
				type : "post",
				data : {
					//roadside : 'ON',
					startText : startText,
					arriveText : arriveText,
					searchType : searchType
				},
				dataType : "json",
				beforeSend : function() {
					//이미지 보여주기 처리
					loading = $(
							'<div id="loading" class="loading"></div><img id="loading_img" alt="loading" src="../../img/compareSearch/loader.gif" />')
							.appendTo(document.body).hide();
					loading.show();
				},
				success : function(data) {

					$.each(data,function() {
										map.removeLayer(gcenLayer);
										map.removeLayer(daumLayer);
										map.removeLayer(sktLayer);
										map.removeLayer(mappyLayer);
										map.removeLayer(ollehLayer);
										map.removeLayer(gcenPoint);
										map.removeLayer(daumPoint);
										map.removeLayer(sktPoint);
										map.removeLayer(mappyPoint);
										map.removeLayer(ollehPoint);
										map.removeLayer(gcenOutLineLayer);
										map.removeLayer(daumOutLineLayer);
										map.removeLayer(sktOutLineLayer);
										map.removeLayer(mappyOutLineLayer);
										map.removeLayer(ollehOutLineLayer);

										var checkType = this["checkType"];
										if (checkType == "fail") {
											$(".guides").remove();
											$(".guidesTop").remove();
											$(".resultDiv").remove();
											$(".resultChk").remove();
											$(".allCheck").remove();
											aa(data);
											$("#result").append(
													'<div class="allCheck"><input type="checkbox" name="allCheck" checked="checked"/>전체선택</div>'
											);
										} else {
											allRoutes = this["realpath"];
											route(allRoutes);
											$(".guides").remove();
											$(".guidesTop").remove();
											$(".resultDiv").remove();
											$(".resultChk").remove();
											$(".allCheck").remove();
											$("#result").append(
															'<div class="allCheck"><input type="checkbox" name="allCheck" checked="checked"/>전체선택</div><div class = "resultChk" style="float:left;height:1px;"><input type="checkbox" name="check" id="gcenPoint"  value="gcenLayer" checked="checked" /></div><div class = "resultDiv" value="gcenLayer" style="border-right:3px solid #FF0000;">지센<div>'
																	+ this["allTime"]
																	+ '</div><div>'
																	+ this["distance"]
																	+ '</div></div>');
											aa(data);
											guidesSearch = this["guides"];
											guideGcen(guidesSearch);
										}

									});
				},
				error : function(jqXHR, textStatus, errorThrown) {
					var errorMsg = 'status(code) : ' + jqXHR.status + '\n';
					errorMsg += 'statusText : ' + jqXHR.statusText + '\n';
					errorMsg += 'responseText : ' + jqXHR.responseText + '\n';
					errorMsg += 'textStatus : ' + textStatus + '\n';
					errorMsg += 'errorThrown : ' + errorThrown;
					alert(errorMsg);
				}
			});
}
function json2CSV(objArray) {
	var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;

	var str = '';
	var line = '';
	// if ($("#labels").is(':checked')) {
	var head = array[0];

	for ( var index in array[0]) {
		line += index + ',';
	}
	line = line.slice(0, -1);
	str += line + '\r\n';
	// }

	for (var i = 0; i < array.length; i++) {
		var line = '';

		for ( var index in array[i]) {
			line += array[i][index] + ',';
		}
		line = line.slice(0, -1);
		str += line + '\r\n';
	}
	return str;
}
function down() {
	//$("#download").click(function() {
	var json = (arrJson2csv);
	var csv = json2CSV(json);
	window.open("data:text/csv;charset=utf-8," + escape(csv))
	//});
}

$("#download")
		.click(
				function() {
					if (typeof excelData == "undefined") {
						alert("먼저 탐색을 실행해 주세요.");
						return;
					}
					console.log("다운로드 클릭");
					console.log(excelData);
					$
							.ajax({
								url : "exportResult.jsp",
								type : "post",
								data : {
									"excelData" : JSON.stringify(excelData)
								},
								beforeSend : function() {
									//이미지 보여주기 처리
									loading = $(
											'<div id="loading" class="loading"></div><img id="loading_img" alt="loading" src="../../img/compareSearch/loader.gif" />')
											.appendTo(document.body).hide();
									loading.show();
								},
								success : function(data) {
									$("#downloadForm").submit();
									alert("다운로드 성공");
									loading.hide();
								},
								error : function(jqXHR, textStatus, errorThrown) {
									var errorMsg = 'status(code) : '
											+ jqXHR.status + '\n';
									errorMsg += 'statusText : '
											+ jqXHR.statusText + '\n';
									errorMsg += 'responseText : '
											+ jqXHR.responseText + '\n';
									errorMsg += 'textStatus : ' + textStatus
											+ '\n';
									errorMsg += 'errorThrown : ' + errorThrown;
									alert(errorMsg);
									loading.hide();
								}
							});
				});

function aa(data) {
	//var startText = document.getElementById("startText").value;
	var startCoordArr = data[0].startText.split(",");
	var startCoordArrX = parseFloat(startCoordArr[0], 10);
	var startCoordArrY = parseFloat(startCoordArr[1], 10);

	var proStart = new Proj4js.Point(startCoordArrX, startCoordArrY)
	Proj4js.transform(e4326, e5181, proStart);
	var sX = proStart.x * 2.5;
	var sY = proStart.y * 2.5;
	//var arriveText = document.getElementById("arriveText").value;
	var arriveCoordArr = data[0].arriveText.split(",");
	var arriveCoordArrX = parseFloat(arriveCoordArr[0], 10);
	var arriveCoordArrY = parseFloat(arriveCoordArr[1], 10);

	var proArrive = new Proj4js.Point(arriveCoordArrX, arriveCoordArrY)
	Proj4js.transform(e4326, e5181, proArrive);
	var eX = proArrive.x * 2.5;
	var eY = proArrive.y * 2.5;

	//var searchType = $('input:radio[name="searchType"]:checked').val();

	var carOption = "car";
	if (searchType == 1) {//최단거리
		searchType = "SHORTEST_DIST";
	} else if (searchType == 2) {//최적
		searchType = "SHORTEST_TIME";
	} else if (searchType == 3) { //무료
		searchType = "SHORTEST_REALTIME";
		carOption = "FREEWAY";
	} else if (searchType == 4) { //자동차 전용도로 제외
		searchType = "SHORTEST_REALTIME";
		carOption = "BIKE";
	} else if (searchType == 5) {
		searchType = "SHORTEST_REALTIME";
	}
	$.ajax({
		url : "http://map.daum.net/route/carset.json",
		type : "get",
		data : {
			roadside : 'ON',
			carMode : searchType,
			carOption : carOption,
			sX : sX,
			sY : sY,
			eX : eX,
			eY : eY
		},
		dataType : "jsonp",
		callback : "callback",
		success : function(json) {
			daumsRoute(json);
			guideRoute(json);
			loading.hide();

		},
		error : function(jqXHR, textStatus, errorThrown) {
			var errorMsg = 'status(code) : ' + jqXHR.status + '\n';
			errorMsg += 'statusText : ' + jqXHR.statusText + '\n';
			errorMsg += 'responseText : ' + jqXHR.responseText + '\n';
			errorMsg += 'textStatus : ' + textStatus + '\n';
			errorMsg += 'errorThrown : ' + errorThrown;
			console.log(errorMsg);
		}
	});
}
//$(function() {//지센 데이터 주고 받아서 처리하는 부분
$("#submit").click(function() {
	search();
});
function search() {
	startText = document.getElementById("startText").value;
	//var viaText = document.getElementById("viaText").value;
	arriveText = document.getElementById("arriveText").value;
	var s = startText.split(",");
	var a = arriveText.split(",");

	if (checkKatechMBR(s[0], s[1]) == true) {
		s = getKtoW(s[0], s[1]);
		startText = (s[0] + ", " + s[1]);
	}
	if (checkKatechMBR(a[0], a[1]) == true) {
		a = getKtoW(a[0], a[1]);
		arriveText = (a[0] + ", " + a[1]);
	}
	//if(checkKatechMBR(s[0],s[1]))
	//var searchType = document.getElementByName("searchType").value;
	//searchType = $('input:radio[name="searchType"]:checked').val();
	searchType = $('select[name="searchType"] > option:selected').val();
	if ($("#traffic").is(":checked") == true && searchType == 2) {
		searchType = 5;
	}
	//params = 'startText=' + startText+ '&arriveText=' + arriveText+ '&searchType=' + searchType;
	//var params = 'startText='+startText+'&viaText='+viaText+'&arriveText='+arriveText+'&searchType='+searchType;
	if (startText != "") {
		if (arriveText != "") {
			searchAjax(startText, arriveText, searchType);
		} else {
			alert("도착지를 입력하세요");
		}
	} else {
		alert("출발지를 입력하세요");
	}
}