<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
<link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/v5/modules/dialog.css,/styles/backstage/vst/gallery/v1/reset.css,/styles/backstage/vst/framework/seq.css">
</head>
<body>
<#import "/base/pagination.ftl" as pagination>
<input type="hidden" name="prodAdId" value="${adId}"/>
<div  class="seq-dialog">
	<div class="seq-dialog-main">
		<table id="showSeq">
			<tr>
				<td class="seq-dialog-nav">
				<ul id="areaId">
					<li data="0" class="current">
						<input type='checkbox'/>热门城市</li>
					<li data="1">
						<input type='checkbox'/>华东地区</li>
					<li data="2">
						<input type='checkbox'/>华南地区</li>
					<li data="3">
						<input type='checkbox'/>华北地区</li>
					<li data="4">
						<input type='checkbox'/>华中地区</li>
					<li data="5">
						<input type='checkbox'/>东北地区</li>
					<li data="6">
						<input type='checkbox'/>西南地区</li>
					<li data="7">
						<input type='checkbox'/>西北地区</li>
					<li data="8">
						<input type='checkbox'/>港澳台</li>
				</ul>
				</td>
				<td id="showContentHtml"></td>
			</tr>
		</table>
	</div>
	<div class="seq-dialog-footer clearfix">
		<span class="seq-dialog-checkAll"><input type='checkbox' name="allselectedarea" id="allselectedarea"/><i>全选&nbsp;</i></span>
		<a href="javascript:;" class="seq-dialog-clearAll" id="clearSeq">批量清除</a>
		<div class="seq-synchronize">
		<label>针对勾选批量处理<input type="text" name="asyncSeqTxt"/></label>
		</div>
		<span class="seq-btn seq-btn-syn" id="asyncSeqBut">同步</span>
		<span class="seq-btn seq-btn-confirm" id="commitBut">确定</span>
		<span class="seq-btn seq-btn-log" id="showLog">查看日志</span>
	</div>
</div>


<#include "/base/foot.ftl"/>
<script>
	var loadArea=new Array(); 
	for(var i=0;i<9;i++){
		loadArea[i]="false";
	}
 	var cityObject=new Object();
 	var ProvinceObject=new Object();
 	var areaObject=new Object();
	//获取adid
	var cityOrProvinceByareaIdList=new Array();
	var districtObject=new Object();
	districtObject.districtNameListStr="上海,北京,天津,广州,深圳,重庆,成都,南京,杭州,武汉,无锡";
	districtObject.districtType="CITY";
	cityOrProvinceByareaIdList[0]=districtObject;
	
	districtObject=new Object();
	districtObject.districtNameListStr="江苏,浙江,安徽,江西,山东,福建";
	districtObject.districtType="PROVINCE";
	cityOrProvinceByareaIdList[1]=districtObject;
	
	districtObject=new Object();
	districtObject.districtNameListStr="广东,广西,海南";
	districtObject.districtType="PROVINCE";
	cityOrProvinceByareaIdList[2]=districtObject;
	
	districtObject=new Object();
	districtObject.districtNameListStr="山西,河北,内蒙古";
	districtObject.districtType="PROVINCE";
	cityOrProvinceByareaIdList[3]=districtObject;
	
	districtObject=new Object();
	districtObject.districtNameListStr="河南,湖北,湖南";
	districtObject.districtType="PROVINCE";
	cityOrProvinceByareaIdList[4]=districtObject;
	
	districtObject=new Object();
	districtObject.districtNameListStr="黑龙江,吉林,辽宁";
	districtObject.districtType="PROVINCE";
	cityOrProvinceByareaIdList[5]=districtObject;
	
	districtObject=new Object();
	districtObject.districtNameListStr="四川,贵州,云南,西藏";
	districtObject.districtType="PROVINCE";
	cityOrProvinceByareaIdList[6]=districtObject;
	
	districtObject=new Object();
	districtObject.districtNameListStr="陕西,甘肃,青海,宁夏,新疆";
	districtObject.districtType="PROVINCE";
	cityOrProvinceByareaIdList[7]=districtObject;
	
	districtObject=new Object();
	districtObject.districtNameListStr="香港,澳门,台湾";
	districtObject.districtType="PROVINCE";
	cityOrProvinceByareaIdList[8]=districtObject;
	
	
	var areaList=new Array();
	
	var areaIdIndex=0;
	function citySeqHtml(data,areaId){
		var prodAdId=$("input[name=prodAdId]").val();
		var html="";
		if(data==null){
			return html;
		}
		var districtList=new Array();
		var districtObj=new Object();
		var k=0;
		for(var i=0;i<data.length;i++){
			var cityList=data[i].prodCityList;
			if(cityList.length<=0){
				return html;
			}
			for(var j=0;j<cityList.length;j++){
				districtObj=new Object();
				districtObj.seq="";
				districtObj.adId=prodAdId;
				districtObj.districtName="";
				districtObj.rankId="";
				districtObj.districtId=cityList[j].districtId;
				districtObj.districtName=cityList[j].districtName;
				if(cityList[j].bizProdAdRank!=null){
					districtObj.seq=cityList[j].bizProdAdRank.seq;
					if(cityList[j].bizProdAdRank.rankId !=null){
						districtObj.rankId=cityList[j].bizProdAdRank.rankId;
					}
				}
				districtList[k]=districtObj;
				k++;
			}
		}
		//设置区域的城市
		areaList[areaId]=districtList;
		var length=districtList.length-districtList.length%5;
		for(var i=0;i<length;i=i+5){
			html+="<td><input type=\"hidden\" name=\"rankId\" value=\""+districtList[i].rankId+"\"/><input type=\"hidden\" name=\"districtId\" value=\""+districtList[i].districtId+"\"/><input type=\"hidden\" name=\"bizPrdoAdId\" value=\""+districtList[i].adId+"\"/>"+districtList[i].districtName+"<input type=\"text\" name=\"seq\" value=\""+districtList[i].seq+"\"/></td>";
			html+="<td><input type=\"hidden\" name=\"rankId\" value=\""+districtList[i+1].rankId+"\"/><input type=\"hidden\" name=\"districtId\" value=\""+districtList[i+1].districtId+"\"/><input type=\"hidden\" name=\"bizPrdoAdId\" value=\""+districtList[i+1].adId+"\"/>"+districtList[i+1].districtName+"<input type=\"text\" name=\"seq\" value=\""+districtList[i+1].seq+"\"/></td>";
			html+="<td><input type=\"hidden\" name=\"rankId\" value=\""+districtList[i+2].rankId+"\"/><input type=\"hidden\" name=\"districtId\" value=\""+districtList[i+2].districtId+"\"/><input type=\"hidden\" name=\"bizPrdoAdId\" value=\""+districtList[i+2].adId+"\"/>"+districtList[i+2].districtName+"<input type=\"text\" name=\"seq\" value=\""+districtList[i+2].seq+"\"/></td>";
			html+="<td><input type=\"hidden\" name=\"rankId\" value=\""+districtList[i+3].rankId+"\"/><input type=\"hidden\" name=\"districtId\" value=\""+districtList[i+3].districtId+"\"/><input type=\"hidden\" name=\"bizPrdoAdId\" value=\""+districtList[i+3].adId+"\"/>"+districtList[i+3].districtName+"<input type=\"text\" name=\"seq\" value=\""+districtList[i+3].seq+"\"/></td>";
			html+="<td><input type=\"hidden\" name=\"rankId\" value=\""+districtList[i+4].rankId+"\"/><input type=\"hidden\" name=\"districtId\" value=\""+districtList[i+4].districtId+"\"/><input type=\"hidden\" name=\"bizPrdoAdId\" value=\""+districtList[i+4].adId+"\"/>"+districtList[i+4].districtName+"<input type=\"text\" name=\"seq\" value=\""+districtList[i+4].seq+"\"/></td>";
		}
		length=districtList.length%5;
		if(length>0){
			for(var i=length;i>0;i--){
				html+="<td><input type=\"hidden\" name=\"rankId\" value=\""+districtList[districtList.length-i].rankId+"\"/><input type=\"hidden\" name=\"districtId\" value=\""+districtList[districtList.length-i].districtId+"\"/><input type=\"hidden\" name=\"bizPrdoAdId\" value=\""+districtList[districtList.length-i].adId+"\"/>"+districtList[districtList.length-i].districtName+"<input type=\"text\" name=\"seq\" value=\""+districtList[districtList.length-i].seq+"\"/></td>";
			}
		}
		return html;
	}
	//初始加载页面data
	function queryAreaInfo(areaId){
		var adId=$("input[name=prodAdId]").val();
		var distrObject=cityOrProvinceByareaIdList[areaId];
		areaIdIndex=areaId;//确定tab页
		var datas={
			adId:adId,
			districtNames:distrObject.districtNameListStr
		};
		$.ajax({
			type:"POST",
			url:"/vst_admin/front/destAdvertising/findProductDistrictListByAdId.do",
			data:datas,
			dataType:'json',
			success:function (data){
				if(areaIdIndex>=8){
					loadArea[areaIdIndex]="true";
					areaObject[areaIdIndex]=data;
					var html=citySeqHtml(data,areaIdIndex);
					areaIdIndex=0;
					if(loadArea[0]=="true"){
						$("#showContentHtml").html(showHtml(areaList[0]));
					}
					return;
				}
				loadArea[areaIdIndex]="true";
				areaObject[areaIdIndex]=data;
				var html=citySeqHtml(data,areaIdIndex);
				$("#showContentHtml").html(html);
				areaIdIndex++;
				queryAreaInfo(areaIdIndex);
			},
			error:function (data){
				alert("数据加载失败");
			}
		});
	}
	
	var $seqdialog = $('.seq-dialog');
	$seqdialog.on('click','.seq-dialog-nav li', function() {
		var $self = $(this);
		$self.addClass('current').siblings().removeClass('current');
		$('.seq-conList').eq($self.index()).addClass('current').siblings().removeClass('current');
	});

	$(document).ready(function (){
		//初始请求城市数据，默认显示热门城市
		var distrObject=cityOrProvinceByareaIdList[0];
		var prodAdId=$("input[name=prodAdId]").val();
		$("#showLog").bind("click",function (){
			new xDialog("http://super.lvmama.com/lvmm_log/bizLog/showVersatileLogList?objectType=PROD_DEST_DESTADVER&objectId="+prodAdId+"&sysName=VST",{},{title:"修改日志",width:650});
		});
		var datas={
			adId:prodAdId,
			districtNames:distrObject.districtNameListStr,
			distictType:distrObject.districtType
		};
		$.ajax({
			type:"POST",
			url:"/vst_admin/front/destAdvertising/findProductDistrictListByAdId.do",
			data:datas,
			dataType:'json',
			success:function (data){
				var html=citySeqHtml(data,0);
				areaObject[0]=data;
				loadArea[0]="true";
				if(html!=""){
					$("#showContentHtml").html(html);
				}
			},
			error:function (data){
				alert("数据加载失败");
			}
		});
		$("#areaId li").each(function (){
			$(this).live("click",function (){
				storageSeqInfo(areaIdIndex);
				var areaId=$(this).attr("data");
				areaIdIndex=areaId;
				if(loadArea[areaId]=="true"){
					$("#showContentHtml").html(showHtml(areaList[areaId]));
					return;
				}
			});
		});
		queryAreaInfo(0);
		$("#allselectedarea").live("click",function (){
			if($("#allselectedarea").is(":checked")){
				$("#areaId input").attr("checked",true);
			}else{
				$("#areaId input").attr("checked",false);
			}
		});
		$("#asyncSeqBut").live("click",function (){
			//判断同步的seq值
			var asyncSeqTxt=$("input[name=asyncSeqTxt]").val();
			if(asyncSeqTxt==""){
				alert("请输入seq值");
				return;
			}
			if($("ul input[type=checkbox]:checked").length<=0){
				alert("请勾选大区");
				return;
			}
			//修改seq集合
			updateAllSeq(asyncSeqTxt);
		});
		$("#clearSeq").live("click",function (){
			//清除所有seq值
			updateAllSeq("");
		});
		$("#commitBut").live("click",function (){
			storageSeqInfo(areaIdIndex);
			var bizProdAdRanklist=new Array();
			var adId=$("input[name=prodAdId]").val();
			var k=0;
			var nullseq=true;
			for(i=0;i<loadArea.length;i++){
				if(loadArea[i]=="true"){
					var areaId=$(this).parent().attr("data");
					for(var j=0;j<areaList[i].length;j++){
						
						bizProdAdRanklist[k]=areaList[i][j];
						if(bizProdAdRanklist[k].seq!=""){
							nullseq=false;
						}
						k++;
					}
				}
			}
			if(nullseq){
				alert("所有seq值不允许为空");
				return;
			}
			//直接提交
			$.ajax({
					type:"POST",
					url:"/vst_admin/front/destAdvertising/addDestRankListByAdId.do",
					data:JSON.stringify(bizProdAdRanklist),
					contentType: "application/json",
					dataType:'json',
					success:function (data){
						if(data.code==0){
							alert("同步成功");
							parent.closeSeqSelectDialog();
						}else{
							alert(data.message);
						}
					},
					error:function (data){
						alert("数据加载失败");
					}
			});
	  });
  });
		//定义同步修改，或者删除seq的方法
		function updateAllSeq(seq){
			$("ul input[type=checkbox]:checked").each(function (){
				var areaId=$(this).parent().attr("data");
				var adId=$("input[name=prodAdId]").val();
				updateAreaList(areaId,seq,adId);
			});
			if($("ul input[type=checkbox]:checked").length>0){
				$("#showContentHtml").html(showHtml(areaList[areaIdIndex]));
			}
		}
		
		//修改areaList数据
		function updateAreaList(indexArea,seq,adId){
			for(var i=0;i<areaList[indexArea].length;i++){
				var cityPo=areaList[indexArea][i];
				cityPo.seq=seq;
			}
		}
		
		function storageSeqInfo(areaIdindex){
			var citylists=new Array();
			$("#showSeq input[name=districtId]").each(function (i){
				var rankId=$(this).prev().val();
				var adId=$(this).next().val();
				var seq=$(this).next().next().val();
				var districtName=$(this).parent().text();
				var districtId=$(this).val();
				//设置城市obj
				var cityPo=new Object();
				cityPo.seq=seq;
				cityPo.adId=adId;
				cityPo.districtName=districtName;
				cityPo.rankId=rankId;
				cityPo.districtId=districtId;
				citylists[i]=cityPo;
			});
			areaList[areaIdindex]=citylists;
		}
		
		function showHtml(districtList){
			var html=""; 
			var length=districtList.length-districtList.length%5;
				html+="<div class=\"seq-conList clearfix current \">";
			for(var i=0;i<length;i=i+5){
				html+="<label><input type=\"hidden\" name=\"rankId\" value=\""+districtList[i].rankId+"\"/><input type=\"hidden\" name=\"districtId\" value=\""+districtList[i].districtId+"\"/><input type=\"hidden\" name=\"bizPrdoAdId\" value=\""+districtList[i].adId+"\"/>"+districtList[i].districtName+"<input type=\"text\" name=\"seq\" value=\""+districtList[i].seq+"\"/></label>";
				html+="<label><input type=\"hidden\" name=\"rankId\" value=\""+districtList[i+1].rankId+"\"/><input type=\"hidden\" name=\"districtId\" value=\""+districtList[i+1].districtId+"\"/><input type=\"hidden\" name=\"bizPrdoAdId\" value=\""+districtList[i+1].adId+"\"/>"+districtList[i+1].districtName+"<input type=\"text\" name=\"seq\" value=\""+districtList[i+1].seq+"\"/></label>";
				html+="<label><input type=\"hidden\" name=\"rankId\" value=\""+districtList[i+2].rankId+"\"/><input type=\"hidden\" name=\"districtId\" value=\""+districtList[i+2].districtId+"\"/><input type=\"hidden\" name=\"bizPrdoAdId\" value=\""+districtList[i+2].adId+"\"/>"+districtList[i+2].districtName+"<input type=\"text\" name=\"seq\" value=\""+districtList[i+2].seq+"\"/></label>";
				html+="<label><input type=\"hidden\" name=\"rankId\" value=\""+districtList[i+3].rankId+"\"/><input type=\"hidden\" name=\"districtId\" value=\""+districtList[i+3].districtId+"\"/><input type=\"hidden\" name=\"bizPrdoAdId\" value=\""+districtList[i+3].adId+"\"/>"+districtList[i+3].districtName+"<input type=\"text\" name=\"seq\" value=\""+districtList[i+3].seq+"\"/></label>";
				html+="<label><input type=\"hidden\" name=\"rankId\" value=\""+districtList[i+4].rankId+"\"/><input type=\"hidden\" name=\"districtId\" value=\""+districtList[i+4].districtId+"\"/><input type=\"hidden\" name=\"bizPrdoAdId\" value=\""+districtList[i+4].adId+"\"/>"+districtList[i+4].districtName+"<input type=\"text\" name=\"seq\" value=\""+districtList[i+4].seq+"\"/></label>";
			}
			length=districtList.length%5;
			if(length>0){
				for(var i=length;i>0;i--){
					html+="<label><input type=\"hidden\" name=\"rankId\" value=\""+districtList[districtList.length-i].rankId+"\"/><input type=\"hidden\" name=\"districtId\" value=\""+districtList[districtList.length-i].districtId+"\"/><input type=\"hidden\" name=\"bizPrdoAdId\" value=\""+districtList[districtList.length-i].adId+"\"/>"+districtList[districtList.length-i].districtName+"<input type=\"text\" name=\"seq\" value=\""+districtList[districtList.length-i].seq+"\"/></label>";
				}
			}
				html+="</div>";
			return html;
		}
		
		function updatedata(data,seq,indexArea){
			var adId=$("input[name=prodAdId]").val();
			var districtList=new Array();
			var districtObj=new Object();
			var k=0;
			for(var i=0;i<data.length;i++){
				var cityList=data[i].prodCityList;
				if(cityList.length<=0){
					continue;
				}
				for(var j=0;j<cityList.length;j++){
					districtObj=new Object();
					districtObj.seq=seq;
					districtObj.adId=adId;
					districtObj.rankId="";
					districtObj.districtId=cityList[j].districtId;
					districtObj.districtName=cityList[j].districtName;
					if(cityList[j].bizProdAdRank!=null){
						districtObj.seq=seq;
						if(cityList[j].bizProdAdRank.rankId !=null){
							districtObj.rankId=cityList[j].bizProdAdRank.rankId;
						}
					}
					districtList[k]=districtObj;
					k++;
				}
			}
			//设置区域的城市
			areaList[indexArea]=districtList;
		}
</script>
</body>
</html>
