<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
<#include "/base/findProductInputType.ftl"/>
</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">${bizCategory.categoryName}</a> &gt;</li>
            <li><a href="#">产品维护</a> &gt;</li>
            <li class="active">添加产品</li>
        </ul>
</div>
<div class="iframe_content mt10">
<div class="tiptext tip-warning">
	<span class="tip-icon tip-icon-warning"></span>注：产品创建后，不能变更所属的品类
    <br/><span class="tip-icon tip-icon-warning"></span>注：国内酒店行政区划，必须录入至【区/县】级
</div>
<form action="/vst_admin/prod/product/addProduct.do" method="post" id="dataForm">
		<input type="hidden" name="productId" id="productId" value="${productId!''}">
		<input type="hidden" name="senisitiveFlag" value="N">
		
		<div class="p_box box_info p_line">
            <div class="box_content">
                <table class="e_table form-inline">
                    <tbody>
	                <tr>
	                	<td class="e_label" width="150"><i class="cc1">*</i>所属品类：</td>
	                	<td>
                    		<input type="hidden" id="productOldName" value="" />
	                		<input type="hidden" id="categoryId" name="bizCategoryId" value="${bizCategory.categoryId}" required>
	                		<input type="hidden" id="categoryName" name="bizCategory.categoryName" value="${bizCategory.categoryName}" >
	                		${bizCategory.categoryName}
	                	</td>
	                </tr>
	             <#if bizCategory.categoryId == 1 >
	                <tr>
                        <td class="e_label"><span class="notnull">*</span>类别：</td>
                        <td>
                            <#list productTypeList as list>
                                    <#if list.code == 'FOREIGNLINE' >
                                        <input type="radio" name="productType" value="${list.code!''}"  required />  ${list.cnName!''}
                                    </#if>
                                    <#if list.code='INNERLINE'>
                                        <input type="radio" name="productType" value="${list.code!''}"  required />  ${list.cnName!''}
                                    </#if>
                                </#list>
                            <div id="productTypeError"></div>
                        </td>
                    </tr>
                 </#if>
					<tr>
	                	<td class="e_label"><i class="cc1">*</i>产品名称：</td>
	                    <td><label><input type="text" class="w35" style="width:700px" name="productName" id="productName" <#if bizCategory?? && bizCategory.categoryId==1>onblur="validProductName(this,'${productId!''}')"</#if> required>&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||"</label>
	                    	<div id="productNameTip"></div>
	                   		<div id="productNameError"></div>
	                    </td>
	                    
	                </tr>
	               	<tr>
						<td class="e_label"><i class="cc1">*</i>状态：</td>
						<td>有效
							<#--<select name="cancelFlag" required>-->
								<#--<option value="N">无效</option>-->
		                    	<#--<option value="Y">有效</option>-->
		                    <#--</select>-->
	                   	</td>
	                </tr>
	                <tr>
						<td class="e_label"><i class="cc1">*</i>推荐级别：</td>
						<td>
							<label><select name="recommendLevel" required>
		                    	<option value="5">5</option>
		                    	<option value="4">4</option>
		                    	<option value="3">3</option>
		                    	<option value="2" selected="selected">2</option>
		                    	<option value="1">1</option>
		                    </select>说明：由高到低排列，即数字越高推荐级别越高</label>
	                    </td>
	                </tr>
	                <tr>
	                	<td class="e_label"><i class="cc1">*</i>行政区划：</td>
	                 	 <td>
	                    	<input type="text" class="w35" id="district" readonly = "readonly" required>
	                    	<input type="hidden" name="bizDistrictId" id="districtId" >
                             <div id="bizDistrictAreaErrorMessage" style="display: none;color: red">行政区划必须录入至 “区/县”级</div>
	                    	<div id="bizDistrictIdError"></div>
	                    </td>
	                </tr>
	                 <tr>
	                	<td class="e_label"><i class="cc1">*</i>产品经理：</td>
	                 	 <td>
	                    	<input type="text" class="w35 searchInput" name="managerName" id="managerName" required>
							<input type="hidden" name="managerId" id="managerId" >
							<div id="managerNameError"></div>
	                    </td>
	                </tr>
				<#if bizCategory.categoryId == 1>
	                <tr>
					<td class="e_label"><span class="notnull">*</span>酒店集团品牌：</td>
					<td>
	        			<input type="hidden" id="brandId" name="productBrand.brandId"  value="${prodProduct.productBrand.brandId}" />
	        			<input type="text" id="brandName" class="w35 search" readonly="readonly" required onclick="showBrandInput();" />
					</td>
					</tr>
				</#if>
                	</tbody>
                </table>
            </div>
        </div>


<div class="p_box box_info">
 			<#assign index=0 />
 			<#assign productId="" />
		    <#list bizCatePropGroupList as bizCatePropGroup>
            <#if bizCatePropGroup.bizCategoryPropList?? && (bizCatePropGroup.bizCategoryPropList?size gt 0)>
            <div class="title">
			    <h2 class="f16">${bizCatePropGroup.groupName!''}：</h2>
		    </div>
            <div class="box_content">
            <table class="e_table form-inline">
                <tbody>
                	<#list bizCatePropGroup.bizCategoryPropList as bizCategoryProp>
	                	<tr>
		                <td width="150" class="e_label td_top"><#if bizCategoryProp.nullFlag == 'Y'><i class="cc1">*</i></#if>${bizCategoryProp.propName!''}：</td>
						<#if bizCategoryProp.propCode == "credit_cards">
							<#assign creditCardValue=bizCategoryProp.prodProductPropList[0].propValue />
                        </tr>
                        <tr>
                            <td width="150" class="e_label td_top">
                                <div style="color: red">不支持刷卡</div>

                            </td>
                            <td> <input type="checkbox" id="creditCardsNoChecked"  errorEle="errorEle${index}"
                                        value="" onclick="checkNoCreditCards(this,${index})"/><span>不支持刷卡</span></td>

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
											   <#if bizDict.dictId == '10005'>checked</#if>
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
                                               onclick="checkCreditCards(this,${index});"/><span>${bizDict.dictName?replace("_foreign","")}</span>
									</#if>
								</#list>
                            </td>
                        </tr>
						</#if>

							<td><span class="${bizCategoryProp.inputType!''}" >
	                	
	                		<input type="hidden" name="prodProductPropList[${index}].propId" value="${bizCategoryProp.propId!''}" />
	                		
	                		<!-- 調用通用組件 -->
	                		<@displayHtml productId index bizCategoryProp />
	                		
	                		<div id="errorEle${index}Error" style="display:inline"></div>
	                		<span style="color:grey">${bizCategoryProp.propDesc!''}</span>
	                	</span></td>
		               </tr>
		               <#assign index=index+1 />
                	</#list>
               	</tbody>
                </table>
            </div>
        </div>
        </#if>
		</#list> 
</form>
</div>
<div class="fl operate" style="margin:20px;"><a class="btn btn_cc1" id="save">保存</a><a class="btn btn_cc1" id="saveAndNext">保存并维护下一步</a></div>
<#include "/base/foot.ftl"/>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/kindeditor.js"></script>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/plugins/image/image.js"></script>
<script type="text/javascript" src="/vst_admin/js/contentManage/kindEditorConf.js?v1"></script>
</body>
</html>
<script>
var dictSelectDialog;//标准产品中动态加载中Input_type_select的对话框
var busiSelectIndex;//酒店业务字典

	var districtSelectDialog,contactAddDialog,coordinateSelectDialog;
	
	var dataObj=[],markList=[];
	
	$(".sensitiveVad").each(function(){
		var mark=$(this).attr('mark');
	 	var t = lvmamaEditor.editorCreate('mark',mark);
	 	dataObj.push(t);
	 	markList.push(mark);
	});
	
	 
	$("#save").click(function(){
		for(var i=0;i<dataObj.length;i++){
			var temp = dataObj[i].html();
			$(".sensitiveVad").filter("[mark="+markList[i]+"]").text(temp);
		}
	
		$.each( $("input[autoValue='true']"), function(i, n){
			if($(n).val()==""){
				$(n).val($(n).attr('placeholder'));
			}
		}); 
		
		
		
		$("textarea").not(".ckeditor").each(function(){
			if($(this).text()==""){
				$(this).text($(this).attr('placeholder'));
			}
		});
		
		if(!$("#dataForm").validate({
			rules : {
				productName : {
					isChar : true
				}
					},
			messages : {
				productName : '不可为空或者特殊字符'
				
			}
		}).form()){
					$(this).removeAttr("disabled");
					return false;
		}
		
		 var msg = '确认保存吗 ？';	
		 if(refreshSensitiveWord($("input[type='text'],textarea"))){
		 	$("input[name=senisitiveFlag]").val("Y");
		 	msg = '内容含有敏感词,是否继续?'
		 }else {
	 		 $("input[name=senisitiveFlag]").val("N");
		 }
		 
		 $("#save").hide();
		 $("#saveAndNext").hide();
		 $.confirm(msg,function(){
			//遮罩层
			var loading = top.pandora.loading("正在努力保存中...");		
			$.ajax({
				url : "/vst_admin/prod/product/addProduct.do",
				type : "post",
				dataType : 'json',
				data : $("#dataForm").serialize(),
				success : function(result) {
					loading.close();
					if(result.code == "success"){
						//为子窗口设置productId
						$("input[name='productId']").val(result.attributes.productId);
						//为父窗口设置productId
						$("#productId",window.parent.document).val(result.attributes.productId);
						$("#productName",window.parent.document).val(result.attributes.productName);
						$("#categoryName",window.parent.document).val(result.attributes.categoryName);
						pandora.dialog({wrapClass: "dialog-mini", content:result.message, mask:true,okValue:"确定",ok:function(){
						parent.checkAndJump();
						}});
					}else {
						$.alert(result.message);
						$("#save").show();
						$("#saveAndNext").show();
					}
				},
				error : function(){
					$("#save").show();
					$("#saveAndNext").show();
					loading.close();
				}
			})
		},function(){
			$("#save").show();
			$("#saveAndNext").show();
		});
	});
	 
	$("#saveAndNext").click(function(){
		$.each( $("input[autoValue='true']"), function(i, n){
			if($(n).val()==""){
				$(n).val($(n).attr('placeholder'));
			}
		}); 
		
	 
		$(".ckeditor").each(function(){
			var that = $(this);
			$.each(CKEDITOR.instances, function(i, n){
					if(that.attr('name')==n.name){
		    			if(n.getData()==""){
							that.text(that.attr('placeholder'));
						}else{
							that.text(n.getData());
						}
						if(that.attr("data")=="Y"){
								that.attr("required",true);
								that.show();
						}
		    		}
			});
		});
		$("textarea").not(".ckeditor").each(function(){
			if($(this).text()==""){
				$(this).text($(this).attr('placeholder'));
			}
		});
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
		
		 var msg = '确认保存吗 ？';	
		 if(refreshSensitiveWord($("input[type='text'],textarea"))){
		 	$("input[name=senisitiveFlag]").val("Y");
		 	msg = '内容含有敏感词,是否继续?'
		 }else {
			 		 $("input[name=senisitiveFlag]").val("N");
		 }
		 $("#save").hide();
		 $("#saveAndNext").hide();
		 $.confirm(msg,function(){
			var loading = top.pandora.loading("正在努力保存中...");
			//刷新AddValue的值		
			refreshAddValue();
			//遮罩层
			$.ajax({
				url : "/vst_admin/prod/product/addProduct.do",
				type : "post",
				dataType : 'json',
				data : $("#dataForm").serialize(),
				success : function(result) {
					loading.close();
					if(result.code == "success"){
						//为子窗口设置productId
						$("input[name='productId']").val(result.attributes.productId);
						//为父窗口设置productId
						$("#productId",window.parent.document).val(result.attributes.productId);
						$("#productName",window.parent.document).val(result.attributes.productName);
						$("#categoryName",window.parent.document).val(result.attributes.categoryName);					
						pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
							var categoryId = $("#categoryId").val();
							var productId = result.attributes.productId;
							window.location = "/vst_admin/prod/prodbranch/findProductBranchList.do?productId="+productId+"&categoryId="+categoryId;
						}});
						$(".pg_title", parent.document).html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("input[name='productName']").val()+"   "+"品类:"+$("input[name='categoryName']").val()+"   "+"产品ID："+$("input[name='productId']").val());
					}else {
						$.alert(result.message);
						$("#save").show();
						$("#saveAndNext").show();
					}
				},
				error : function(){
					loading.close();
					$("#save").show();
					$("#saveAndNext").show();
				}
			});
		},function(){
			$("#save").show();
			$("#saveAndNext").show();
		});
	});
	function showAddFlagSelect(params,index){
		if($(params).find("option:selected").attr('addFlag') == 'Y'){
			var StrName = document.getElementsByName("prodProductPropList["+index+"].addValue")
			if($(StrName).size()==0){
				$(params).after("<input type='text' style='width:120px' data='"+$(params).val()+"' alias='prodProductPropList["+index+"].addValue' remark='remark'>");
			}
		}else{
			$(params).next().remove();
		}
	}
    //模糊查询产品经理数据 
	vst_pet_util.superUserSuggest("#managerName", "input[name=managerId]");
	//董宁波 2016年1月7日 16:53:26 酒店产品数据唯一性验证
	function validProductName(obj, productId) {
		var productOldName = $("#productOldName").val();
		var productNewName = $(obj).val();
		if (!productNewName || productOldName == productNewName) {
			//产品数据未改变
			return;
		}
		$("#productOldName").val(productNewName);
		$.ajax({
			url: '/vst_admin/prod/product/getProdProductByProductName.do',
			type: 'post',
			data: {
				productName: productNewName
			},
			dataType: 'json',
			success: function(data) {
				if(data.fail) {
					var product = data.returnContent;
					//$("#productOldName").val(product.productName);
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