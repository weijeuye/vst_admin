<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
<#include "/base/findSubProductInputType.ftl"/>
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
<div class="tiptext tip-warning"><span class="tip-icon tip-icon-warning"></span>注：产品创建后，不能变更所属的品类</div>
<form action="/vst_admin/prod/product/addProduct.do" method="post" id="dataForm">
		<input type="hidden" name="productId" value="${productId!''}">
		<input type="hidden" name="senisitiveFlag" value="N">
		<input type="hidden" id="subCategoryId" name="subCategoryId" value="${subCategoryId}">
		<div class="p_box box_info p_line">
            <div class="box_content">
                <table class="e_table form-inline">
                    <tbody>
	                <tr>
	                	<td class="e_label" width="150"><i class="cc1">*</i>所属品类：</td>
	                	<td>
	                		<input type="hidden" id="categoryId" name="bizCategoryId" value="${bizCategory.categoryId}" required>
	                		<input type="hidden" id="categoryName" name="bizCategory.categoryName" value="${bizCategory.categoryName}" >
	                		${bizCategory.categoryName}
	                	</td>
	                </tr>
					<tr>
	                	<td class="e_label"><i class="cc1">*</i>产品名称：</td>
	                    <td><label><input type="text" class="w35" style="width:700px" name="productName" id="productName" required=true maxlength="100">&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||"</label>
	                   <div id="productNameError"></div>
	                    </td>
	                    
	                </tr>
	                <tr>
                	<td class="e_label"><span class="notnull">*</span>供应商产品名称：</td>
                    <td>
                    	<label><input type="text" class="w35" style="width:700px" name="suppProductName" id="suppProductName" value="<#if prodProduct??>${prodProduct.suppProductName}</#if>" required=true maxlength="100">&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||"</label>
                    	<div id="productNameError"></div>
                    </td>
                </tr>
	              <tr>
						<td class="e_label"><i class="cc1">*</i>状态：</td>
						<td>
							<select  id="cancelFlag" name="cancelFlag" required>
								<option value="N" selected="selected">无效</option>
		                    	<option value="Y" >有效</option>
		                    </select>
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
	                	<td class="e_label"><i class="cc1">*</i>类别：</td>
	                 	 <td>
	                 	 <!-- categoryId=15 跟团游-->
			                <#if bizCategory.categoryId != '15' && bizCategory.categoryId != '42'  >
                  				<#list productTypeList as list>
                  					<#if list.code != 'INNERSHORTLINE' && list.code != 'INNERLONGLINE'>
										<input type="radio" name="productType" value="${list.code!''}" <#if subCategoryId==181&&list.code=='INNERLINE'>checked</#if> required/>  ${list.cnName!''}
                  					</#if>
               	 				</#list>
               	 			</#if>
               	 			<#if bizCategory.categoryId == '15' || bizCategory.categoryId == '42' >
                  				<#list productTypeList as list>
                  					<#if list.code != 'INNERLINE'>
										<input type="radio" name="productType" value="${list.code!''}" required/>  ${list.cnName!''}
									</#if>
               	 				</#list>
               	 			</#if>
			                
	                    	<div id="productTypeError"></div>
	                    </td>
	                </tr>
	                <tr>
	                	<td class="e_label"><i class="cc1">*</i>打包类型：</td>
	                 	 <td>
			                <#if bizCategory.categoryId == '16' || bizCategory.categoryId == '17' >
                 	 			<input type="radio" name="packageType" value="SUPPLIER"  required checked onclick="return false;"/>供应商打包
                 	 		<#else>
                 	 			<#list packageTypeList as list>
                 	 				<input type="radio" name="packageType" value="${list.code!''}"  required />${list.cnName!''}
                 	 			</#list>
                 	 		</#if>
			                
	                    	<div id="packageTypeError"></div>
	                    </td>
	                </tr>
	                <tr>
	                	<td class="e_label"><i class="cc1">*</i>产品经理：</td>
	                 	 <td>
	                    	<input type="text" class="w35 searchInput" name="managerName" id="managerName" required>
							<input type="hidden" name="managerId" id="managerId" >
							 <#if  bizCategory.categoryId == '16' || bizCategory.categoryId == '17' >
                 	 			<span id="tips" style="color:red;">注：该处信息仅供参考，如需修改请至商品基础设置下进行维护</span>
                 	 		<#else>
                 	 			<span id="tips" style="display:none; color:red;">注：该处信息仅供参考，如需修改请至商品基础设置下进行维护</span>
                 	 		</#if>
							<div id="managerNameError"></div>
	                    </td>
	                </tr>
	                <tr>
	                	<td class="e_label"><i class="cc1">*</i>所属分公司：</td>
	                 	 <td>
	                    	<select name="filiale" id="filiale" required>
							  	<#list filiales as filiale>
				                    <option value="${filiale.code}" >${filiale.cnName}</option>
							  	</#list>
						  	</select>
						  	<div id="filialeError"></div>
	                    </td>
	                </tr>
	                
	                <tr id="buTr">
						<td class="e_label"><i class="cc1">*</i>BU：</td>
						<td colspan=2>
				        	<select name="bu" id="bu" required>
			    	 			<option value="">请选择</option>
							<#list buList as list>
			                	<option value=${list.code!''} <#if subCategoryId==181&&list.code=='TICKET_BU'>disabled="disabled"</#if> >${list.cnName!''}</option>
				            </#list>
					    	</select>
		                </td>
		            </tr>
		            
	                <tr id="attributionTr">
						<td class="e_label"><i class="cc1">*</i>归属地：</td>
						<td colspan=2>
							<input type="text" name="attributionName" id="attributionName"   readonly="readonly" required/>
							<input type="hidden" name="attributionId" id="attributionId" />
	                    </td>
	                </tr>
                	</tbody>
                </table>
            </div>
        </div>
        
        <div class="p_box box_info p_line">
             <div class="title">
                 <h2 class="f16">电子合同：</h2>
             </div>
             <div class="box_content">
             <table class="e_table form-inline">
                 <tr>
                        <td width="150" class="e_label td_top">电子合同范本：</td>
                         <td>
                            <select name="prodEcontract.econtractTemplate" id="econtract">
                                <option value="" >自动调取</option>
                                <option value="PREPAYMENTS" >预付款协议</option>
                                <option value="PRESALE_AGREEMENT">旅游产品预售协议</option>
                                <option value="TAIWAN_AGREEMENT">赴台旅游预订须知</option>
                                <option value="DONGGANG_ZHEJIANG_CONTRACT">浙江省赴台旅游合同</option>
                            </select>
                        </td>
                    </tr>
					<tr>
                        <td width="150" class="e_label td_top"><i class="cc1">*</i>组团方式：</td>
                        <td>
                        	<input type="radio" name="prodEcontract.groupType" value="SELF_TOUR" />自行组团&nbsp;
							<input type="radio" name="prodEcontract.groupType" value="COMMISSIONED_TOUR" />委托组团&nbsp;
							<label id="label_groupSupplierName" style="display:none;"><i class="cc1">*</i>被委托组团方:</div>
							<input id="input_groupSupplierName" type="text" name="prodEcontract.groupSupplierName" value="" style="display:none;" />
							
                        </td>
                    </tr>
                    <!--
	                    <tr>
	                    	 <td width="150" class="e_label td_top"><i class="cc1">*</i>合同主体：</td>
	                         <td>
								<select name="companyType" required style="width:250px;">
									<#list companyTypeMap?keys as key>
							  			<option value="${key}"<#if key == "XINGLV" >selected="selected"</#if> >${companyTypeMap[key]}</option>
								  	</#list>
							  	</select>
	                        </td>
	                    </tr>
                    -->
                 </table>
             </div>
        </div>
        
        <!-- 条款品类属性分组Id -->
       	<#assign suggGroupIds = [26,27,28,29,30,31,32,33]/>  
		<div class="p_box box_info p_line">
	 			<#assign index=0 />
	 			<#assign productId="" />
			    <#list bizCatePropGroupList as bizCatePropGroup>
		            <#if (!suggGroupIds?seq_contains(bizCatePropGroup.groupId)) && bizCatePropGroup.bizCategoryPropList?? && (bizCatePropGroup.bizCategoryPropList?size gt 0)>
		            <div class="title">
					    <h2 class="f16">${bizCatePropGroup.groupName!''}：</h2>
				    </div>
		            <div class="box_content">
		            <table class="e_table form-inline">
		                <tbody>
		               		<#list bizCatePropGroup.bizCategoryPropList as bizCategoryProp>
			                	<tr <#if subCategoryId==181&&bizCategoryProp.propId==600> style="display:none;" </#if>>
				                <td width="150" class="e_label td_top"><#if bizCategoryProp.nullFlag == 'Y'><i class="cc1">*</i></#if>${bizCategoryProp.propName!''}：</td>
			                	<td><span class="${bizCategoryProp.inputType!''}">
			                		<input type="hidden" name="prodProductPropList[${index}].propId" value="${bizCategoryProp.propId!''}"/>
			                		<input type="hidden" name="prodProductPropList[${index}].bizCategoryProp.propCode" value="${bizCategoryProp.propCode!''}"/>
			                		<!-- 調用通用組件 -->
			                		<@displayHtml productId index bizCategoryProp />
			                		
			                		<div id="errorEle${index}Error" style="display:inline"></div>
			                		<span style="color:grey">${bizCategoryProp.propDesc!''}</span>
			                	</span></td>
				               </tr>
				               <#assign index=index+1 />
		                	</#list>
		                </table>
		            </div>
		        </#if>
			</#list> 
		</div>
		
		<!-- 插件位置 -->
		<div class="p_box box_info p_line">
			  <div class="box_content">
                <table class="e_table form-inline">
                    <tbody>
                     <#if bizCategory.categoryCode != 'category_route_hotelcomb'>
		                <tr id="districtTr" style="display:none;">
		                	<td class="e_label"><#if bizCategory.categoryId!=16><i id="districtFlag" class="cc1">*</i></#if>出发地：</td>
		                 	 <td>
		                    	<input type="text" class="w35" id="district" name="district" readonly = "readonly" <#if bizCategory.categoryId!=16>required</#if>>
		                    	<input type="hidden" name="bizDistrictId" id="districtId" >
		                    	<div id="districtError"></div>
		                    </td>
		                </tr>
	                </#if>
	                <tr name='no1'>
	                	<td name="addspan" class="e_label"><i class="cc1">*</i>目的地：</td>
	                 	 <td>
	                    	<input type="text" class="w35" id="dest0" name="dest" readonly = "readonly" required>
	                    	<input type="hidden" name="prodDestReList[0].destId" id="destId0" />
	                    	<a class="btn btn_cc1" id="new_button">添加</a>
	                    	<#if subCategoryId!="181">
	                    	<span type="text" id="spanId_0"></span>
	                        </#if>
	                    	<div id="destError"></div>
	                    </td>
	                </tr>
                	</tbody>
                </table>
            </div>
		</div>
		
		<div id="saleType" class="p_box box_info p_line" style="display:none;">
			<table>
				<tr>
				<td width="150" class="e_label td_top"><i class="cc1">*</i>售卖方式：</td>
				<td><span class="INPUT_TYPE_YESNO">
				<td>
					<input id="people" type="radio" name="prodProductSaleReList[0].saleType" value="PEOPLE" checked="checked" ><span>人</span>
					&nbsp;&nbsp;
				    <input id="copies" type="radio" name="prodProductSaleReList[0].saleType" value="COPIES" ><span>份</span>
				    <select id="copiesValue" style="width:100px; display:none;">
				    	<#list copiesList as item>
	                    	<option value="${item.code}">${item.cName}</option>
                    	</#list>
                    </select>
                    <span id="custom" style="display:none;">
                		成人：<input type="text" id="adult" name="prodProductSaleReList[0].adult" style="width:80px;" placeholder="大于等于2"/>
                		儿童：<input type="text" id="child" name="prodProductSaleReList[0].child" style="width:80px;" placeholder="大于等于0"/>
                	</span>
				</td>
			</table>
		</div>
		
		<!-- 子品类属性列表 -->
		<!-- 条款品类属性分组Id -->
       	<#assign suggGroupIds = [37]/>  
		<div class="p_box box_info p_line">	 			
			    <#list subCatePropGroupList as subCatePropGroup>
		            <#if subCatePropGroup.bizCategoryPropList?? && (subCatePropGroup.bizCategoryPropList?size gt 0)>
		            <!-- <div class="title">
					    <h2 class="f16">${subCatePropGroup.groupName!''}：</h2>
				    </div> -->
		            <div class="box_content">
		            <table class="e_table form-inline">
		                <tbody>
		               		<#list subCatePropGroup.bizCategoryPropList as bizCategoryProp>
			                	<tr>
				                <td width="150" class="e_label td_top"><#if bizCategoryProp.nullFlag == 'Y'><i class="cc1">*</i></#if>${bizCategoryProp.propName!''}：</td>
			                	<td><span class="${bizCategoryProp.inputType!''}">
			                		<input type="hidden" name="prodProductPropList[${index}].propId" value="${bizCategoryProp.propId!''}"/>
			                		<input type="hidden" name="prodProductPropList[${index}].bizCategoryProp.propCode" value="${bizCategoryProp.propCode!''}"/>
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
		        </#if>
			</#list> 
		</div>
		
		<div class="p_box box_info p_line">
			<#include "/prod/packageTour/product/showDistributorProd.ftl"/>
		</div>
		</form>
		<div class="p_box box_info p_line" id="reservationLimit">
			<div class="title">
			   <h2 class="f16">预订限制</h2>
			</div>
			<#include "/common/reservationLimit.ftl"/>
		</div>
</div>
<div class="fl operate" style="margin:20px;"><a class="btn btn_cc1" id="save">保存</a><a class="btn btn_cc1" id="saveAndNext">保存并维护下一步</a></div>
<#include "/base/foot.ftl"/>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/kindeditor.js"></script>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/plugins/image/image.js"></script>
<script type="text/javascript" src="/vst_admin/js/contentManage/kindEditorConf.js?v1"></script>
</body>
</html>
<script>

	var dataObj=[],markList=[];

	//页面加载完成后判断类型是否可以被操作
	if("${subCategoryId}"== "181" && $('#bu').val() == "DESTINATION_BU" && $("input:radio[name=productType]:checked").val() == "INNERLINE" && $("input:radio[name=packageType]:checked").val()== "LVMAMA"){
		$("input:checkbox[data=propId_615]").attr("disabled",false);
        $("input:checkbox[data=propId_615]").parent().parent().parent().show();
	}else{
		$("input:checkbox[data=propId_615]").attr("checked",false);
		$("input:checkbox[data=propId_615]").attr("disabled","disabled");
        $("input:checkbox[data=propId_615]").parent().parent().parent().hide();
	}
	//修改产品类别后判断类型是否可以被操作
	$("${subCategoryId}"== "181" &&"input:radio[name=packageType]").live('click',function(){
		if($('#bu').val() == "DESTINATION_BU" && $("input:radio[name=productType]:checked").val() == "INNERLINE" && $("input:radio[name=packageType]:checked").val()== "LVMAMA"){
			$("input:checkbox[data=propId_615]").attr("disabled",false);
            $("input:checkbox[data=propId_615]").parent().parent().parent().show();
		}else{
			$("input:checkbox[data=propId_615]").attr("checked",false);
			$("input:checkbox[data=propId_615]").attr("disabled","disabled");
            $("input:checkbox[data=propId_615]").parent().parent().parent().hide();
		}		
	});
	//修改打包类型后判断类型是否可以被操作
	$("${subCategoryId}"== "181" &&"input:radio[name=productType]").live('click',function(){
		if($('#bu').val() == "DESTINATION_BU" && $("input:radio[name=productType]:checked").val() == "INNERLINE" && $("input:radio[name=packageType]:checked").val()== "LVMAMA"){
			$("input:checkbox[data=propId_615]").attr("disabled",false);
            $("input:checkbox[data=propId_615]").parent().parent().parent().show();
		}else{
			$("input:checkbox[data=propId_615]").attr("checked",false);
			$("input:checkbox[data=propId_615]").attr("disabled","disabled");
            $("input:checkbox[data=propId_615]").parent().parent().parent().hide();
		}		
	});
	//修改bu后判断类型是否可以被操作
	$("${subCategoryId}"== "181" &&'#bu').live('change',function(){
		if($('#bu').val() == "DESTINATION_BU" && $("input:radio[name=productType]:checked").val() == "INNERLINE" && $("input:radio[name=packageType]:checked").val()== "LVMAMA"){
			$("input:checkbox[data=propId_615]").attr("disabled",false);
            $("input:checkbox[data=propId_615]").parent().parent().parent().show();
		}else{
			$("input:checkbox[data=propId_615]").attr("checked",false);
			$("input:checkbox[data=propId_615]").attr("disabled","disabled");
            $("input:checkbox[data=propId_615]").parent().parent().parent().hide();
		}		
	});
	
	//修改类型后弹出提示信息
	$("input:checkbox[data=propId_615]").live("click",function(){
		var $that = this;
		if(this.checked){
			this.checked = false;
			$.confirm("你好，将产品勾选为“"+$(this).attr("data2")+"”系列，需与产品运营部沟通，确认本产品符合“"+$(this).attr("data2")+"”的八项标准，若未经批准擅自勾选，所引起的一切顾客投诉纠纷或赔偿责任由产品经理承担，我们也会定期拉取“"+$(this).attr("data2")+"”产品清单和查询后台操作日志予以监控。",function(){
				$that.checked = true;
			});
			
		}		
	});
	
	
	$('input:radio[name="prodEcontract.groupType"]').click(function(){
		var val = $('input:radio[name="prodEcontract.groupType"]:checked').val();
		if (val == 'SELF_TOUR') {
			$("#label_groupSupplierName").hide();
			$("#input_groupSupplierName").hide();
			$("#input_groupSupplierName").val("");
		} else {
			$("#label_groupSupplierName").show();
			$("#input_groupSupplierName").show();
		}
	});

    //交通按钮切换
    $("input[traffic=traffic_flag]").click(function(){
        var that = $(this);
        if(that.attr("checked")=="checked"){
            if(that.val()=="N"){
                $("#districtTr").hide();
                $("#district").hide();
                $("#district").val(null);
                $("#districtId").val(null);
            }else if(that.val()=="Y"){
                $("#districtTr").show();
                $("#district").show();
            }
        }
    });

	$(".sensitiveVad").each(function(){
		var mark=$(this).attr('mark');
	 	var t = lvmamaEditor.editorCreate('mark',mark);
	 	dataObj.push(t);
	 	markList.push(mark);
	});
	vst_pet_util.superUserSuggest("#managerName", "input[name=managerId]");
	var districtSelectDialog,contactAddDialog,coordinateSelectDialog;
	//目的地窗口
	var destSelectDialog;
	$("#bizVisaDocList").hide();
	$("#buTr").hide();
	$("#attributionTr").hide();
	
	//需要审核的产品,产品状态默认为无效,不能修改
	$("#cancelFlag").attr("disabled","disabled");
	
	//交通按钮切换
	$("input[traffic=traffic_flag]").click(function(){
		if($("input[name='bizCategoryId']").val()!=18){
			return;
		}
		var that = $(this);
		if(that.attr("checked")=="checked"){
			if(that.val()=="N"){
				$("#districtTr").hide();
				$("#district").closest('tr').hide();
				$("#district").val("");
				$("#districtId").val(null);
			}else if(that.val()=="Y"){
				$("#districtTr").show();
                $("#district").closest('tr').show();
			}
		}
	});
	
	 function validateSensitiveVad(){
	        var ret = true;
	        
	        $("textarea.sensitiveVad").each(function(index,element){
	            var required = $(element).attr("required");
	            var str = $(element).text();
	            if(required==="required"&&str.replace("<br />","")===""){
	                alert("请填写完必填项再保存");
	                ret= false;
	            }
	            
	            var len = str.match(/[^ -~]/g) == null ? str.length : str.length + str.match(/[^ -~]/g).length ;
	            var maxLength = $(element).attr("maxLength");
	            if(len>maxLength){
	                alert("超过最大长度"+maxLength);
	                ret= false;
	            }
	        });
	        return ret;
	    }

	
	$("#save").click(function(){
		//非大交通必须选择售卖方式		
		if(!checkSaleTypeOnSave()) {
			return false;
		}
		//检验按份售卖自定义是否填写正确
		if(!checkSaleCopiesParam()) {
			return false;
		}
		
		var distributorChecked = document.getElementById("distributorIds_4").checked;
		if(distributorChecked){
			var distributorUserIds = $("input:checkbox[name='distributorUserIds']:checked").val();
			if(typeof(distributorUserIds) =="undefined"){
				alert("请选择super系统分销商.");
				return;
			}
		}
		for(var i=0;i<dataObj.length;i++){
			var temp = dataObj[i].html();
			$(".sensitiveVad").filter("[mark="+markList[i]+"]").text(temp);
		}
		$.each( $("input[autoValue='true']"), function(i, n){
			if($(n).val()==""){
				$(n).val($(n).attr('placeholder'));
			}
		}); 
		
		$("textarea").each(function(){
			if($(this).text()==""){
				$(this).text($(this).attr('placeholder'));
			}
		});
			
		var econtractGroupTypeVal = $("input:radio[name='prodEcontract.groupType']:checked").val();
		if(typeof(econtractGroupTypeVal) =="undefined"){
			alert("请选择组团方式!");
			return;
		}else if(econtractGroupTypeVal == "COMMISSIONED_TOUR"){
            $("i[for=\"FILIALE\"]").remove();
            var econtractGroupSupplierName = $("#input_groupSupplierName").val();
            if(econtractGroupSupplierName.trim()==""){
                var $combo = $("#input_groupSupplierName");
                $("<i for=\"FILIALE\" class=\"error\">该字段不能为空</i>").insertAfter($combo);
                return;
            }

        }
		
		var flag1;
		var flag2;
		if(!$("#dataForm").validate({
			rules : {
				productName : {
					isChar : true
				},
				suppProductName: {
                    isChar : true
                }
			},
			messages : {
				productName : '不可输入特殊字符',
				suppProductName: '不可输入特殊字符'
			}
		}).form()){
			$(this).removeAttr("disabled");
			flag1 = false;
		}
		
		if(!validateSensitiveVad()){
	           return false;
	       }
		 
		if(!$("#reservationLimitForm").validate().form()){
			flag2 = false;
		}
		if(flag1==false || flag2==false){
			return false;
		}
		
			//刷新AddValue的值
			var comOrderRequiredFlag = "Y";
			if($("#reservationLimitForm").is(":hidden")){
				comOrderRequiredFlag = "N";
			}
			
			refreshAddValue();
			
			var msg = '确认保存吗 ？';	
			 if(refreshSensitiveWord($("input[type='text'],textarea"))){
			 	 $("input[name=senisitiveFlag]").val("Y");
			 	msg = '内容含有敏感词,是否继续?'
			 }else {
				$("input[name=senisitiveFlag]").val("N");
			}
			//$("#save").hide(); 
			//$("#saveAndNext").hide();
			$.confirm(msg,function(){
			
				var trafficFlag = $("input[traffic=traffic_flag]:checked");
				
				var parameter = $("#dataForm").serialize()+"&"+$("#reservationLimitForm").serialize()+"&comOrderRequiredFlag="+comOrderRequiredFlag;
				if($("input[name='bizCategoryId']").val() == 15 || $("input[name='bizCategoryId']").val() == 42){
					parameter += "&"+trafficFlag.attr('name')+"="+trafficFlag.val();
				}
	
				$("#cancelFlag").removeAttr("disabled");
					//遮罩层
		    	var loading = top.pandora.loading("正在努力保存中...");		
				$.ajax({
					url : "/vst_admin/packageTour/prod/product/addProduct.do",
					type : "post",
					dataType : 'json',
					data : parameter,
					success : function(result) {
						loading.close();
						if(result.code == "success"){
							//为子窗口设置productId
							$("input[name='productId']").val(result.attributes.productId);
							//为父窗口设置productId
							$("#productId",window.parent.document).val(result.attributes.productId);
							$("#productName",window.parent.document).val(result.attributes.productName);
							$("#categoryName",window.parent.document).val(result.attributes.categoryName);
							$("#productType",window.parent.document).val(result.attributes.productType);
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
						loading.close();
						$("#save").show();
						$("#saveAndNext").show();
					}
				});
				
			}, function(){
				$("#save").show();
				$("#saveAndNext").show();
			});
			
		 
		
	});
	 
	$("#saveAndNext").click(function(){
		//非大交通必须选择售卖方式		
		if(!checkSaleTypeOnSave()) {
			return false;
		}
		//检验按份售卖自定义是否填写正确
		if(!checkSaleCopiesParam()) {
			return false;
		}
		
		var distributorChecked = document.getElementById("distributorIds_4").checked;
		if(distributorChecked){
			var distributorUserIds = $("input:checkbox[name='distributorUserIds']:checked").val();
			if(typeof(distributorUserIds) =="undefined"){
				alert("请选择super系统分销商.");
				return;
			}
		}
		
		for(var i=0;i<dataObj.length;i++){
			var temp = dataObj[i].html();
			$(".sensitiveVad").filter("[mark="+markList[i]+"]").text(temp);
		}
		$.each( $("input[autoValue='true']"), function(i, n){
			if($(n).val()==""){
				$(n).val($(n).attr('placeholder'));
			}
		}); 
		
		$("textarea").each(function(){
			if($(this).text()==""){
				$(this).text($(this).attr('placeholder'));
			}
		});
			
		var econtractGroupTypeVal = $("input:radio[name='prodEcontract.groupType']:checked").val();
		if(typeof(econtractGroupTypeVal) =="undefined"){
			alert("请选择组团方式!");
			return;
		}
		
		var flag1;
		var flag2;
		if(!$("#dataForm").validate({
			rules : {
                productName : {
                    isChar : true
                },
                suppProductName: {
                    isChar : true
                }
            },
            messages : {
                productName : '不可输入特殊字符',
                suppProductName: '不可输入特殊字符'
            }
		}).form()){
				flag1 = false;
		}
		
		if(!validateSensitiveVad()){
	        return false;
	    }
		
		if(!$("#reservationLimitForm").validate().form()){
			flag2 = false;
		}
		if(flag1==false || flag2==false){
			return false;
		}
		
			var comOrderRequiredFlag = "Y";
			if($("#reservationLimitForm").is(":hidden")){
				comOrderRequiredFlag = "N";
			}
			//刷新AddValue的值		
			refreshAddValue();
			 var msg = '确认保存吗 ？';	
			 if(refreshSensitiveWord($("input[type='text'],textarea"))){
			 	 $("input[name=senisitiveFlag]").val("Y");
			 	msg = '内容含有敏感词,是否继续?'
			 }else {
				$("input[name=senisitiveFlag]").val("N");
			}
			//$("#save").hide(); 
			//$("#saveAndNext").hide();
			$.confirm(msg,function(){
				
				$("#cancelFlag").removeAttr("disabled");
			 	//遮罩层
			 	var loading = top.pandora.loading("正在努力保存中...");
			 	
			 	var trafficFlag = $("input[traffic=traffic_flag]:checked");
			 	var parameter = $("#dataForm").serialize()+"&"+$("#reservationLimitForm").serialize()+"&comOrderRequiredFlag="+comOrderRequiredFlag;
                if($("input[name='bizCategoryId']").val() == 15 || $("input[name='bizCategoryId']").val() == 42){
                    parameter += "&"+trafficFlag.attr('name')+"="+trafficFlag.val();
                }
                
				$.ajax({
					url : "/vst_admin/packageTour/prod/product/addProduct.do",
					type : "post",
					dataType : 'json',
					data : parameter,
					success : function(result) {
						loading.close();
						if(result.code == "success"){
							//为子窗口设置productId
							$("input[name='productId']").val(result.attributes.productId);
							//为父窗口设置productId
							$("#productId",window.parent.document).val(result.attributes.productId);
							$("#productName",window.parent.document).val(result.attributes.productName);
							$("#categoryName",window.parent.document).val(result.attributes.categoryName);
							$("#productType",window.parent.document).val(result.attributes.productType);				
							//更新菜单
							refreshTable();
							pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
								$("#route",parent.document).parent("li").trigger("click");
							}});
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
			 }, function(){
				 $("#save").show();
				 $("#saveAndNext").show();
			 });
		 
		
	});
	
	function refreshTable(){
	//判断打包类型，然后更新父页面菜单
	var packageType = $("input[name=packageType]:checked").val();
	if("SUPPLIER"==packageType){
		$("#lvmama",parent.document).remove();
		$("#supplier",parent.document).show();
	}else if("LVMAMA"==packageType){
		$("#supplier",parent.document).remove();
		$("#lvmama",parent.document).show();
	}else {
		alert("打包类型没有!");
	}
	
	if(packageType=="SUPPLIER"){
			$("#reservationLimit").show();
		}else if(packageType=="LVMAMA"){
			$("#reservationLimit").hide();
	}
	
	//判断是否有大交通
	if($("input[traffic=traffic_flag]:checked").size() > 0 && "SUPPLIER"==packageType){
		var transportType = $("input[traffic=traffic_flag]:checked").val();
		if(transportType == 'Y'){
			$("#transportLi",parent.document).show();
		}else {
			$("#transportLi",parent.document).hide();
		}
	}
	}
	
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
	
	//目的地维护开始
	var dests = [];//子页面选择项对象数组
	var count =0;
	var markDest;
	var markDestId;
	var spanId;
	//选择目的地
	function onSelectDest(params){
		if(params!=null){
			$("#"+markDest).val(params.destName + "[" + params.destType + "]");
			$("#"+markDestId).val(params.destId);
			if(params.parentDest==""){
			$("#"+spanId).html("");
			}else{
			$("#"+spanId).html("上级目的地："+params.parentDest);
			}
		}
		destSelectDialog.close();
		$("#destError").hide();
	}
	
	//新建目的地
	$("#new_button").live("click",function(){
		count++;
		var rows = $("input[name=dest]").size();
		$("td[name=addspan]").attr("rowspan",rows+1);
		var $tbody = $(this).parents("tbody");
		if(${subCategoryId}!=181){
		$tbody.append("<tr><td><input type='text' class='w35' name='dest' id='dest"+count+"' readonly = 'readonly' required/>" + 
						"<input type='hidden' name='prodDestReList["+count+"].destId' id='destId"+count+"'/>&nbsp;" + 
						"<a class='btn btn_cc1' name='del_button'>删除</a>" + 
						"<span type='text' id='spanId_"+count+"'></span></td></tr>"); 
			}else{
			   $tbody.append("<tr><td><input type='text' class='w35' name='dest' id='dest"+count+"' readonly = 'readonly' required/>" + 
						"<input type='hidden' name='prodDestReList["+count+"].destId' id='destId"+count+"'/>&nbsp;" + 
						"<a class='btn btn_cc1' name='del_button'>删除</a></td></tr>");
			}			
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
	$("input[name=dest]").live("click",function(){
		markDest = $(this).attr("id");
		markDestId = $(this).next().attr("id");
		spanId = $(this).next().next().next().attr("id");
		var url = "/vst_admin/biz/dest/selectDestList.do?type=main";
		destSelectDialog = new xDialog(url,{},{title:"选择目的地",iframe:true,width:"1000",height:"600"});
	});
	
	//目的地维护结束
	
	$("input[name=productType]").live("change",function(){
		var addtion=$("input[traffic=traffic_flag]:checked").val();
		if(typeof(addtion) == "undefined" || $("input[name='bizCategoryId']").val() == 15 ||  $("input[name='bizCategoryId']").val() == 42){
			addtion="";
		}
		showRequire($("input[name='bizCategoryId']").val(),$("input[name=productType]:checked").val(),addtion);
		
	});
	
	$("input[traffic=traffic_flag]").live("change",function(){
	//只有自由行的时候才需要判断大交通
		if($("input[name='bizCategoryId']").val()==18 && $("input[name=productType]:checked").val()=="INNERLINE"){
			var addtion=$("input[traffic=traffic_flag]:checked").val();
			showRequire($("input[name='bizCategoryId']").val(),$("input[name=productType]:checked").val(),addtion);
		}
		
	});
	
	//自由行品类属性是否有大交通 选择是必填 选择否 则置灰不维护
	$("input[traffic=traffic_flag]").live("change",function(){
		onChangeTrafficFlag();
	});
	
	 
//组合产品设计人员
$("input[name=packageType]").live("change",function(){
		if($("input[name=packageType]:checked").val()=="LVMAMA"){
			$("#buTr").show();
			$("#attributionTr").show();
			$("#bu").attr("required","true");
			$("#attributionId").attr("required","true");
			
			$("#tips").hide();
		}else{
			$("#buTr").hide();
			$("#attributionTr").hide();
			$("#bu").removeAttr("required");
			$("#attributionId").removeAttr("required");
			
			$("#tips").show();
		}
});

$("input[name=packageType]").click(function(){
		var val = $(this).val();
		if(val=="SUPPLIER"){
			$("#reservationLimit").show();
		}else if(val=="LVMAMA"){
			$("#reservationLimit").hide();
		}
});

var categoryId = $('#categoryId').val();
   
//打开选择归属地窗口
$("input[name=attributionName]").bind("click",function(){
	markDest = $(this).attr("id");
	markDestId = $("#attributionId").attr("id");
	var url = "/vst_admin/biz/attribution/selectAttributionList.do";
	destSelectDialog = new xDialog(url,{},{title:"选择归属地",iframe:true,width:"1000",height:"600"});
});


//跟团游默认是且不能修改
if(categoryId==15 || categoryId == 42){
	var traffic = $("input[traffic=traffic_flag]");
	traffic.val(['Y']);
	traffic.attr('disabled',true);
}

addressShowOrhide($("input[name='packageType']"),$("input[propcode='address']"));

$("input[name='packageType']").change(function(){
   addressShowOrhide($(this),$("input[propcode='address']"));
});

//供应商打包，页面显示地址输入框
function addressShowOrhide(obj,addressObj){
	if(obj.val() != 'SUPPLIER'){
		addressObj.parents("tr").hide();
	}else{
		addressObj.parents("tr").show();
	}
}

$("input[name=productType]").live("change", function(){
	showOrHideSaleType();
});

$("input[name=packageType]").live("change", function(){
	showOrHideSaleType();
});

$("input[traffic=traffic_flag]").live("change", function(){
	showOrHideSaleType();
});

$("input[name='prodProductSaleReList[0].saleType']").click(function(){
	var saleType = $(this).val();
	if(saleType == "PEOPLE") {
		$("#copiesValue").hide();
		$("#custom").hide();
		$("#adult").val("1");
		$("#child").val("0");
	}else if(saleType == "COPIES") {
		$("#copiesValue").show();
		var value = $("#copiesValue").val();
		if($("#copiesValue").val() == "0-0") {
			$("#custom").show();
			$("#adult").val("");
			$("#child").val("");
		}else{
			$("#custom").hide();
			var temp = value.split("-");
			$("#adult").val(temp[0]);
			$("#child").val(temp[1]);	
		}
	}
});

$("#copiesValue").change(function(){
	var value = $(this).val();
	if(value == "0-0") {
		$("#custom").show();
		$("#adult").val("");
		$("#child").val("");
	}else{
		$("#custom").hide();
		var temp = value.split("-");
		$("#adult").val(temp[0]);
		$("#child").val(temp[1]);
	}
});

//后台返回的值(是否是自由行产品)
var showSaleTypeBool = '${showSaleTypeFlag!'NO'}';

/**
* 判断是否满足显示按份售卖的选择按钮
*/
function isShowSaleType() {
	var productTypeRadio = $("input[name=productType]");
	if(productTypeRadio == null || productTypeRadio == 'undefined') {
		return false;
	}
	var productType = $("input[name=productType]:checked").val() == 'INNERLINE';
	var packageType = $("input[name=packageType]:checked").val() == "LVMAMA";
	var tracffic = $("input[traffic=traffic_flag]:checked").val() == 'N';
	
	return 	showSaleTypeBool == "YES" && productType && packageType && tracffic;
}

/**
* 显示或隐藏售卖方式选择
*/
function showOrHideSaleType() {
	if(isShowSaleType()) {
		$("#saleType").show();
	}else {
		$("#saleType").hide();
	}
}

/**
* 提交保存的时候校验售卖方式的选择
*/
function checkSaleTypeOnSave() {
	//国内游、自主打包且非大交通必须选择售卖方式
	if(isShowSaleType() && (saleType == null || saleType == '')) {
		alert("请选择售卖方式!");
		return false;
	}else {
		return true;
	}
}

/**
* 提交保存的时候校验售卖方式自定义的填写
*/
function checkSaleCopiesParam() {
	var saleType = $("input[name='prodProductSaleReList[0].saleType']:checked").val();	
	if(!(isShowSaleType() && saleType == "COPIES")) {
		return true;
	}
	if('0-0' == $("#copiesValue").find("option:selected").val()) {
		if($("#adult").val() == '') {
			alert("请填写成人数!");
			return false;
		}
		if($("#child").val() == '') {
			alert("请填写儿童数!");
			return false;
		}
		var adult = parseInt($("#adult").val());
		var child = parseInt($("#child").val());
		var	reg = /^[0-9]\d*$/;
		if(!(reg.test(adult) && reg.test(child))) {
			alert("成人数和儿童数只能填写大于等于0的整数！");
			return false;
		}
		if(adult < 2  || child < 0) {
			alert("成人/儿童数不能小于最小人数!");
			return false;
		}
	}
	return true;
}

//  --为多出发地添加js start--   //
$(function(){
	
	showExistMuiltStartPintInput();//当页面加载完成时，判断是否显示多出发地按钮
	
	$("input[name='packageType']").live("click",function(){
		showExistMuiltStartPintInput();
	});
	
	$("input[traffic='traffic_flag']").live("click",function(){
		showExistMuiltStartPintInput();
	});
	
	//显示多出发地按钮（条件：1.所属品类自由行或跟团游 2.打包类型为自主打包  3.有大交通的）
	function showExistMuiltStartPintInput() {
	
		var categoryId = $("input[name='bizCategoryId']").val(); //品类id (跟团游->15 自由行->18 当地有->16 定制游 ->42)
		//不对出境做屏蔽
		//var productType = $("input[name='productType']:checked").val(); //类别 (跟团游：(国内短线：'INNERSHORTLINE', 国内长线:'INNERLONGLINE') 非跟团游：(国内：'INNERLINE'),出境：'FOREIGNLINE')
		var packageType = $("input[name='packageType']:checked").val(); //打包类型（自主打包：'LVMAMA',供应商打包：'SUPPLIER'）
		var isTraffic = $("input[traffic='traffic_flag']:checked").val(); //是否为大交通（是:'Y',否：'N'）
	
		if ((categoryId == '15' || categoryId == '18' || categoryId == '42') && packageType =='LVMAMA' && isTraffic == 'Y') {
			var muiltStartPintInput = '<input type="checkbox" id="isMultiStartPoint" name="muiltDpartureFlag" value="N"/><span id="mulitStartPointLabel">是否为多出发地</span>';
	
			if ($("#isMultiStartPoint").length == 0) { // 如果没有改元素
				$("#district").after(muiltStartPintInput);
				districtRequired();//如果为未选中状态，出发地为必填项
			}
		} else {
			if ($("#isMultiStartPoint").length > 0) { // 如果有该元素
				$("#mulitStartPointLabel").remove()
				$("#isMultiStartPoint").remove()
			}

			$("#district").attr("required", "required");
		}
	}
	
	/**
	* 点击是否为多出发地按钮
	*/
	$("#isMultiStartPoint").live("click", function() {
		if ($(this).is(':checked')) {
			districtNotRequired();//如果为选中状态，出发地为非必填项
		} else {
			districtRequired();//如果为未选中状态，出发地为必填项
		}
	});
	
	/**
	* 产品出发地为必填项（情况：没有勾选多出发地时）
	*/
	function districtRequired(){
		$("#isMultiStartPoint").val("N");
		$("#district").attr("required", "required");
		$("#districtFlag").show();
	}
	
	/**
	* 产品出发地为非必填项（情况：勾选多出发地时）
	*/
	function districtNotRequired(){
		$("#isMultiStartPoint").val("Y");
		$("#district").removeAttr("required");
		$("#districtError").empty();
		$("i[for='district']").remove();
		$("#districtFlag").hide();
	}
});
//  --为多出发地添加js end--  //

//  --为EBK&VST跟团游优化添加js start--//
$(function() {
	checkedPackageType();
	
	//判断隐藏预定限制
	hidereservationLimitForm();

	/**
	* 跟团游 打包类型默认选中自主打包（供应商打包走新跟团游录入页面）
	*/
	function checkedPackageType() {
		var categoryId = $("#categoryId").val();
		if (categoryId == '15' || categoryId == '42') {
			$("input[name='packageType'][value='LVMAMA']").trigger("click");
			$("input[name='packageType']").attr("readonly", "readonly").attr("onclick", "return false;");
			//将产品类型radio按钮设置为无效（除供应商打包，防止后台接收不到packageType字段信息）
			$.each($("input[name='packageType']"), function(index, item){
				var packageType = $(item).val();
				if ('LVMAMA' != packageType) {
					$(item).attr("disabled", "disabled");
				}
			});
			$("input[name='packageType'][value='LVMAMA']").trigger("click");
		}
	}
	

	//判断隐藏预定限制
	function hidereservationLimitForm(){
		var addtion=$("input[traffic=traffic_flag]:checked").val();
		if(typeof(addtion) == "undefined" || $("input[name='bizCategoryId']").val() == 15 || $("input[name='bizCategoryId']").val() == 42){
			addtion="";
		}
		showRequire($("input[name='bizCategoryId']").val(),$("input[name=productType]:checked").val(),addtion);

	}
});
//  --为EBK&VST跟团游优化添加js end--  //
</script>