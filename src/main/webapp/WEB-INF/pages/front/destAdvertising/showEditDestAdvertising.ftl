<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<style>
	.p_fixed {
		position: fixed;
		top: 0;
		height: 40px;
		width: 100%;
		background: #fff;
	}
	.iframe_content {
		padding-top: 40px;
	}
	.p_fixed button {
		margin-right: 40px;
	}
	#saveButton {
		float: right;
		margin-top: 5px;
	}
</style>
<body>
<div class="iframe_header">
	  <div class="p_fixed">
	 &nbsp; 出发地:<select id="districtName" name ="distrId">
	 <option value="">请选择</option>
	  <option value="-1">全国出发</option>
	  <option value="-2">多出发地</option>
	  	<#if bizDistrictList?? &&  bizDistrictList?size gt 0 >
	  <#list bizDistrictList as bdl>
	    <option value = "${bdl.districtId}">${bdl.districtName}</option> 
	  </#list>
	  </#if>
	  </select>
	  	<a class="btn btn_cc1"  id="new_button">添加产品</a>
	  	<button class="pbtn pbtn-small btn-ok" id="saveButton" name="saveButton">保存</button>
	  </div>
</div> 
<div class="iframe_content">   
<div class="p_box">
<input type="hidden" name="categoryIds" value="${categoryIds!''}">
<form id="destAdvertisingForm">
	<input type="hidden" name="destId" value="${dest.destId!''}">
	<input type="hidden" name="destName" value="${dest.destName!''}">
	<input type="hidden" name="showTab" value="${showTab!''}" id="showTab">
	<input type="hidden" name="subId" value="${subId!''}" id='subId' />
	
	<input type="hidden"  value="${cancelStickNumS}" id="cancelStickNumS">
	<div class="p_box box_info p_line">
			  <div class="box_content">
              <table class="p_table table_center" id="freeTable">
		  		<thead>
                    	<th>编号</th>
                    	<#if categoryIds == "4"><th>规格ID</th><#else><th>产品ID</th></#if>
                    	<th>出发地</th>
                    	<#if categoryIds == "4"><th>规格名称</th><#else><th>产品名称</th></#if>
                    	<#if showTab=='FREETOUR' || showTab=='GROUP' || showTab=='AROUND' || showTab=='ROUTE'>
                    	 <th>是否可售</th>
                    	</#if>
                    	<#if showTab=='FREETOUR' || showTab=='GROUP' || showTab=='AROUND' || showTab=='ROUTE'>
						  <th>品类</th>     
						</#if>
                    	<th>seq值</th>
                    	<th>操作</th>
          			</thead>
                    <tbody id="tbody">
                    <#if bizProdAdList?? && bizProdAdList?size gt 0 >
		                <#list bizProdAdList as bizProdAd>
		                	<#if bizProdAd.prodProduct.bizCategoryId =="4">
				                 <#list bizProdAd.prodProduct.prodProductBranchList as prodBranch>
					                  <tr districtId="${bizProdAd.prodProduct.bizDistrictId}">
						            	<td>${bizProdAd_index + 1}</td>
						            	<td class= "productBanchID_${bizProdAd_index}" style="">${prodBranch.productBranchId}</td>
						            	<td class="distrt_${bizProdAd_index}" id="distrt_${bizProdAd.prodProduct.productId}">
						            		<select>
						            		<#if bizProdAd.prodProduct.bizDistrict??>
						            			<#if bizProdAd.prodProduct.muiltDpartureFlag?? && bizProdAd.prodProduct.muiltDpartureFlag=='Y'>
						            				多出发地
						            			<#else>
						            				${bizProdAd.prodProduct.bizDistrict.districtName}
							            		</#if>
						            		<#else>
						            			全国出发
						            		</#if>
						            		</select>
						            	</td>
						            	<td><input  type="text" name="aroundDest" class="w35" id="productBranchId_${prodBranch_index}"   value="${prodBranch.branchName}" data="${prodBranch.productBranchId}"   readonly = "readonly"></td>
						            	<td><input style='width:40px;height:13px' name="bizProdAdList[${bizProdAd_index}].seq" value="${bizProdAd.seq}" digits='true' ></td>
						            	<td><a class='btn btn_cc1' name='del_button' >删除</a></td>
						            	<input type="hidden" name="bizProdAdList[${bizProdAd_index}].productId"  id="productId${bizProdAd_index}" value="${bizProdAd.productId}"/>
						            	<input type="hidden" name="bizProdAdList[${bizProdAd_index}].destId" id="destId" value="${bizProdAd.destId}"/>
						            	<input type="hidden" name="bizProdAdList[${bizProdAd_index}].prodProduct.bizCategoryId" class='categoryId'  value="${bizProdAd.prodProduct.bizCategoryId}"/>
						            	<input type="hidden" name="bizProdAdList[${bizProdAd_index}].prodProduct.subCategoryId" class='subCategoryId'  value="${subId}"/>
						            	<input type="hidden" name="bizProdAdList[${bizProdAd_index}].productBranchId" id="productBranchId${prodBranch_index}" value="${prodBranch.productBranchId}"/>
				        	         </tr>
				        	     </#list>
			        	    <#else>
			        	    	 <tr districtId="${bizProdAd.prodProduct.bizDistrictId}">
						            	<td>${bizProdAd_index + 1}</td>
					            		<td class= "productID_${bizProdAd_index}">${bizProdAd.prodProduct.productId}</td>
						            	<td class="distrt_${bizProdAd_index}" id="distrt_${bizProdAd.prodProduct.productId}">
						            		<#assign seqDisableFlag = 'N' />
											<#if bizProdAd.type=='ROUTE' || bizProdAd.type=='GROUP'  || bizProdAd.type=='AROUND' || (bizProdAd.type=='FREETOUR'&&bizProdAd.subCategoryId==182)>
						            			<#if bizProdAd.districtType??>
						            				<#if bizProdAd.districtType=='MUILT_DEPARTURE'>
														<#assign seqDisableFlag = 'Y' />
														<select data="${bizProdAd.adId}" onclick="selectMuiltBizProd(this)">
						            						<#if bizProdAd.prodProduct.bizDistrict??>
						            							<option selected="selected">${bizProdAd.prodProduct.bizDistrict.districtName}</option>
						            						<#else>
						            							<option selected="selected">${bizDistrictList[0].districtName}</option>
						            						</#if>
						            					</select>
						            				<#else>
						            					<#if bizProdAd.prodProduct.bizDistrict??>
						            						${bizProdAd.prodProduct.bizDistrict.districtName}
						            					<#else>
						            						全国出发
						            					</#if>
							            			</#if>
						            			</#if>
						            		<#else>
						            			<#if bizProdAd.prodProduct.bizDistrict??>
						            				<#if bizProdAd.prodProduct.muiltDpartureFlag?? && bizProdAd.prodProduct.muiltDpartureFlag=='Y'>
						            					多出发地
						            				<#else>
						            					${bizProdAd.prodProduct.bizDistrict.districtName}
							            			</#if>
						            			<#else>
						            				全国出发
						            			</#if>
						            		</#if>
						            	</td>
						            	<td>
						            	 <#if  showTab=='GROUP'>
						            	   <#if bizProdAd.prodProduct.productType=='INNERSHORTLINE'>
						            	      <input type="checkbox"   value="7"  <#if bizProdAd.cancelStickNum==7 >checked</#if>    name="bizProdAdList[${bizProdAd_index}].cancelStickNum" id="cancelStickNum${bizProdAd_index}">7天无团期取消置顶
						            	    <#elseif bizProdAd.prodProduct.productType=='INNERLONGLINE'>
						            	      <input type="checkbox"   value="30" <#if bizProdAd.cancelStickNum==30 >checked</#if>  name="bizProdAdList[${bizProdAd_index}].cancelStickNum" id="cancelStickNum${bizProdAd_index}"  >30天无团期取消置顶
						            	    <#elseif bizProdAd.prodProduct.productType=='FOREIGNLINE'>
						            	    <input type="checkbox"    value=""   name="bizProdAdList[${bizProdAd_index}].cancelStickNum" id="cancelStickNum${bizProdAd_index}" disabled >天无团期取消置顶
						            	    <#else>  
						            	      <input type="checkbox"   value=""    name="bizProdAdList[${bizProdAd_index}].cancelStickNum" id="cancelStickNum${bizProdAd_index}"  >天无团期取消置顶
						            	   </#if>
						            	 </#if>
						            	 <#if showTab=='FREETOUR'>
						            	 	<#if bizProdAd.prodProduct.productType=='FOREIGNLINE'>
						            	 	<input type="checkbox"  disabled  name="bizProdAdList[${bizProdAd_index}].cancelStickNum" id="cancelStickNum${bizProdAd_index}"  >${cancelStickNumS}天无团期取消置顶
						            	 	<#else>
						            	     	<input type="checkbox"   value="${cancelStickNumS}"  <#if cancelStickNumS ?? && bizProdAd.cancelStickNum==cancelStickNumS >checked</#if>  name="bizProdAdList[${bizProdAd_index}].cancelStickNum" id="cancelStickNum${bizProdAd_index}"  >${cancelStickNumS}天无团期取消置顶
						            	 	</#if>
						            	 </#if>
						            	  
						            	 
						            	 
						            	<input  type="text" name="aroundDest" class="w35" id="productId_${bizProdAd_index}"   value="${bizProdAd.prodProduct.productName}" data="${bizProdAd.prodProduct.productId}"   readonly = "readonly"></td>
						            	<#if showTab=='FREETOUR' || showTab=='GROUP' || showTab=='AROUND' || showTab=='ROUTE'>
						            	   <td   class="saleFlag_${bizProdAd_index}" id="saleFlag_${bizProdAd.prodProduct.productId}"  >
						            	    <#if bizProdAd.prodProduct.saleFlag == 'Y'>是
						            	    <#else>
						            	         否
						            	    </#if>
						            	   </td> 
						            	</#if>
						            	<#if showTab=='FREETOUR' || showTab=='GROUP' || showTab=='AROUND' || showTab=='ROUTE'>
						            	   		<td   class="categoryId_${bizProdAd.prodProduct.bizCategoryId}" id="subCategoryId_${bizProdAd.prodProduct.bizCategoryId}"  >
						            	    	<#if bizProdAd.prodProduct.subCategoryId == 181>
						            	    		景+酒
						            	    	<#elseif bizProdAd.prodProduct.subCategoryId == 182>
						            	      		 机+酒
						            	   	 	<#elseif bizProdAd.prodProduct.subCategoryId == 183>
						            	    		交通+服务
						            	    	<#else>
						            	    		${bizProdAd.prodProduct.bizCategory.categoryName}
						            	    	</#if>
						            	   		</td> 
						            	</#if>
						            	<td><input style='width:40px;height:13px' name="bizProdAdList[${bizProdAd_index}].seq" value="${bizProdAd.seq}" digits='true' <#if seqDisableFlag?? && seqDisableFlag=='Y'>disabled="disabled"</#if></td>
						            	<td><a class='btn btn_cc1' name='del_button' >删除</a></td>
						            	<input type="hidden" name="bizProdAdList[${bizProdAd_index}].productId"  id="productId${bizProdAd_index}" value="${bizProdAd.productId}"/>
						            	<input type="hidden" name="bizProdAdList[${bizProdAd_index}].destId" id="destId" value="${bizProdAd.destId}"/>
						            	<input type="hidden" name="bizProdAdList[${bizProdAd_index}].prodProduct.bizCategoryId" class='categoryId'  value="${bizProdAd.prodProduct.bizCategoryId}"/>
						            	<input type="hidden" name="bizProdAdList[${bizProdAd_index}].prodProduct.subCategoryId" class='subCategoryId'  value="${subId}"/>
						            	<input type="hidden" name="bizProdAdList[${bizProdAd_index}].productBranchId" id="productBranchId${bizProdAd_index}" value="${bizProdAd.productBranchId}"/>
						            	<input type="hidden" name="bizProdAdList[${bizProdAd_index}].adId"  id="adId${bizProdAd_index}" value="${bizProdAd.adId}"/>
						            	<input type="hidden" name="bizProdAdList[${bizProdAd_index}].districtType"  id="districtType${bizProdAd_index}" value="${bizProdAd.districtType}"/>
				        	    </tr>
			        	    </#if>
                		</#list>
                	</#if>
                	</tbody>
                	
                </table>
            </div>
            
		</div>
		
</form>
</div>
</div><!-- //主要内容显示区域 -->
<#include "/base/foot.ftl"/>
</body>
</html>

<script>




$(function(){
	
	var count = 0,muiltCount = 0;
	$("#districtName").val(${distrId});
	var distrId = $("#districtName").val();
	if(distrId != "" && distrId !=undefined){   //当选择不是请选择选选项并且不是门票品类
	var showTab=$("#showTab").val();
	//过滤下拉框选项匹配的数据显示在页面
	$("tbody tr").each(function(){
		 	if($(this).attr("districtId")==distrId){
		 		$(this).show();
		 	}else if(showTab == "ROUTE" && ($(this).attr("districtId")==distrId || $(this).attr("districtId") == -1)){
		 		$(this).show();
		 	}else{
		 		$(this).hide();
		 	}
		 });
	}
	
	//获取全国出发选项数量
	$("tbody tr").each(function(){
		 	if($(this).attr("districtId")=="-1"){
		 		count = count + 1;
		 	} else if ($(this).attr("districtId")=="-2") {
		 		muiltCount = muiltCount + 1;
		 	}
		 	
		 });
		 
	//去除重复的全国出发选项	
	if(count == 0){
		$("#districtName option[value = '-1']").remove();
	}
	//去除重复的多出发地选项	
	if(muiltCount == 0){
		$("#districtName option[value = '-2']").remove();
	}
	
	
	
$("#new_button").hover(function(){

if(validateExist()){
		alert("存在重复产品");
		return;
	}

});



});

//校验页面重复的数据
function validateExist(){  
    var flag=false;  
  
    var array = [];  
    var categoryId = $("input[class='categoryId']").val();
    if(categoryId == '4'){
    	$("input[name$='].productBranchId']").each(function() { 
      	var value = $(this).val();
      	if(value != ""){
      	if(jQuery.inArray(value,array)>=0) {  
         flag=true;  
        } else{
        	array.push($(this).val());
        };
      	} 
          
      });  
    }else{
      $("input[name$='].productId']").each(function() { 
      	var value = $(this).val();
      	if(value != ""){
      	if(jQuery.inArray(value,array)>=0) {  
         flag=true;  
        } else{
        	array.push($(this).val());
        };
      	} 
          
      });  
    }
    return flag;      
}  



//下拉框选择后发送请求刷新面板
$("#districtName").change(function(){
	var distrId = $("#districtName").val();
	var showTabValue = $('#showTab',window.parent.document).val();
	
		var obj;
		if(showTabValue != ""){
			obj = $('#' + showTabValue);
		}else{
			obj = $('#show1');
		}
		parent.clickTab(showTabValue,distrId, $('#subId').val());

});



$("#saveButton").click(function(){
	addDestAdvertising();
});

function addDestAdvertising(){

	if(!$("#destAdvertisingForm").validate().form()){
			return false;
		}
		
		if(validateExist()){
			alert("存在重复产品");
			return;
		}
		
		
		if($("tbody tr").size()>300){
		  alert("最多能关联300个产品");
		  return;
		}
		var commitFlag=true;
		$(".productId").each(function (){
				if($(this).val()=="" || $(this).val()==null){
					alert("请将产品补充完整");
					commitFlag=false;
					return false;
				}
		});
		if(!commitFlag){
			return;
		}	
		var msg = '确认保存吗 ？';	 
		$.confirm(msg,function(){
			//遮罩层
			$("#saveButton").attr("disabled","disabled");
			
			$.ajax({
				url : "/vst_admin/front/destAdvertising/addDestAdvertising.do",
				type : "post",
				dataType : 'json',
				data : $("#destAdvertisingForm").serialize(),
				success : function(result) {
					if(result.code == "success"){
						pandora.dialog({
							wrapClass: "dialog-mini", 
							content: result.message, 
							okValue: "确定",
							mask: true, 
							ok:function() {
								$("#saveButton").removeAttr("disabled");
								
								var showTabValue = $('#showTab',window.parent.document).val();
								var obj;
								obj = $('#' + showTabValue);
								parent.clickTab(showTabValue,"", $('#subId').val());
							}
						});
					}else {
						$.alert(result.message);
						$("#saveButton").removeAttr("disabled");
					}
				},
				error : function(){
					pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",mask:true,ok:function(){
							$("#saveButton").removeAttr("disabled");
							
							var showTabValue = $('#showTab',window.parent.document).val();
							var obj;
							obj = $('#' + showTabValue);
							parent.clickTab(showTabValue,"");
							
						}});
				}
			  });
		});
}

var prodSelectDialog;
var seqSelectDialog;
var prods = ',';//子页面选择项对象数组
var prodBranchs = ',';
var count =0;
var markProd;
var markProdId;

//编辑页加载时先累计已有的产品ID
$("input[name='aroundDest']").each(function(){
	markProdId = $(this).next().attr("id");
 	if($('#'+ markProdId).val()!=""){
 		if(prods == ","){
 			prods = $('#'+ markProdId).val();
 		}else{
 			prods = prods + "," + $('#'+ markProdId).val();
 		}
 	}
});

//选择目的地返回方法
function onSelectProd(params){
	if(params!=null){
		var  prodId = params.productId;
		var  productBranchId = params.productBranchId;
		prods = "";
		prodBranchs="";
		$("#"+markProdId).val(prodId);
		if(params.bizCategoryId == "4"){
			$('#freeTable thead:eq(0) th:eq(1)').html("<th>规格ID</th>");
			$("#"+markProd).parents("tr").find("td[class*= 'productBranchID_']").text(productBranchId);
			$("#"+markProd).parents("tr").find("input[class= 'productBranchId']").val(productBranchId);
			$("#"+markProd).parents("tr").find("td[class*= 'productBranchID_']").show();
			$("#"+markProd).parents("tr").find("td[class*= 'productID_']").hide();
			$("#"+markProd).val(params.branchName);
			for(var i = 0; i < 300; i++){
				if($("#productBranchId_"+i) != null){
					if($("#productBranchId_"+i).attr("data") != "undefined"){
						 prodBranchs = prodBranchs + ',' + $("#productBranchId_"+i).attr("data");
					}
				}
		    }
			
			if((prodBranchs+',').indexOf(','+productBranchId+',')==0 || (prodBranchs+',').indexOf(','+productBranchId+',')> 0 )
			{
			    alert('产品规格已经存在');
			    return;
			}else{
				prodBranchs = prodBranchs + ',' + productBranchId;
			}
		}else{
			$('#freeTable thead:eq(0) th:eq(1)').html("<th>产品ID</th>");
			$("#"+markProd).parents("tr").find("td[class*= 'productID_']").text(prodId);
			$("#"+markProd).parents("tr").find("input[class= 'productId']").val(prodId);
			$("#"+markProd).parents("tr").find("td[class*= 'productID_']").show();
			$("#"+markProd).parents("tr").find("input[id*= 'productBranchId_']").hide();
			$("#"+markProd).val(params.productName);
			for(var i = 0; i < 300; i++){
				if($("#productId_"+i) != null){
					if($("#productId_"+i).attr("data") != "undefined"){
						 prods = prods + ',' + $("#productId_"+i).attr("data");
					}
				   }
		     }
			if((prods+',').indexOf(','+prodId+',')==0 || (prods+',').indexOf(','+prodId+',')> 0 )
			{
			    alert('产品已经存在');
			    return;
			}else{
				prods = prods + ',' + prodId;
			}
		}
		
		$("#"+markProd).parents("tr").find("input[class='categoryId']").val(params.bizCategoryId);
		$("#"+markProd).parents("tr").find("input[class='subCategoryId']").val($("#subId").val());
			
		if(params.districtName !=undefined){
			if (params.muiltDpartureFlag != 'Y') {
				$("#"+markProd).parents("tr").find("td[class*= 'distrt_']").text(params.districtName);
			} else {
				if('FREETOUR'==$("#showTab").val() ||"GROUP"==$("#showTab").val() ||"ROUTE"==$("#showTab").val() || "AROUND"==$("#showTab").val()){
					
					if(params.districtName !=""){
						var html="";
						var selectIndex=$("#"+markProd).parents("tr").find("td").eq(0).html()-1;
						html="<select onclick='selectMuiltBizProd(this)'>";
						html+="<option selected='selected'>"+params.districtName+"</option>";
						html+="</select>";
						$("#"+markProd).parents("tr").find("td[class*= 'distrt_']").append(html);
						//$("#"+markProd).parents("tr").find("td[class*= 'distrt_']").append("多出发地");
						$("#"+markProd).parents("tr").find("input[class*= 'districtType'] ").val("MUILT_DEPARTURE");;
						
					}else{
						$("#"+markProd).parents("tr").find("td[class*= 'distrt_']").text("多出发地");
						$("#"+markProd).parents("tr").find("input[class*= 'districtType'] ").val("MUILT_DEPARTURE");
					}
				}else{
					$("#"+markProd).parents("tr").find("td[class*= 'distrt_']").text("多出发地");
					$("#"+markProd).parents("tr").find("input[class*= 'districtType'] ").val("MUILT_DEPARTURE");
				}
			}
		}else{
			$("#"+markProd).parents("tr").find("td[class*= 'distrt_']").text("全国出发");
			$("#"+markProd).parents("tr").find("input[class*= 'districtType'] ").val("NONE_DEPARTURE");
		}
		
		if(params.saleFlag =='Y'){
		   $("#"+markProd).parents("tr").find("td[class*= 'saleFlag_']").text("是");
		}else{
		   $("#"+markProd).parents("tr").find("td[class*= 'saleFlag_']").text("否");
		}
		if('FREETOUR'==$("#showTab").val() ||"GROUP"==$("#showTab").val() ||"ROUTE"==$("#showTab").val() || "AROUND"==$("#showTab").val()){
			if(params.bizCategoryId==18){
				if(params.bizSubCategoryId =='181'){
					$("#"+markProd).parents("tr").find("td[class*= 'categoryId_']").text("景+酒");
				}else if(params.bizSubCategoryId =='182'){
					$("#"+markProd).parents("tr").find("td[class*= 'categoryId_']").text("机+酒");
				}else if(params.bizSubCategoryId =='183'){
					$("#"+markProd).parents("tr").find("td[class*= 'categoryId_']").text("交通+服务");
				}
			}else{
				$("#"+markProd).parents("tr").find("td[class*= 'categoryId_']").text(params.bizCategoryName);
			}
		}
		if('FREETOUR'==$("#showTab").val() ||"GROUP"==$("#showTab").val()){
			if(params.productType=="FOREIGNLINE"){
				 $("#"+markProd).parents("tr").find("input[type=checkbox]").attr("checked",false);
				 $("#"+markProd).parents("tr").find("input[type=checkbox]").attr("disabled",true);
			}else{
				$("#"+markProd).parents("tr").find("input[type=checkbox]").attr("disabled",false);
				 $("#"+markProd).parents("tr").find("input[type=checkbox]").attr("checked",true);
			}
		}
		if("GROUP"==$("#showTab").val()){
		    if(params.productType=="INNERSHORTLINE"){
		       $("#"+markProd).parents("tr").find("input[class='cancelStickNum']").val("7");
		       $("#"+markProd).parents("tr").find("span[class*= 'cancelStickNum_']").text("7天无团期取消置顶");
		     
		    }else if(params.productType=="INNERLONGLINE"){
		       $("#"+markProd).parents("tr").find("input[class='cancelStickNum']").val("30");
		       $("#"+markProd).parents("tr").find("span[class*= 'cancelStickNum_']").text("30天无团期取消置顶");
		    }else{
		       $("#"+markProd).parents("tr").find("input[class='cancelStickNum']").val("");
		    }
		}
	}
	prodSelectDialog.close();
}

var cateGroyType = "${cateGroyType}";
var index = $("input[name=aroundDest]").size();

//新建产品
$("#new_button").bind("click",function(){
	if($("tbody tr").size()>=300){
	  alert("最多能关联300个产品");
	  return;
	}
	var cancelS=$("#cancelStickNumS").val();
	var showTab=$("#showTab").val();
	var $tbody = $("#tbody");
	count = index;
	var number = $("tbody tr").size() + 1;
	var hasDirstrt = "";
		hasDirstrt = "<td class=" + 'distrt_' +number+'></td>';
	if(showTab=="FREETOUR"){	 
	  $tbody.append("<tr><td>"+number+"<td class=productID_"+number+" ><td class=productBranchID_"+number+" style='display:none'></td>"+hasDirstrt+"</td><td><input type='checkbox' name='bizProdAdList["+count+"].cancelStickNum'  checked id='cancelStickNum"+count+"' value="+cancelS+" class='cancelStickNum' >"+cancelS+"天无团期取消置顶<input type='text' class='w35' name='aroundDest' id='productId_"+count+"' readonly = 'readonly'/></td><td class='saleFlag_"+count+"' ></td><td class='categoryId_"+count+"'></td><td><input type='text' style='height:13px;width:33px;'  name='bizProdAdList["
		+count+"].seq' digits='true'/></td><input type='hidden' name='bizProdAdList["+count+"].districtType' id='districtType"+count+"' class='districtType'/><input type='hidden' name='bizProdAdList["
		+count+"].productId' id='productId"+count+"' class='productId'/><input type='hidden' name='bizProdAdList["+count+"].prodProduct.bizCategoryId' class='categoryId' /><input type='hidden' name='bizProdAdList["
		+count+"].prodProduct.subCategoryId' class='subCategoryId'/><input type='hidden' name='bizProdAdList["
		+count+"].productBranchId' id='productBranchId"+count+"' class='productBranchId'/><td><a class='btn btn_cc1' name='del_button'>删除</a></td></tr>");  
	index++;
	}else if(showTab=="GROUP"){
	  $tbody.append("<tr><td>"+number+"<td class=productID_"+number+" ><td class=productBranchID_"+number+" style='display:none'></td>"+hasDirstrt+"</td><td><input type='checkbox' name='bizProdAdList["+count+"].cancelStickNum' checked  id='cancelStickNum"+count+"' class='cancelStickNum' ><span class='cancelStickNum_"+count+"'>无团期取消置顶</span><input type='text' class='w35' name='aroundDest' id='productId_"+count+"' readonly = 'readonly'/></td><td  class='saleFlag_"+count+"'></td><td class='categoryId_"+count+"'></td><td><input type='text' style='height:13px;width:33px;'  name='bizProdAdList["
		+count+"].seq' digits='true'/></td><input type='hidden' name='bizProdAdList["
		+count+"].productId' id='productId"+count+"' class='productId'/><input type='hidden' name='bizProdAdList["+count+"].prodProduct.bizCategoryId' class='categoryId' /><input type='hidden' name='bizProdAdList["
		+count+"].prodProduct.subCategoryId' class='subCategoryId'/><input type='hidden' name='bizProdAdList["
		+count+"].productBranchId' id='productBranchId"+count+"' class='productBranchId'/><td><a class='btn btn_cc1' name='del_button'>删除</a></td></tr>");  
	index++;
	}else if(showTab=="ROUTE"){
	  $tbody.append("<tr><td>"+number+"<td class=productID_"+number+" ><td class=productBranchID_"+number+" style='display:none'></td>"+hasDirstrt+"</td><td><input type='text' class='w35' name='aroundDest' id='productId_"+count+"' readonly = 'readonly'/></td><td class='saleFlag_"+count+"' ></td><td class='categoryId_"+count+"'></td><td><input type='text' style='height:13px;width:33px;'  name='bizProdAdList["
		+count+"].seq' digits='true'/></td><input type='hidden' name='bizProdAdList["+count+"].districtType' id='districtType"+count+"' class='districtType'/><input type='hidden' name='bizProdAdList["
		+count+"].productId' id='productId"+count+"' class='productId'/><input type='hidden' name='bizProdAdList["+count+"].prodProduct.bizCategoryId' class='categoryId' /><input type='hidden' name='bizProdAdList["
		+count+"].prodProduct.subCategoryId' class='subCategoryId'/><input type='hidden' name='bizProdAdList["
		+count+"].productBranchId' id='productBranchId"+count+"' class='productBranchId'/><input type='hidden' name='bizProdAdList["+count+"].cancelStickNum' id='cancelStickNum"+count+"' class='cancelStickNum'/><td><a class='btn btn_cc1' name='del_button'>删除</a></td></tr>");  
	index++;
	}else if(showTab=="AROUND"){
	  $tbody.append("<tr><td>"+number+"<td class=productID_"+number+" ><td class=productBranchID_"+number+" style='display:none'></td>"+hasDirstrt+"</td><td><input type='text' class='w35' name='aroundDest' id='productId_"+count+"' readonly = 'readonly'/></td><td class='saleFlag_"+count+"' ></td><td class='categoryId_"+count+"'></td><td><input type='text' style='height:13px;width:33px;'  name='bizProdAdList["
		+count+"].seq' digits='true'/></td><input type='hidden' name='bizProdAdList["
		+count+"].districtType' id='districtType"+count+"' class='districtType'/><input type='hidden' name='bizProdAdList["
		+count+"].productId' id='productId"+count+"' class='productId'/><input type='hidden' name='bizProdAdList["+count+"].prodProduct.bizCategoryId' class='categoryId' /><input type='hidden' name='bizProdAdList["
		+count+"].prodProduct.subCategoryId' class='subCategoryId'/><input type='hidden' name='bizProdAdList["
		+count+"].productBranchId' id='productBranchId"+count+"' class='productBranchId'/><input type='hidden' name='bizProdAdList["+count+"].cancelStickNum' id='cancelStickNum"+count+"' class='cancelStickNum'/><td><a class='btn btn_cc1' name='del_button'>删除</a></td></tr>");  
	index++;
	}else{
	 $tbody.append("<tr><td>"+number+"<td class=productID_"+number+" ><td class=productBranchID_"+number+" style='display:none'></td>"+hasDirstrt+"</td><td><input type='text' class='w35' name='aroundDest' id='productId_"+count+"' readonly = 'readonly'/></td><td><input type='text' style='height:13px;width:33px;'  name='bizProdAdList["
		+count+"].seq' digits='true'/></td><input type='hidden' name='bizProdAdList["
		+count+"].productId' id='productId"+count+"' class='productId'/><input type='hidden' name='bizProdAdList["+count+"].prodProduct.bizCategoryId' class='categoryId' /><input type='hidden' name='bizProdAdList["
		+count+"].prodProduct.subCategoryId' class='subCategoryId'/><input type='hidden' name='bizProdAdList["
		+count+"].productBranchId' id='productBranchId"+count+"' class='productBranchId'/><input type='hidden' name='bizProdAdList["+count+"].cancelStickNum' id='cancelStickNum"+count+"' class='cancelStickNum'/><td><a class='btn btn_cc1' name='del_button'>删除</a></td></tr>");  
	index++;
	}
});

//删除产品
$("a[name=del_button]").live("click",function(){
		$(this).parents("tr").remove();
});

//打开选择产品
$("input[name=aroundDest]").live("click",function(){
	markProd = $(this).attr("id");
	var idValue = markProd.split('_')[1];
	markProdId = 'productId'+idValue;
	var url = "/vst_admin/front/destAdvertising/findProductList.do?categoryIds=${categoryIds}&showTab=${showTab}";
	prodSelectDialog = new xDialog(url,{},{title:"选择产品",iframe:true,width:800,height:670});
});

//多出发地与无出发地，打开选择城市并设置对应的seq值
function selectMuiltBizProd(_this){
	var adId=$(_this).attr("data");
	if(adId == null){
		alert("请先提交选择的该产品，提交后再设置");
		return;
	}
	var url = "/vst_admin/front/destAdvertising/showDestCitySeq.do?adId="+adId;
	seqSelectDialog = new xDialog(url,{},{title:"设置seq值",iframe:true,width:900,height:600});
}

function getcategoryIds(){
	
	return $("input[name = 'categoryIds']").val();
}
 function closeSeqSelectDialog(){
 	this.seqSelectDialog.close();
 	addDestAdvertising();
 }
</script>