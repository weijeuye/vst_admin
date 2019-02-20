<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
<#include "/base/findProductInputType.ftl"/>
<link rel="stylesheet" href="/vst_admin/css/calendar.css" type="text/css"/>

</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">${prodProduct.bizCategory.categoryName}</a> &gt;</li>
            <li><a href="#">产品维护</a> &gt;</li>
            <li class="active">修改产品</li>
        </ul>
</div>
<div class="iframe_content mt10">
<div class="tiptext tip-warning">
	<span class="tip-icon tip-icon-warning"></span>注：产品创建后，不能变更所属的品类
    <br/><span class="tip-icon tip-icon-warning"></span>注：国内酒店行政区划，必须录入至【区/县】级
</div>
<!-- 酒店品类，提示没有设置产品图片 -->
<#if prodProduct.bizCategory.categoryId==1 && photoCount?? && (photoCount &lt; 1)>
	<div class="tiptext tip-error"><span class="tip-icon tip-icon-error"></span>该产品未上传图片，请完善</div>
</#if>
<!-- 酒店品类，提示没有设置图片的规格 -->
<#if prodProduct.bizCategory.categoryId==1 && productBranchList?? && (productBranchList?size &gt; 0)>
	<div class="tiptext tip-error"><span class="tip-icon tip-icon-error"></span>产品规格编号
		<#list productBranchList as productBranch>
			${productBranch.productBranchId} 
		</#list>
		 未上传图片，请完善
	</div>
</#if>
<form action="/vst_admin/prod/product/addProduct.do" method="post" id="dataForm">
		<input type="hidden" name="senisitiveFlag" value="N">
        <div class="p_box box_info p_line">
            <div class="box_content">
            <table class="e_table form-inline">
            <tbody>
                <tr>
                	<td width='150' class="e_label"><span class="notnull">*</span>所属品类：</td>
                	<td>
                		<input type="hidden" name="bizCategoryId" value="${prodProduct.bizCategory.categoryId}" required>
                		<input type="hidden" name="categoryName" value="${prodProduct.bizCategory.categoryName}">
                		${prodProduct.bizCategory.categoryName}
                	</td>
                </tr>
                <tr>
                	<td class="e_label"><span class="notnull">*</span>产品ID：</td>
                    <td>
                    	<input type="text" class="w35" name="productId" value="${prodProduct.productId}" readonly="readonly">
                    	<input type="hidden" id="productOldName" value="${prodProduct.productName}" />
                    </td>
                </tr>
                <#if prodProduct.bizCategory.categoryId == 1>
                 <tr>
                    <td class="e_label"><i class="cc1">*</i>类别：</td>
                    <td>
                       <#list productTypeList as list>
                           <#if list.code == 'FOREIGNLINE'|| list.code='INNERLINE'>
                               <input type="radio" name="productType" value="${list.code!''}"  <#if prodProduct.productType==list.code>checked="true"</#if> required />  ${list.cnName!''}
                           </#if>
                       </#list>
                       <div id="productTypeError"></div>
                    </td>
                </tr>
                </#if>
				<tr>
                	<td class="e_label"><span class="notnull">*</span>产品名称：</td>
                    <td>
                    	<label><input type="text" class="w35" style="width:700px" name="productName" id="productName" value="${prodProduct.productName}" <#if prodProduct.bizCategory?? && prodProduct.bizCategory.categoryId==1>onblur="validProductName(this,'${prodProduct.productId!''}')"</#if> required>&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||"</label>
                    	<div id="productNameTip"></div>
                    	<div id="productNameError"></div>
                    </td>
                </tr>
               	<tr>
					<td class="e_label"><span class="notnull">*</span>状态：</td>
					<td>
					<#if prodProduct.cancelFlag == 'Y'>有效<#else>无效</#if>
						<#--<select name="cancelFlag" required>-->
			                    <#--<option value='Y' <#if prodProduct.cancelFlag == 'Y'>selected</#if> >是</option>-->
			                    <#--<option value='N' <#if prodProduct.cancelFlag == 'N'>selected</#if> >否</option>-->
	                    <#--</select>-->
                   	</td>
                </tr>
                <tr>
					<td class="e_label"><span class="notnull">*</span>推荐级别：</td>
					<td>
					  <label>
						<select name="recommendLevel" required>
	                    	<option value="5" <#if prodProduct.recommendLevel == '5'>selected</#if> >5</option>
	                    	<option value="4" <#if prodProduct.recommendLevel == '4'>selected</#if> >4</option>
	                    	<option value="3" <#if prodProduct.recommendLevel == '3'>selected</#if> >3</option>
	                    	<option value="2" <#if prodProduct.recommendLevel == '2'>selected</#if> >2</option>
	                    	<option value="1" <#if prodProduct.recommendLevel == '1'>selected</#if> >1</option>
	                    </select>
	                    	说明：由高到低排列，即数字越高推荐级别越高
	                   </label> 
                    </td>
                </tr>
                <tr>
                	<td class="e_label"><span class="notnull">*</span>行政区划：</td>
                    <td>
                    	<input type="text" class="w35" id="district" name="district" required=true  readonly="readonly" value="<#if prodProduct.bizDistrict??>${prodProduct.bizDistrict.districtName!''}</#if>" required>
                    	<input type="hidden" name="bizDistrictId" id="districtId" value="${prodProduct.bizDistrict.districtId}">
                        <div id="bizDistrictAreaErrorMessage" style="display: none;color: red;">行政区划必须录入至 “区/县”级</div>
						<div id="bizDistrictIdError"></div>
                    </td>
                </tr>
                <tr>
					<td class="e_label"><span class="notnull">*</span>产品经理：</td>
					<td>
					<input type="text" class="w35 searchInput" name="managerName" id="managerName" required value="${prodProduct.managerName }"/>
					<input type="hidden" name="managerId" id="managerId" required value="${prodProduct.managerId }"/>
					<span id="tips" style="display:none; color:red;">注：该处信息仅供参考，如需修改请至商品基础设置下进行维护</span>
					<div id="managerNameError"></div>
					</td>
				</tr>
				<#if prodProduct.bizCategory.categoryId == 1>
				<tr>
					<td class="e_label"><span class="notnull">*</span>酒店集团品牌：</td>
					<td>
	        			<input type="hidden" id="brandId" name="productBrand.brandId"  value="${prodProduct.productBrand.brandId}" />
	        			<input type="text" id="brandName" class="w35 search" readonly="readonly" required name="" value="${prodProduct.productBrand.brandName }"
	        					onclick="showBrandInput();" />
					</td>
				</tr>
				</#if>
                </table>
            </div>
        </div>
        
 			<#assign productId="${prodProduct.productId}" />
  			<#assign index=0 />
 			<#list bizCatePropGroupList as bizCatePropGroup>
            <#if bizCatePropGroup.bizCategoryPropList?? && (bizCatePropGroup.bizCategoryPropList?size &gt; 0)>
            <div class="p_box box_info">
            <div class="title">
			    <h2 class="f16">${bizCatePropGroup.groupName!''}：</h2>
		    </div>
            <div class="box_content">
            <table class="e_table form-inline">
             	<tbody>
             		<#list bizCatePropGroup.bizCategoryPropList as bizCategoryProp>
                		<#if (bizCategoryProp??)>
                		
                		<#assign disabled='' />
                		<#if bizCategoryProp.cancelFlag=='N'>
                			<#assign disabled='disabled' />
                		</#if>
                		<#assign prodPropId='' />
                		<#assign propId=bizCategoryProp.propId />
                		<#if bizCategoryProp?? && bizCategoryProp.prodProductPropList[0]!=null>
	                		<#assign prodPropId=bizCategoryProp.prodProductPropList[0].prodPropId />
                		</#if>
	                	<tr>
		                <td width="150" class="e_label td_top">
		                	<#if bizCategoryProp.nullFlag == 'Y'><span class="notnull">*</span></#if>
		                	${bizCategoryProp.propName!''}
		                	<#if bizCategoryProp.cancelFlag=='N'><span style="color:red" class="cancelProp">[无效]</span></#if>：
		                </td>
							<#if bizCategoryProp.propCode == "credit_cards">
								<#assign creditCardValue=bizCategoryProp.prodProductPropList[0].propValue />
                            </tr>
                            <tr>
                                <td width="150" class="e_label td_top">
                                    <div style="color: red">不支持刷卡</div>

                                </td>
                                <td> <input type="checkbox" id="creditCardsNoChecked"  errorEle="errorEle${index}"
                                            value="" onclick="checkNoCreditCards(this,${index})"
											<#if creditCardValue==''>checked</#if>
                                        /><span>不支持刷卡</span></td>

                            </tr>
                            <tr>
                                <td width="150" class="e_label td_top">

                                    <div style="color: red">国内银联卡</div>

                                </td>
                                <td>
									<#list bizCategoryProp.bizDictList as bizDict>
										<#if bizDict.dictName?ends_with("inland")>
                                            <input type="checkbox" name="prodProductPropList[${index}].propValue" errorEle="errorEle${index}"
                                                   value="${bizDict.dictId!''}"
                                                   onclick="checkCreditCards(this,${index})"
												<#list creditCardValue?split(",") as dictId>
												   <#if dictId == bizDict.dictId>checked</#if>
												</#list>
                                                    /><span>${bizDict.dictName?replace("_inland","")}</span>

										</#if>

									</#list>
                                </td>
                            </tr>
                            <tr>
                                <td width="150" class="e_label td_top">
                                    <div style="color: red">国外信用卡明细</div>
                                </td>
                                <td>
									<#list bizCategoryProp.bizDictList as bizDict>
										<#if bizDict.dictName?ends_with("foreign")>
                                            <input type="checkbox" name="prodProductPropList[${index}].propValue" errorEle="errorEle${index}"
                                                   value="${bizDict.dictId!''}"
                                                   onclick="checkCreditCards(this,${index});"
												<#list creditCardValue?split(",") as dictId>
												   <#if dictId == bizDict.dictId>checked<#assign flag='Y' />  </#if>
												</#list>
                                                    /><span>${bizDict.dictName?replace("_foreign","")}</span>
										</#if>
									</#list>
                                </td>
                            </tr>
							</#if>
	                	<td> <span class="${bizCategoryProp.inputType!''}" propId = "${propId }">     		
	                		<input type="hidden" name="prodProductPropList[${index}].prodPropId" value="${prodPropId}" ${disabled}  />
	                		<input type="hidden" name="prodProductPropList[${index}].propId" value="${propId}" ${disabled} />
	                		<!-- 調用通用組件 -->
	                		<@displayHtml productId index bizCategoryProp  />
	                		
	                		<div id="errorEle${index}Error" style="display:inline"></div>
	                		<span style="color:grey">${bizCategoryProp.propDesc!''}</span>
	        				</span></td>
		        		</tr>
		              </#if>
		               <#assign index=index+1 />
                	</#list>
                	</tbody>
                </table>
            </div>
        </div>
        </#if>
		</#list>
        
        <!-- 目的地 -->
		<div class="p_box box_info p_line">
			  <div class="box_content">
                <table class="e_table form-inline">
                    <tbody>
                    <#-- 出发地没要求做 -->
                    <#--
                     <#if prodProduct.bizCategory.categoryCode != 'category_route_hotelcomb'>
		                <tr id="districtTr">
		                <input type="hidden" id="currentMuiltDpartureFlag" value="<#if prodProduct.muiltDpartureFlag??>${prodProduct.muiltDpartureFlag}</#if>" >
		                	<td class="e_label"><#if prodProduct.bizCategory.categoryId!=16><i id="districtFlag" class="cc1">*</i></#if>出发地：</td>
		                 	 <td>
		                    	<input type="text" class="w35" id="district" name="district" readonly = "readonly" value="<#if prodProduct.bizDistrict??>${prodProduct.bizDistrict.districtName!''}</#if>" <#if prodProduct.bizCategory.categoryId != 16>required</#if>/>
		                    	<input type="hidden" name="bizDistrictId" id="districtId" value="<#if prodProduct.bizDistrict??>${prodProduct.bizDistrict.districtId}</#if>" >
		                    	<div id="bizDistrictIdError"></div>
		                    </td>
		                </tr>
	                </#if> -->
	                <#if prodProduct.prodDestReList ?? &&  prodProduct.prodDestReList?size gt 0>
	                <#list prodProduct.prodDestReList as prodDestRe>
		                <tr <#if prodDestRe_index=0>name='no1'</#if>>
		                	<#if prodDestRe_index=0>
					   			<td name="addspan" rowspan='${prodProduct.prodDestReList?size}' class="e_label"><i class="cc1">*</i>目的地：</td>
					   		</#if>
				            <td>
				            	<input type="text" name="dest" class="w35" id="dest${prodDestRe_index}" value="${prodDestRe.destName}[${prodDestRe.destTypeCnName }]" readonly = "readonly" required>
				            	<input type="hidden" name="prodDestReList[${prodDestRe_index}].destId" id="destId" value="${prodDestRe.destId}"> <#if prodDestRe_index gt 0 >  <a class='btn btn_cc1' name='del_button' style='display:none'>删除</a></#if>
				            	<input type="hidden" name="prodDestReList[${prodDestRe_index}].reId" id="reId" value="${prodDestRe.reId}">
				            	<input type="hidden" name="prodDestReList[${prodDestRe_index}].productId" value="${prodProduct.productId}">
				            	<#if prodDestRe_index=0><a class="btn btn_cc1" id="new_button" style='display:none'>添加目的地</a></#if>
				            </td>
		        	    </tr>
                	</#list>
                	<#else>
                	<#--
                	<tr name='no1'>
	                	<td name="addspan" class="e_label"><i class="cc1">*</i>目的地：</td>
	                 	 <td>
	                    	<input type="text" class="w35" id="dest0" name="dest" readonly = "readonly" required>
	                    	<input type="hidden" name="prodDestReList[0].destId" id="destId0" />
	                    	<a class="btn btn_cc1" id="new_button" style='display:none'>添加目的地</a>
	                    	<div id="destError"></div>
	                    </td>
	                </tr>
	                -->
                	</#if>
                
                	</tbody>
                </table>
            </div>
		</div>
        
        <div class="p_box box_info clearfix mb20">
            <div class="fl operate"><a class="btn btn_cc1" id="save">保存</a><a class="btn btn_cc1" id="saveAndNext">保存并维护下一步</a></div>
        </div>
</form>
</div>
<#include "/base/foot.ftl"/>
<script type="text/javascript" src="/vst_admin/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/kindeditor.js"></script>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/plugins/image/image.js"></script>
<script type="text/javascript" src="/vst_admin/js/contentManage/kindEditorConf.js?v1"></script>
</body>
</html>
<script>
var coordinateSelectDialog;
var dictSelectDialog;//标准产品中动态加载中Input_type_select的对话框
var brandSelectDialog;//酒店集团品牌
var busiSelectIndex;//酒店业务字典

	var dataObj=[],markList=[];
	
	$(".sensitiveVad").each(function(){
		var mark=$(this).attr('mark');
	 	var t = lvmamaEditor.editorCreate('mark',mark);
	 	dataObj.push(t);
	 	markList.push(mark);
	});

$(function(){
	
	$("#save").bind("click",function(){
	
    	for(var i=0;i<dataObj.length;i++){
			var temp = dataObj[i].html();
			$(".sensitiveVad").filter("[mark="+markList[i]+"]").text(temp);
		}
			
			//验证
			if(!$("#dataForm").validate({
			rules : {
				productName : {
					isChar : true
				}
					},
			messages : {
				productName : '不可输入特殊字符'
				
			}
		}).form()){
				return;
			}
		
		 var msg = '确认修改吗 ？';	
		 if(refreshSensitiveWord($("input[type='text'],textarea"))){
		 	$("input[name=senisitiveFlag]").val("Y");
		 	msg = '内容含有敏感词,是否继续?';
		 }else {
			 		 $("input[name=senisitiveFlag]").val("N");
		 }	
			
    	$.confirm(msg,function(){
    		var loading = top.pandora.loading("正在努力保存中...");
			//设置附加属性的值
			refreshAddValue();
			$.ajax({
				url : "/vst_admin/prod/product/updateProduct.do",
				type : "post",
				dataType : 'json',
				data : $("#dataForm").serialize(),
				success : function(result) {
					loading.close();
					pandora.dialog({wrapClass: "dialog-mini", content:result.message, mask:true,okValue:"确定",ok:function(){
						parent.checkAndJump();
				}});
				},
				error : function(result) {
					loading.close();
					$.alert(result.message);
				}
			});
    	});
    	
	});

    isView();

    $("#saveAndNext").bind("click",function(){
			$.each(CKEDITOR.instances, function(i, n){
    			$(".ckeditor").each(function(){
    				if($(this).attr('name')==n.name){
    					$(this).text(n.getData());
    				}
    				if($(this).attr("data")=="Y"){
						$(this).attr("required",true);
						$(this).show();
					}
    			});
			}); 
			//验证
			if(!$("#dataForm").validate({
					rules : {
								productName : {
									isChar : true
								}
							},
					messages : {
								productName : '不可输入特殊字符'
							}
				}).form()){
				return false;
			}
			
		 var msg = '确认修改吗 ？';	
		 if(refreshSensitiveWord($("input[type='text'],textarea"))){
		    $("input[name=senisitiveFlag]").val("Y");
		 	msg = '内容含有敏感词,是否继续?';
		 }else {
			$("input[name=senisitiveFlag]").val("N");
			}
			
			$.confirm(msg, function () {
			var loading = top.pandora.loading("正在努力保存中...");
			//设置附加属性的值
			refreshAddValue();
			$.ajax({
				url : "/vst_admin/prod/product/updateProduct.do",
				type : "post",
				dataType : 'json',
				data : $("#dataForm").serialize(),
				success : function(result) {
					loading.close();
					$.alert(result.message);
					var productId = $("input[name='productId']").val();
					var categoryId = $("input[name='bizCategoryId']").val();
					$(".pg_title", parent.document).html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("input[name='productName']").val()+"   "+"品类:"+$("input[name='categoryName']").val()+"   "+"产品ID："+$("input[name='productId']").val());
					window.location.href="/vst_admin/prod/prodbranch/findProductBranchList.do?productId="+productId+"&categoryId="+categoryId;
				},
				error : function(result) {
					loading.close();
					$.alert(result.message);
				}
			});
			});
	});	
		
});
		
	//dongningbo 酒店集团品牌 start
	function showSelectBrandDialog(){
		//打开下拉列表并且为动态业务字典窗口
		var url = "/vst_admin/biz/bizBrand/findSelectBrandList.do";
	
		brandSelectDialog = new xDialog(url, {}, {
			title : "酒店集团品牌",
			iframe : true,
			width : "600",
			height : "600"
		});
	}

	function showBrandInput() {
		//打开下拉列表并且为动态业务字典窗口
		showSelectBrandDialog();
	}
	function onSelectBrand(params){
		$("#brandId").val(params.brandId);
		$("#brandName").val(params.brandName);
		brandSelectDialog.close();
	}
	//end 
	
	//input_text_select选择业务字典
	function onSelectDict(params){
		$("#propValueHidden" + busiSelectIndex).val(params.dictId);
		$("#propValue" + busiSelectIndex).val(params.dictName);
		dictSelectDialog.close();
		
		var selectObj = $("input[name='prodProductPropListId[" + busiSelectIndex + "].propValue']");
		
		$(selectObj).next().remove();
		if(params.addFlag == 'Y'){
			$(selectObj).after("<input type='text' style='width:120px' data='"+params.dictId+"' alias='prodProductPropList["+busiSelectIndex+"].addValue' remark='remark'>");
		}
	}
	
	function showAddFlagSelect(params,index){
		$(params).next().remove();
		if($(params).find("option:selected").attr('addFlag') == 'Y'){
			$(params).after("<input type='text' style='width:120px' data='"+$(params).val()+"' alias='prodProductPropList["+index+"].addValue' remark='remark'>");
		}
	}
	refreshSensitiveWord($("input[type='text'],textarea"));
	//模糊查询产品经理数据 
	vst_pet_util.superUserSuggest("#managerName", "input[name=managerId]");
	
var dests = [];//子页面选择项对象数组
var count = $("input[name=dest]").size();
var markDest;
var markDestId;

//选择目的地
function onSelectDest(params){
	/* var noRepeatCount = 0;
	$("input[id^=destId]").each(function(index, obj){
	   if(obj.id != null && $("#" + obj.id).val() == params.destId){
		   $.alert("添加目的地重复");
		   return;
	   }else{
		   noRepeatCount ++;
	   }
	  }); */
	if(params!=null){
        markDest.val(params.destName + "[" + params.destType + "]");
        markDestId.val(params.destId);
	}
	destSelectDialog.close();
	$("#destError").hide();
}

//新建目的地
$("#new_button").live("click",function(){
    count++;
	var size = $("input[name=dest]").size()+count;
	$("td[name=addspan]").attr("rowspan",size);
	var $tbody = $(this).parents("tbody");
	$tbody.append("<tr><td><input type='text' class='w35' name='dest' id='dest"+size+"' readonly = 'readonly' required/><input type='hidden' name='prodDestReList["+size+"].destId' id='destId"+size+"'/>&nbsp;<a class='btn btn_cc1' name='del_button' style='display:none'>删除</a></td></tr>");
});

//删除目的地
$("a[name=del_button]").live("click",function(){
	if($(this).parents("tr").attr("name")=="no1"){
		var $td = $(this).parents("tr").children("td:first");
		$(this).parents("tr").next().prepend($td);
		$(this).parents("tr").next().attr("name","no1");
		$(this).parents("tr").next().children("td:last").append("<a class='btn btn_cc1' id='new_button'>添加目的地</a>")
	}
	
	$(this).parents("tr").remove();
	var rows = $("input[name=dest]").size();
	$("td[name=addspan]").attr("rowspan",rows);
});

//打开选择行政区窗口
/*$("input[name=dest]").live("click",function(){
	markDest = $(this);
	markDestId = $(this).next();
	var url = "/vst_admin/biz/dest/selectDestList.do?type=main";
	destSelectDialog = new xDialog(url,{},{title:"选择目的地",iframe:true,width:"1000",height:"600"});
});*/
//董宁波 2016年1月7日 16:53:26 酒店产品数据唯一性验证
function validProductName(obj, productId) {
	var productOldName = $("#productOldName").val();
	var productNewName = $(obj).val();
	if (!productNewName || productOldName == productNewName) {
		//产品数据未改变
		return;
	}
	$.ajax({
		url: '/vst_admin/prod/product/getProdProductByProductName.do',
		type: 'post',
		data: {
			productId: productId,
			productName: productNewName
		},
		dataType: 'json',
		success: function(data) {
			if(data.fail) {
				var product = data.returnContent;
				console.info(product);
				$("#productOldName").val(product.productName);
				$('#productNameTip').html("<div class='error'>提示：您添加的“"+product.productName+"”已经存在，如果要维护此酒店信息请点击下面的链接进入信息维护。</div>");
				$('#productNameTip').append("<div><a href='javascript:void(0);' class='editProd' data="+product.productId+" categoryName="+product.bizCategory.categoryName+" data1="+product.bizCategory.categoryId+" data2="+product.modelVersion+" data3="+product.packageType+">"+product.productName+"</div>");
			} else {
				$('#productNameTip').empty();
			}
		}
	});
	//修改
	$("#productNameTip a.editProd").live("click",function(){
		var productId = $(this).attr("data");
		var categoryId = $(this).attr("data1");
		var categoryName = $(this).attr("categoryName");
		var modelVersion = $(this).attr("data2");
		var packageType=$(this).attr("data3");
		window.top.location.href = "/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName+"&packageType="+packageType;
		return false;
	});
}

function checkCreditCards(params, index) {
    if ($(params).attr('checked') == 'checked') {
        $("#creditCardsNoChecked").attr("checked",false);
    }
}
function checkNoCreditCards(params, index) {
    if ($(params).attr('checked') == 'checked') {
        var StrName = document.getElementsByName("prodProductPropList[" + index + "].propValue");
        $(StrName).each(function () {
            if ($(this).attr('checked') == 'checked') {
                $(this).attr("checked",false);
            }
        });
    }
}
//end
</script>