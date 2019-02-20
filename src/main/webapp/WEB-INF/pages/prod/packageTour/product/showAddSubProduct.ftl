<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
<link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/channel/custom/v1/component-chosen.css">
<#include "/base/findSubProductInputType.ftl"/>
<#include "/base/BuGenerator.ftl"/>
<style>
	tr .city {
		background-color:#EEEEEE;
		display:block;
		float:left;
		margin-right:10px;
		margin-bottom:5px;
	}
	tr .cityGroupNamec1 {
		display:block;
		float:left;
		margin-right:10px;
		margin-bottom:5px;
	}
	tr .cityGroupNamec2 {
		display:block;
		float:left;
		margin-right:10px;
		margin-bottom:5px;
	}
	tr .city span:nth-child(1){
		margin:8px;
	}

	tr .city span:nth-child(2){
		margin-right:4px;
		color:red;
		cursor:pointer;
	}

	.day_error{
		color: red;
		margin: 0px;
		padding: 0px;
		display: inline;
	}
    #isMuiltDpartureSpan{
        cursor:pointer;
    }
</style>

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
		<input type="hidden" id="productId" name="productId" value="${productId!''}">
    	<input type="hidden" id="userName" value="${userName}">
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
	                	<td class="e_label"><i class="cc1">*</i>类别：</td>
	                 	 <td>
	                 	 <!-- categoryId=15 跟团游-->
               	 			<#if bizCategory.categoryId == '15' >
                  				<#list productTypeList as list>
                  					<#if list.code != 'INNERLINE'>
										<input type="radio" name="productType" value="${list.code!''}"  required/>  ${list.cnName!''}
									</#if>
               	 				</#list>
               	 			<#elseif bizCategory.categoryId == '18'&& ( subCategoryId=='181'||subCategoryId=='182'||subCategoryId=='183'||subCategoryId=='184') >
               	 				<#list productTypeList as list>
                  					<#if list.code != 'INNERSHORTLINE' && list.code != 'INNERLONGLINE' && list.code != 'INNER_BORDER_LINE'>
                  					   <#if subCategoryId==184&&list.code=='FOREIGNLINE'>
                  					   <#else>
                  					     <input type="radio" name="productType" value="${list.code!''}"   required/>  ${list.cnName!''}
                  					   </#if>
                  					</#if>
               	 				</#list>
               	 				<span class="info-dd-note info-category-note1" >注意：选择产品类别并保存后，不可更改</span>
	                            <span class="info-dd-note info-category-note2">请删除当前产品名称再修改产品类别</span>
               	 			<#else>
               	 				<#list productTypeList as list>
                  					<#if list.code != 'INNERSHORTLINE' && list.code != 'INNERLONGLINE' && list.code != 'INNER_BORDER_LINE'>
										<input type="radio" name="productType" value="${list.code!''}" <#if subCategoryId==181&&list.code=='INNERLINE'>checked</#if> required/>  ${list.cnName!''}
                  					</#if>
               	 				</#list>
               	 			</#if>
	                    	<div id="productTypeError"></div>
	                    </td>
	                </tr>
	               
	               <#if bizCategory.categoryId=='18'&& subCategoryId?exists && subCategoryId == 181>
		               <tr id="trStructName1" style="display:none">
	              		<td class="e_label"><span class="notnull">*</span>产品名称：</td>
		                <td id = "tddestAndDays">
              			<span>目的地+行程:</span>
              			<input type="text" class="w35" id = "destAndDays" style="width:400px" value = "" readonly="readonly" >
	                    	&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||" 
	                	</td>
	                	</tr>
		              	<tr id="trStructName2" style="display:none;">
	              		<td class="e_label"></td>
	              		<td>
	              			<span><span class="cc1">*</span>标题:</span>
		                    <label><input type="text" class="w35" style="width:700px" id="structTitle" name= "jjTitle"value="" required=true maxlength="90"></label>
		                    <input type="hidden" class="JS_hidden_vo_jjTitle" name="prodProductNameVO.jjTitle" value="">
		                    <input type="hidden" class="JS_hidden_vo_jjDestDay" name="prodProductNameVO.jjDestDay" value="">
		                    <div id="structTitleError"></div>
		                </td>
		                </tr>
	               </#if>
	               
					<tr id="trProduct">
	                	<td class="e_label"><i class="cc1">*</i>产品名称：</td>
	                	<#if bizCategory.categoryId == '18'&& ( subCategoryId=='182'||subCategoryId=='183'||subCategoryId=='184') >
		                	<td class="lt-product-name-td">
	                            <a href="javascript:;" class="lt-add-name-btn lt-link-disabled">添加名称</a>
	                            <input type="hidden" class="JS_hidden_main_product_name" id="productName" name="productName" value="" data-validate="true" required>
	                            <div class="JS_hidden_product_name_vo_div">
	                            	<input type="hidden" class="JS_hidden_vo_main_title" name="prodProductNameVO.mainTitle" value="">
	                            	<input type="hidden" class="JS_hidden_vo_sub_title" name="prodProductNameVO.subTitle" value="">
	                            	<input type="hidden" class="JS_hidden_vo_sub_title_4_tnt" name="prodProductNameVO.subTitle4Tnt" value="">
	                            	<input type="hidden" class="JS_hidden_vo_destination" name="prodProductNameVO.destination" value="">
	                            	<input type="hidden" class="JS_hidden_vo_night_number" name="prodProductNameVO.nightNumber" value="">
	                            	<input type="hidden" class="JS_hidden_vo_day_number" name="prodProductNameVO.dayNumber" value="">
	                            	<input type="hidden" class="JS_hidden_vo_play_type" name="prodProductNameVO.playType" value="">
	                            	<input type="hidden" class="JS_hidden_vo_benefit" name="prodProductNameVO.benefit" value="">
	                            	<input type="hidden" class="JS_hidden_vo_theme_content" name="prodProductNameVO.themeContent" value="">
	                            	<input type="hidden" class="JS_hidden_vo_hotel" name="prodProductNameVO.hotel" value="">
	                            	<input type="hidden" class="JS_hidden_vo_main_feature" name="prodProductNameVO.mainFeature" value="">
	                            	<input type="hidden" class="JS_hidden_vo_level_star" name="prodProductNameVO.levelStar" value="">
	                            	<input type="hidden" class="JS_hidden_vo_hotel_or_feature" name="prodProductNameVO.hotelOrFeature" value="">
	                            	<input type="hidden" class="JS_hidden_vo_flight_feature" name="prodProductNameVO.flightFeature" value="">
	                            	<input type="hidden" class="JS_hidden_vo_other_feature" name="prodProductNameVO.otherFeature" value="">
	                            	<input type="hidden" class="JS_hidden_vo_hotel_package" name="prodProductNameVO.hotelPackage" value="">
	                            	<input type="hidden" class="JS_hidden_vo_hotel_feature" name="prodProductNameVO.hotelFeature" value="">
	                            	<input type="hidden" class="JS_hidden_vo_traffic" name="prodProductNameVO.traffic" value="">
	                            	<input type="hidden" class="JS_hidden_vo_large_activity" name="prodProductNameVO.largeActivity" value="">
	                            	
	                            	<input type="hidden" class="JS_hidden_vo_promotion_or_hotel" name="prodProductNameVO.promotionOrHotel" value="">
	                            	<input type="hidden" class="JS_hidden_vo_product_feature" name="prodProductNameVO.productFeature" value="">
	                            	<input type="hidden" class="JS_hidden_vo_product_name" name="prodProductNameVO.productName" value="">
	                            	<input type="hidden" class="JS_hidden_vo_version" name="prodProductNameVO.version" value="">
	                            </div>
	                        </td>
		                <#elseif bizCategory.categoryId == '18'&&subCategoryId=='181'>
		                	<td id="zyxJjGn" class="lt-product-name-td">
		                		<div id="zyxJjGnVal">
			                		<a href="javascript:;" class="lt-add-name-btn lt-link-disabled">添加名称</a>
		                   			<input type="hidden" class="JS_hidden_main_product_name" id="productName" name="productName" value="" data-validate="true" required>
	                   			</div>
	                   			<div class="JS_hidden_product_name_vo_div">
	                            	<input type="hidden" class="JS_hidden_vo_main_title" name="prodProductNameVO.mainTitle" value="">
	                            	<input type="hidden" class="JS_hidden_vo_sub_title" name="prodProductNameVO.subTitle" value="">
	                            	<input type="hidden" class="JS_hidden_vo_destination" name="prodProductNameVO.destination" value="">
	                            	<input type="hidden" class="JS_hidden_vo_night_number" name="prodProductNameVO.nightNumber" value="">
	                            	<input type="hidden" class="JS_hidden_vo_day_number" name="prodProductNameVO.dayNumber" value="">
	                            	<input type="hidden" class="JS_hidden_vo_mainTitleAttr" name="prodProductNameVO.mainTitleAttr" value="">
	                            	<input type="hidden" class="JS_hidden_vo_hotelName" name="prodProductNameVO.hotelName" value="">
	                            	<input type="hidden" class="JS_hidden_vo_hotelAttr" name="prodProductNameVO.hotelAttr" value="">
	                            	<input type="hidden" class="JS_hidden_vo_spotName" name="prodProductNameVO.spotName" value="">
	                            	<input type="hidden" class="JS_hidden_vo_spotAttr" name="prodProductNameVO.spotAttr" value="">
	                            	<input type="hidden" class="JS_hidden_vo_sellAttr" name="prodProductNameVO.sellAttr" value="">
	                            </div>
	                    	</td>
		                	<td id="zyxJjCj" class="lt-product-name-td" style="display:none;" disabled>
	                            <a href="javascript:;" class="lt-add-name-btn lt-link-disabled">添加名称</a>
	                            <input type="hidden" class="JS_hidden_main_product_name" id="productName" name="productName" value="" data-validate="true" required>
	                            <div class="JS_hidden_product_name_vo_div">
	                            	<input type="hidden" class="JS_hidden_vo_main_title" name="prodProductNameVO.mainTitle" value="">
	                            	<input type="hidden" class="JS_hidden_vo_sub_title" name="prodProductNameVO.subTitle" value="">
	                            	<input type="hidden" class="JS_hidden_vo_sub_title_4_tnt" name="prodProductNameVO.subTitle4Tnt" value="">
	                            	<input type="hidden" class="JS_hidden_vo_destination" name="prodProductNameVO.destination" value="">
	                            	<input type="hidden" class="JS_hidden_vo_night_number" name="prodProductNameVO.nightNumber" value="">
	                            	<input type="hidden" class="JS_hidden_vo_day_number" name="prodProductNameVO.dayNumber" value="">
	                            	<input type="hidden" class="JS_hidden_vo_play_type" name="prodProductNameVO.playType" value="">
	                            	<input type="hidden" class="JS_hidden_vo_benefit" name="prodProductNameVO.benefit" value="">
	                            	<input type="hidden" class="JS_hidden_vo_theme_content" name="prodProductNameVO.themeContent" value="">
	                            	<input type="hidden" class="JS_hidden_vo_hotel" name="prodProductNameVO.hotel" value="">
	                            	<input type="hidden" class="JS_hidden_vo_main_feature" name="prodProductNameVO.mainFeature" value="">
	                            	<input type="hidden" class="JS_hidden_vo_level_star" name="prodProductNameVO.levelStar" value="">
	                            	<input type="hidden" class="JS_hidden_vo_hotel_or_feature" name="prodProductNameVO.hotelOrFeature" value="">
	                            	<input type="hidden" class="JS_hidden_vo_flight_feature" name="prodProductNameVO.flightFeature" value="">
	                            	<input type="hidden" class="JS_hidden_vo_other_feature" name="prodProductNameVO.otherFeature" value="">
	                            	<input type="hidden" class="JS_hidden_vo_hotel_package" name="prodProductNameVO.hotelPackage" value="">
	                            	<input type="hidden" class="JS_hidden_vo_hotel_feature" name="prodProductNameVO.hotelFeature" value="">
	                            	<input type="hidden" class="JS_hidden_vo_traffic" name="prodProductNameVO.traffic" value="">
	                            	<input type="hidden" class="JS_hidden_vo_large_activity" name="prodProductNameVO.largeActivity" value="">
	                            	
	                            	<input type="hidden" class="JS_hidden_vo_promotion_or_hotel" name="prodProductNameVO.promotionOrHotel" value="">
	                            	<input type="hidden" class="JS_hidden_vo_product_feature" name="prodProductNameVO.productFeature" value="">
	                            	<input type="hidden" class="JS_hidden_vo_product_name" name="prodProductNameVO.productName" value="">
	                            	<input type="hidden" class="JS_hidden_vo_version" name="prodProductNameVO.version" value="">
	                            </div>
	                        </td>
		                <#else>	
		                    <td><label><input type="text" class="w35" style="width:700px" name="productName" id="productName" required=true maxlength="100">&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||"</label>
	                   			<div id="productNameError"></div>
	                    	</td>
	                    </#if>
	                    
	                </tr>
	                <tr>
                        <td class="e_label" width="150"></td>
                        <td class="lt-product-sub-name-td">
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
                        <td class="e_label" width="150"><i class="cc1">*</i>产品等级：</td>
                        <td>
                            <select name="productGrade">
                                <option  value=""  selected="selected" >无</option>
                                <option value="LVHSH">驴惠实惠</option>
                                <option value="LVYZD">驴悠中端</option>
                                <option value="LVZGD">驴尊高端</option>
                            </select>
                            <span>说明：驴惠实惠：全程入住四星级以下酒店、驴悠中端：全程入住四星级酒店及以上-五星级以下酒店、驴尊高端：全程入住五星级酒店及以上酒店</span>
                        </td>
                    </tr>
	                <tr>
	                	<td class="e_label"><i class="cc1">*</i>打包类型：</td>
	                 	 <td>
			                <#if bizCategory.categoryId == '16' || bizCategory.categoryId == '17'>
                 	 			<input type="radio" name="packageType" value="SUPPLIER"  required checked onclick="return false;"/>供应商打包
                 	 		<#elseif subCategoryId=='184'>
                 	 		    <input type="radio" name="packageType" value="LVMAMA"  required checked onclick="return false;"/>自主打包
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
							<#--
				        	<select name="bu" id="bu" required>
			    	 			<option value="">请选择</option>
							<#list buList as list>
			                	<option value=${list.code!''} <#if subCategoryId==181&&list.code=='TICKET_BU'>disabled="disabled"</#if> >${list.cnName!''}</option>
				            </#list>
					    	</select>-->
					    	<#--http://ipm.lvmama.com/index.php?m=story&f=view&t=html&id=12992-->
					    	<@BuGenerator buList "" bizCategory.categoryId subCategoryId/>
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
							<label id="label_groupSupplierName" style="display:none;"><i class="cc1" id="cc1">*</i>被委托组团方:</div>
							<input id="input_groupSupplierName" type="text" name="prodEcontract.groupSupplierName" value="" style="display:none;"/>
							
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
					     <h2 class="f16"><#if bizCatePropGroup.groupId == 105> <#else>${bizCatePropGroup.groupName!''}：</#if></h2>
				    </div>
		            <div class="box_content">
		            <table class="e_table form-inline">
		                <tbody>
		               		<#list bizCatePropGroup.bizCategoryPropList as bizCategoryProp>
		               		<#if bizCategory.categoryId == '15' || bizCategory.categoryId == '16' || bizCategory.categoryId == '17' || bizCategory.categoryId == '18'>
		               				<#--产品经理推荐-->
		               			<#if bizCategoryProp.propCode=='recommend'>
		               			   <tr>
		               				 <td colspan="2">
                                      <table class="e_table form-inline addOne_tj">
                                        <tbody>
                                           <#list 1..2 as num>
                                              <tr class='lt-tj'>
                                                <td class="e_label" width="150"><#if num_index == 0>产品经理推荐：</#if></td>
                                                <td><input type="text" name="productRecommends"  style="width:400px;" placeholder="输入产品推荐语，每句话最多输入30个汉字" data-validate="true"  maxlength="30"/>
                                                </td>
                                              </tr>
                                           </#list>
                                        <input type="hidden" name="prodProductPropList[${index}].propId" value="${bizCategoryProp.propId!''}"/>
				                		<input type="hidden" name="prodProductPropList[${index}].bizCategoryProp.propCode" value="${bizCategoryProp.propCode!''}"/>
				                		<input type="hidden" id="proRecommendHidden" name="prodProductPropList[${index}].propValue"  value="" />
                                       </tbody>
                                     </table>
                                     <p class="add_one_word"><a class="lt-add-tj-btn" style="margin-left:150px;" href="javascript:;">增加一条</a></p>
                                     <p  style="color:grey;margin-left:150px;">注：最少1到2条，最多3条</p>
                                     </td>
                                    </tr>
		               				<#assign index=index+1 />
		               			<#else>
			               			<#if bizCategoryProp.propCode!='feature'>
			               			<tr <#if subCategoryId==181&&bizCategoryProp.propId==600> style="display:none;" </#if>>
					                <td width="150" class="e_label td_top"><#if bizCategoryProp.nullFlag == 'Y'><i class="cc1">*</i></#if>${bizCategoryProp.propName!''}：</td>
				                	<td><span class="${bizCategoryProp.inputType!''}">
				                		<input type="hidden" name="prodProductPropList[${index}].propId" value="${bizCategoryProp.propId!''}"/>
				                		<input type="hidden" name="prodProductPropList[${index}].bizCategoryProp.propCode" value="${bizCategoryProp.propCode!''}"/>
				                		<!-- 調用通用組件 -->
				                		<@displayHtml productId index bizCategoryProp />
				                		<#if bizCategoryProp.inputType = 'INPUT_TYPE_RICH' && subCategoryId == '181'>
				                		<span id = "traffic_arrive_info" style="display:none">
					                		<span>添加【以上交通信息均通过百度地图查询并供您参考，实际情况可能受天气、拥堵、各类突发情况等影响】</span>
					                		<a href="javascript:void(0);" class="btn btn_cc1" id="new_info">添加</a>
					                		<span id="info_tip"  style="color:red ;display:none"></span>
				                		</span>
				                		</#if>
				                		<div id="errorEle${index}Error" style="display:inline"></div>
				                		<span style="color:grey">${bizCategoryProp.propDesc!''}</span>
				                	</span></td>
					               </tr>
					               <#assign index=index+1 />
					               </#if>
					            </#if>
					           <#else>
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
				               </#if>
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
                                 <input type="hidden" name="multiToStartPointIds" id="multiToStartPointIds" value=""/>
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
            <div style="display:none;" id="prodProductSaleReFangcha">
                <table class="p_box box_info p_line">
                    <tr>
                        <td width="150" class="e_label td_top">房差：</td>
                        <td>
                            <input id="houseDiffType" type="radio" name="prodProductSaleReList[0].houseDiffType" value="NONEED" checked="checked" ><span>不需要设置房差</span>
                        </td>
                        <td>
                            <input id="houseDiffType" type="radio" name="prodProductSaleReList[0].houseDiffType" value="AMOUNT" ><span>固定价格</span>
                            <input id="houseDiffAmount" type="text" name="prodProductSaleReList[0].houseDiffAmountInput"  value="" required="required" number=true min=0 ><span>元</span>
                        </td>
                        <td>
                            <input id="houseDiffType" type="radio" name="prodProductSaleReList[0].houseDiffType" value="PERCENT" ><span>基于酒店销售价的百分比</span>
                            <input id="houseDiffAmount_percent" type="text" name="prodProductSaleReList[0].houseDiffAmountInput" value="" required="required" number=true min=0 ><span>%</span>
                        </td>
                        <input type="hidden" name="prodProductSaleReList[0].houseDiffAmount" value="" />
                    </tr>
                    <tr>
                        <td width="150" class="e_label td_top">儿童价：</td>
                        <td>
                            <input id="childPriceType" type="radio" name="prodProductSaleReList[0].childPriceType" value="NONEED" checked="checked" ><span>不需要设置儿童价</span>
                        </td>
                        <td>
                            <input id="childPriceType" type="radio" name="prodProductSaleReList[0].childPriceType" value="AMOUNT" ><span>固定价格</span>
                            <input id="childPriceAmount" type="text" name="prodProductSaleReList[0].childPriceAmountInput" value="" required="required" number=true min=0 ><span>元</span>
                        </td>
                        <input type="hidden" name="prodProductSaleReList[0].childPriceAmount" value="" />
                    </tr>
                </table>
            </div>
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
		
			<div class="p_box box_info p_line" id="reservationLimit" <#if bizCategory.categoryId == '18'&&  subCategoryId=='184'>style="display:none"</#if>>
				<div class="title">
				   <h2 class="f16">预订限制</h2>
				</div>
				<#include "/common/reservationLimit.ftl"/>
			</div>
		
</div>
<div class="fl operate" style="margin:20px;"><a class="btn btn_cc1" id="save">保存</a><a class="btn btn_cc1" id="saveAndNext">保存并维护下一步</a></div>
<#include "/base/foot.ftl"/>

<!-- 产品名称结构化  css，js start -->

<style type="text/css">
.baseInfo_bg{ width:100%; height:100%; position:fixed; top:0; left:0; background-color: rgba(0, 0, 0, 0.4);filter: progid:DXImageTransform.Microsoft.Gradient(startColorstr=#66000000, endColorstr=#66000000); z-index:20; display:none;}
.lt_dialog{ top:100px; left:50%; margin-left:-450px; width:890px; height:auto; display:none;}
.lt_dialog .input-text{ color:#999999;}
.lt_dialog select{ width:100px;}
.lt_dialog select.teamOrDeep{ width:60px; margin-left:15px;}
.lt_dialog select.teamOrDeep1{ margin-left:0px;}
.lt_dialog .lt-w100{ width:100px;height: 30px;}
.lt_dialog .lt-w400{ width:488px;height: 30px;}
.lt_dialog .lt-w300{ width:358px;height: 30px;}
.lt_dialog .lt-w200{ width:180px;height: 30px;}
.lt_dialog .lt-not-null{ color:#f00;margin-right: 4px;vertical-align: middle;}
.lt_dialog .lt-button{  border:none;  background-color: #4d90fe; border-color: #3f87fe; border-radius: 5px; color: #fff; display: inline-block; font-size: 14px; height: 30px;line-height: 30px; padding: 0 10px; font-family:"Microsoft YaHei"; cursor:pointer; }
.lt_dialog .lt-button:hover,.lt_dialog .lt-button:focus { text-decoration: none; background-color: #2979fe; border-color: #166dfe; color: #ffffff; }
.lt_dialog .lt-mr15-grey{ background:#e6e6e6; border:1px solid #cccccc; color:#333;}
.lt_dialog .lt-mr15-grey:hover{ background:#cccccc; border:1px solid #cccccc; color:#333;}
.input-text-span{ padding-left:53px; padding-right:10px;}
.addName-help-tips{ height:120px; background:#f2f2f2; padding:10px; margin-top:10px;}
.addName-help-tips p.bzts{ width: 60px; color:#333333; font-weight:bold; font-family:"Microsoft YaHei"; float:left; }
.addName-help-tips p.bz-content{ width: 850px; padding-left:10px; float:left;}
.bz-content i.add-blue{ color:#3f87fe;}
.bz-content i.add-red{ color:#ff0000;}
.dialog-body .add-name-view{ font-size:12px; color:#333333; margin-top:10px; margin-bottom:0px;}
.add-name-view b{ font-family:"Microsoft YaHei";}

.fromTo_dialog {width:700px; margin-left:-350px;}
.fromTo_dialog .lt-fromTo-keyword-form { border-bottom: 1px solid #949494;}
.fromTo_dialog .lt-w300 {width: 300px;}
.fromTo_dialog .lt-search-btn { margin-left: 10px;}
.fromTo_dialog .lt-fromTo-content {border-bottom: 1px solid #949494; margin-top: 20px; padding-bottom: 10px; }
.fromTo_dialog .lt-fc-list {float: left; width: 430px; padding-right: 10px; margin-right: 15px; border-right: 1px solid #949494; height: 210px;overflow: hidden;}
.fromTo_dialog .lt-fc-view {float: left; width: 200px; height: 210px; overflow-y:auto;}
.fromTo_dialog .lt-fcv-item {margin-bottom: 0px;}
.fromTo_dialog .lt-fcv-title, .fromTo_dialog .lt-fcl-title {font-size: 14px; font-weight: bold;}
.fromTo_dialog .lt-fcvi-from {font-weight: bold; width: 160px;}
.fromTo_dialog .lt-fcvi-del-btn{color: red; float: right;}
.fromTo_dialog .lt-fromTo-content span { display: inline-block;overflow: hidden;text-overflow: ellipsis;white-space: nowrap;}
.fromTo_dialog .lt-w125 {width: 125px; margin-right: 10px;}
.fromTo_dialog .lt-fcl-item-name { font-weight: bold;}
.fromTo_dialog .lt-fcl-item input { vertical-align: 3px;}
.fromTo_dialog .lt-fcl-content {height: 145px;}
.fromTo_dialog .lt-fcl-pagination {text-align: right;}
.fromTo_dialog .lt-fcl-pagination span { height: 16px;}
.lt-add-name-btn { text-decoration: underline;}
.lt-link-disabled, .lt-link-disabled:hover { color: #9C9999;}
.lt-link-disabled:hover {cursor: default;}
.dialog-content select{ margin-right:6px; height: 40px;}
.lt-w220{ width:220px;}
.dialog .dialog-close{ color:#000; opacity: 0.4; transition: transform 0.5s ease 0.3s;}
.dialog .dialog-close:hover{ color:#f00; background:none; border:none;}
.info-dd-note { color: red; display: none; vertical-align: top;}
.addName_dialog { width: 1000px; margin-left: -500px;}
.addName_dialog .add-cpmc {
    width: 150px;
}
.addName_dialog .add-cpts {
    width: 150px;
}
.addName_dialog .add-category {
    width: 75px;
}
.addName_dialog select.night-count,.addName_dialog select.day-count{ width:60px;}
.lt-pnv-delete, .lt-dnv-delete {color: red;}
.lt-product-name-view{ line-height:30px;}
.add_one_word{ line-height:30px; padding-left:420px;}
.lt-tj-delete-btn {display: inline-block;color: red;margin-left: 5px;}
.lt_dialog .input-red { border-color: red !important;}
.add-name-input {
    padding-left: 10px;
}
.dialog-body .add-name-view {
    font-size: 12px;
    color: #333333;
    margin-top: 10px;
    margin-bottom: 0px;
    padding-left: 10px;
}
.lt_dialog .lt-dialog-confirm,.lt_dialog .lt-dialog-close { padding: 0 20px;}

#trTitle1 #trTitle2 #trTitle3{
	display:none;
}
.add-content-box{ margin-top: 20px;}
.add-content-box .tit{display: block;float: left; margin-right: 10px; width: 110px; height: 20px; text-align: right;}
.add-title-box{float: left; background: #f3f3f3; padding: 20px 20px 20px 60px; width: 740px; position: relative;}
.add-title-box i{position: absolute;
    top: 7px;
    left: -50px;}
.add-title-box .add-row{ margin-bottom: 20px; width: 502px; position: relative;}
.chosen-container-multi .chosen-choices{border:1px solid #abc; padding: 0; width: 500px;}
.chosen-container .chosen-drop{width: 500px; z-index: 9;}
.chosen-container .chosen-results{max-height: 10rem;}
.add-content-box .tips{color: #999}
.inquiry-common-icon {
    background: url(http://pic.lvmama.com/img/channel/custom/v1/inquiry-common.png) no-repeat;
}
.down-icon {
    background-position: -161px -1px;
    display: inline-block;
    width: 10px;
    height: 6px;
    position: absolute;
    right: 10px;
    top: 16px;
    z-index: 5;
}
.on .down-icon {
    background-position: -150px -2px;
}
</style>
<div class="baseInfo_bg" style=""></div>
<#include "/prod/packageTour/product/productNameTemplate.ftl"/>
<script type="text/javascript" src="/vst_admin/js/prod/packageTour/vst-product-name.js"></script>

<!-- 产品名称结构化  css，js end -->

<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/kindeditor.js"></script>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/plugins/image/image.js"></script>
<script type="text/javascript" src="/vst_admin/js/contentManage/kindEditorConf.js?v1"></script>

<script type="text/javascript" src="/vst_admin/js/prod/packageTour/product/autoPackCheck.js"></script>
<script type="text/javascript" src="/vst_admin/js/prod/packageTour/chosen-jquery.js?v1"></script>
<script  type="text/javascript">
$(function(){

	<#if subCategoryId == 181>
	window.SPECIAL_PROCESS_KEY_13 = true;
	</#if>
	
	$(document).ready(function () {
		//初始化
        $("#multiple-hotel").chosen({
			allow_single_deselect: true,
			no_results_text: '没有找到，<a class="no-results-hotel" href="javascript:;">点击立即添加</a>',
			max_selected_options:10,
			placeholder_text_single:'1e',
			width: '100%'
		});
		$("#multiple-spot").chosen({
			allow_single_deselect: true,
			no_results_text: '没有找到，<a class="no-results-spot" href="javascript:;">点击立即添加</a>',
			max_selected_options:10,
			placeholder_text_single:'1e',
			width: '100%'
		});
		$(".search-choice-close").live('click', function() {
            $(this).parents('li').first().remove();
        });
		$(".search-field").bind('input propertychange',function(){
			var search =$(this).find('input').val();
			var $select =$(this).closest(".add-row").find('.form-control-chosen');
			var destType = $select.hasClass("js-from-hotel") ? "HOTEL":"VIEWSPOT";
			if(search == ''){
				return;
			}
			$select.empty();
			var $chosen = $select.data('chosen');
			$.ajax({
				url:'/vst_admin/biz/dest/queryDestPoi.do',
				type:'post',
				dataType:'json',
				data:{destType:destType,search:search},
				success:function(result){
					if(result.code=='success'){
                		var data = result.attributes.dataArray;
	                    $.each(data, function(index,obj){
	                        $select.append('<option>'+obj.destName+'</option>');
	                    });
	                    $chosen.results_update_field();
                	}
				}
			});
		
		});
	});
	

	$(document).on('click','.add-row',function(){
		var This = $(this);
		if(This.hasClass('on')){
			This.removeClass('on')	
		}else{
			This.addClass('on');
		}
	});
	$(document).bind("click",function(e){
        if($(e.target).closest(".add-row").length == 0){
            $('.add-row').addClass('on');
        }
    });

	
	$(document).on('click','.js-view-btn',function(){
		var jsAddMdd = $('.js-add-mdd').val(),
		dayCount= $('.day-count').val(),
		nightCount= $('.night-count').val(),
		addMddNote = $('.add-mdd-note').val(),
		jsFromHotel = $('.js-from-hotel').siblings('.chosen-container').find('.chosen-choices').children('.search-choice'),
		jsFromSpot = $('.js-from-spot').siblings('.chosen-container').find('.chosen-choices').children('.search-choice'),
		hotelAddNote = $('.hotel-add-note').val(),
		jsSaleVal = $('.jd-sale-mdd').val(),
		jsFromHotelText = '',
		jsFromSpotText = '',
		soptAddNote = $('.spot-add-note').val();
		for (var i = 0; i < jsFromHotel.length; i++) {
			jsFromHotelText += jsFromHotel.eq(i).text()+'/'
		};
		if(jsFromSpot.length > 0){
			for (var i = 0; i < jsFromSpot.length; i++) {
				jsFromSpotText += jsFromSpot.eq(i).text()+'/'
			};
			jsFromSpotText = jsFromSpotText.substring(0, jsFromSpotText.length-1);
		}
		if(jsAddMdd == ''){
			$('.js-add-mdd').addClass('input-red');
		}else if( jsFromHotel.length < 1){
			$('.js-from-hotel').siblings('.chosen-container').find('.chosen-choices').addClass('input-red');
		}else{
			$('.js-from-hotel').siblings('.chosen-container').find('.chosen-choices').removeClass('input-red');
			 var content = '';
                content += jsAddMdd+dayCount+'天'+nightCount+'晚';
                if(addMddNote != ''){
                    content += addMddNote;
                }
                
                jsFromHotelText = jsFromHotelText.substring(0, jsFromHotelText.length-1);
                content += jsFromHotelText;
                if(hotelAddNote != ''){
                    content +=  hotelAddNote;
                }
                if(jsFromSpotText!=null &&jsFromSpotText!=''){
                    content += '+'+ jsFromSpotText;
                }
                if(soptAddNote != ''){
                    content += soptAddNote;
                }
                if(jsSaleVal != ''){
                    content += '+'+ jsSaleVal;
                }
                $('.add-name-content').html(content);
		}
	})
	$(document).on('click','.js-dialog-confirm',function(){
		 var illegalReg = /^[^\\\*\&\#\$\%\@\\^\!\~\+>\<\|\'\"\/]+$/;
		var jsAddMdd = $('.js-add-mdd').val(),
		dayCount= $('.day-count').val(),
		nightCount= $('.night-count').val(),
		addMddNote = $('.add-mdd-note').val(),
		jsFromHotel = $('.js-from-hotel').siblings('.chosen-container').find('.chosen-choices').children('.search-choice'),
		jsFromSpot = $('.js-from-spot').siblings('.chosen-container').find('.chosen-choices').children('.search-choice'),
		hotelAddNote = $('.hotel-add-note').val(),
		jsSaleVal = $('.jd-sale-mdd').val(),
		jsFromHotelText = '',
		jsFromSpotText = '',
		soptAddNote = $('.spot-add-note').val();
		if(jsFromHotel.length >10){
			alert("酒店最多添加10个");
			return false;
		}
		for (var i = 0; i < jsFromHotel.length; i++) {
			jsFromHotelText += jsFromHotel.eq(i).text()+'/'
		};
		if(jsFromHotelText!=null &&jsFromHotelText!=''){
			jsFromHotelText = jsFromHotelText.substring(0, jsFromHotelText.length-1);
			
		}
		if(jsFromSpot.length > 0){
			if(jsFromSpot.length >10){
			alert("景点最多添加10个");
				return false;
			}
			for (var i = 0; i < jsFromSpot.length; i++) {
				jsFromSpotText += jsFromSpot.eq(i).text()+'/'
			};
			jsFromSpotText = jsFromSpotText.substring(0, jsFromSpotText.length-1);
			
		}
		if(jsAddMdd == ''||!illegalReg.test(jsAddMdd)){
			$('.js-add-mdd').addClass('input-red');
		}else if( jsFromHotel.length < 1){
			$('.js-from-hotel').siblings('.chosen-container').find('.chosen-choices').addClass('input-red');
		}else{
			$('.js-from-hotel').siblings('.chosen-container').find('.chosen-choices').removeClass('input-red');
			var mainTitle =jsAddMdd+dayCount+'天'+nightCount+'晚';
			if(addMddNote!=''){
				if(!illegalReg.test(addMddNote)){
					$('.add-mdd-note').addClass('input-red');
					return;
				}else{
					$('.add-mdd-note').removeClass('input-red');
					mainTitle +=addMddNote;
				}
			}
			var content =jsFromHotelText;
			if(hotelAddNote!=''){
				if(!illegalReg.test(hotelAddNote)){
					$('.hotel-add-note').addClass('input-red');
					return ;
				}else{
					$('.hotel-add-note').removeClass('input-red');
					content +=hotelAddNote;
				}
			}
			if(jsFromSpotText!=''){
				content +="+"+jsFromSpotText;
			}
			if(soptAddNote!=''){
				if(!illegalReg.test(soptAddNote)){
					$('.spot-add-note').addClass('input-red');
					return ;
				}else{
					$('.spot-add-note').removeClass('input-red');
					content +=soptAddNote;
				}
			}
			if(jsSaleVal!=''){
				if(!illegalReg.test(jsSaleVal)){
					$('.jd-sale-mdd').addClass('input-red');
					return ;
				}else{
					$('.jd-sale-mdd').removeClass('input-red');
					content +="+"+jsSaleVal;
				}
			}
			$('#zyxJjGn').find(".JS_hidden_vo_main_title").val(mainTitle);
			$('#zyxJjGn').find(".JS_hidden_vo_sub_title").val(content);
			var name =mainTitle+content;
			<#if subCategoryId == 181>
			var	maxNameLength = 70;
			<#else>
			var maxNameLength = 200;
			</#if>
			
			if(name.length>maxNameLength){
				alert("产品名称长度不能超过"+maxNameLength)
				return false;
			}
			$('#zyxJjGnVal').html('主标题：'+mainTitle+'</br>'+'副标题：'+content+'<a href="javascript:;" class="js-pnv-modify">修改</a><input type="hidden" class="JS_hidden_main_product_name" id="productName" name="productName" value="" data-validate="true" required>');
			
			$('#zyxJjGnVal').find(".JS_hidden_main_product_name").val(name);
			$('#zyxJjGn').find(".JS_hidden_vo_destination").val(jsAddMdd);
			$('#zyxJjGn').find(".JS_hidden_vo_day_number").val(dayCount);
			$('#zyxJjGn').find(".JS_hidden_vo_night_number").val(nightCount);
			$('#zyxJjGn').find(".JS_hidden_vo_mainTitleAttr").val(addMddNote);
			$('#zyxJjGn').find(".JS_hidden_vo_hotelAttr").val(hotelAddNote);
			$('#zyxJjGn').find(".JS_hidden_vo_spotAttr").val(soptAddNote);
			$('#zyxJjGn').find(".JS_hidden_vo_sellAttr").val(jsSaleVal);
			$('#zyxJjGn').find(".JS_hidden_vo_hotelName").val(jsFromHotelText);
			$('#zyxJjGn').find(".JS_hidden_vo_spotName").val(jsFromSpotText);
			$('.lt-dialog-close').click();
			
		}
	})
	$(document).on('click','.js-pnv-modify',function(){
		var $dialog = $('.INNERLINE');
		var $jsFromHotel = $dialog.find('.js-from-hotel').siblings('.chosen-container').find('.chosen-choices').find('.search-field');
        var $jsFromSpot = $dialog.find('.js-from-spot').siblings('.chosen-container').find('.chosen-choices').find('.search-field');
        $jsFromHotel.closest(".chosen-choices").find(".search-choice").remove();
        $jsFromSpot.closest(".chosen-choices").find(".search-choice").remove();
        var jsFromHotel=$(".JS_hidden_product_name_vo_div").find(".JS_hidden_vo_hotelName").val();
        var jsFromSpot =$(".JS_hidden_product_name_vo_div").find(".JS_hidden_vo_spotName").val();
        if(jsFromHotel!=null){
        	var arr = jsFromHotel.split('/');
        	$.each( arr, function(index,obj){
	        	if(obj!=''){
	        		 $jsFromHotel.before("<li class='search-choice'><span>"+obj+"</span>"
                                +"<a class='search-choice-close' data-option-array-index='"+index+"'></a>"+"</li>");
             }
            });
        	
        }
        if(jsFromSpot!=null){
        	var arr = jsFromSpot.split('/');
        	$.each( arr, function(index,obj){
	        	if(obj!=''){
	        		 $jsFromSpot.before("<li class='search-choice'><span>"+obj+"</span>"
                                +"<a class='search-choice-close' data-option-array-index='"+index+"'></a>"+"</li>");
             }
 	       });
        	
        }
		$('.INNERLINE').show();
		$('.INNERLINE').find('.dialog-header').text('修改国内产品名称');
	})
	
	$(document).on('click','.no-results-hotel',function(){
		var This = $(this),
			ThisText = This.siblings().text();
		$('.js-from-hotel').append('<option>'+ThisText+'</option>')
		$("#multiple-hotel").trigger("chosen:updated");
		$(".js-from-hotel").siblings("div.chosen-container").find("ul.chosen-results").find("li.active-result").last().trigger("mouseup");
	})
	$(document).on('click','.no-results-spot',function(){
		var This = $(this),
			ThisText = This.siblings().text();
		$('.js-from-spot').append('<option>'+ThisText+'</option>')
		$("#multiple-spot").trigger("chosen:updated");
		$(".js-from-spot").siblings("div.chosen-container").find("ul.chosen-results").find("li.active-result").last().trigger("mouseup");
	})
	
})

</script>
</body>
</html>
<script>

	var dataObj=[],markList=[];

	$(function(){
		var packageType = $("input[name=packageType]:checked").val();	
		if("SUPPLIER"==packageType){
			$("#cc1").hide();
			$("#input_groupSupplierName").attr("readonly","readonly");
		}
        hideGroupSettleFlag();
	});
	
	$("input:radio[name='productType']").live("change",function(){
	   if($("input:radio[name='productType']:checked").val() == "FOREIGNLINE"){
	      $("select[name='productGrade']").val("");
	      $("select[name='productGrade']").attr("disabled","disabled");
           showGroupSettleFlag();
	      if("${subCategoryId}"== "182" || "${subCategoryId}"== "183" || "${subCategoryId}"== "184"){
	         $("#mulitStartPointLabel").text("是否为多出发地");
	      }
	    //  if("${subCategoryId}"== "181"){
	   //   	$("#structTitle").val("");
		//	$("#trStructName1").hide();
		//	$("#trStructName2").hide();
	    //  }
	   }else{
           hideGroupSettleFlag();
	      $("select[name='productGrade']").removeAttr("disabled");
	      if("${subCategoryId}"== "182" || "${subCategoryId}"== "183"){
	         $("#mulitStartPointLabel").text('是否为多出发地    (提示：若勾选是否为多出发，则必须在“选择交通”模块中打包交通产品)');
	      }
	      
	      if("${subCategoryId}"== "181"){
	      	if($("input[name=packageType]:checked").val() == "LVMAMA" && $("#bu").val() == "DESTINATION_BU" ){
	      	//	$("#trStructName1").show();
			//	$("#trStructName2").show();
			//	$("#trProduct").hide();
			//	$("#structTitle").val($("#productName").val());
	      	}else{
	      		$("#trProduct").show();
	      	}
	      
	      }
	      
	      //巴士+酒  国内 是否有大交通'否'不可选  并选中'是'
         if("${subCategoryId}"== "184"){
              var trafficFlags=$("input[traffic=traffic_flag]");
              if(trafficFlags[0].value=='Y'){
                  trafficFlags[0].setAttribute("checked","checked"); 
              }else if(trafficFlags[1].value=='Y'){
                  trafficFlags[1].setAttribute("checked","checked"); 
              }
               $("input[traffic=traffic_flag]:checked").click();
              
              if(trafficFlags[0].value=='N'){
                  trafficFlags[0].setAttribute("disabled","disabled");
              }else if(trafficFlags[1].value=='N'){
                  trafficFlags[1].setAttribute("disabled","disabled"); 
              }
         }
	   }
	});
	
	$(document).ready(function(){
	  $("input:checkbox[data2='逍遥驴行']").hide();
	  $("input:checkbox[data2='逍遥驴行']").next().hide();
	});
	
	//页面加载完成后判断类型是否可以被操作
	if("${subCategoryId}"== "181" || "${subCategoryId}"== "182" || "${subCategoryId}"== "183"|| "${subCategoryId}"== "184"){
		$("input:checkbox[data=propId_615]").attr("disabled",false);
        $("input:checkbox[data=propId_615]").parent().parent().parent().show();
	}else{
		$("input:checkbox[data=propId_615]").attr("checked",false);
		$("input:checkbox[data=propId_615]").attr("disabled","disabled");
        $("input:checkbox[data=propId_615]").parent().parent().parent().hide();
	}
	
	/*
	if("${bizCategory.categoryId}"== "18" && "${subCategoryId}"== "181"){
		$("#trTitle1").hide();
		$("#trTitle2").hide();
		$("#trTitle3").hide();
		$("#trProduct").show();
	}
	*/
	
	$("input[name=productType]").live("change",function(){

		if($("input[name=productType]:checked").val()=="INNERLINE"){
//			if($("input[name=packageType]:checked").val()!="SUPPLIER"){
//				//$("#trType").show();
//				if($("input[name=productOrigin]:checked").val()==""){
//					$("#trTitle1").show();
//					$("#trTitle2").show();
//					$("#trTitle3").show();
//					$("input[name='productName']").val("");
//					$("#trProduct").hide();
//				}
//			}else{
//				//$("#trType").show();
//			}
			if($("#bu").val() == "DESTINATION_BU" && $("input[name=packageType]:checked").val() == "LVMAMA"){
			    $("input:checkbox[data2='逍遥驴行']").show();
			    $("input:checkbox[data2='逍遥驴行']").next().show();
			}
			$("#traffic_arrive_info").show();
			
		}else{
			$("#trType").hide();
			$("input[name='promTitle']").val("");
			$("input[name='mainTitle']").val("");
			$("input[name='subTitle']").val("");
//			$("#trTitle1").hide();
//			$("#trTitle2").hide();
//			$("#trTitle3").hide();
			$("#trProduct").show();
			$("input:checkbox[data2='逍遥驴行']").removeAttr("checked");
			$("input:checkbox[data2='逍遥驴行']").hide();
			$("input:checkbox[data2='逍遥驴行']").next().hide();
			$("#traffic_arrive_info").hide();
		}
		if($("input[name=productType]:checked").val()=="FOREIGNLINE"){
            showGroupSettleFlag();
		}else{
            hideGroupSettleFlag();
		}
	});
	
	$("#bu").change(function(){
		if($("#bu").val()!="DESTINATION_BU"){
		    $("input:checkbox[data2='逍遥驴行']").removeAttr("checked");
			$("input:checkbox[data2='逍遥驴行']").hide();
			$("input:checkbox[data2='逍遥驴行']").next().hide();
		//	$("#destAndDays").val("");
		//	$("#structTitle").val("");
		//	$("#trStructName1").hide();
		//	$("#trStructName2").hide();
			$("#trProduct").show();
	    }else{
			if($("input[name=productType]:checked").val()=="INNERLINE"){
				$("input:checkbox[data2='逍遥驴行']").show();
			    $("input:checkbox[data2='逍遥驴行']").next().show();
				if("${bizCategory.categoryId}"== "18" && "${subCategoryId}"== "181"){
		//		   $("#trProduct").hide();
		//		   $("#trStructName1").show();
		//		   $("#trStructName2").show();
		//		   $("#structTitle").val($("#productName").val());
				}
			}
		}
	})
	
	/*
	if("${bizCategory.categoryId}"== "18" && "${subCategoryId}"== "181"){
		
		
		$("#bu").change(function(){
			if($("#bu").val()!="DESTINATION_BU"){
				$("input[name='promTitle']").val("");
				$("input[name='mainTitle']").val("");
				$("input[name='subTitle']").val("");
//				$("#trTitle1").hide();
//				$("#trTitle2").hide();
//				$("#trTitle3").hide();
				$("#trProduct").show();
				$("input:checkbox[data2='逍遥驴行']").removeAttr("checked");
			    $("input:checkbox[data2='逍遥驴行']").hide();
			    $("input:checkbox[data2='逍遥驴行']").next().hide();
			}else{
//				$("#trTitle1").show();
//				$("#trTitle2").show();
//				$("#trTitle3").show();
				$("input[name='productName']").val("");
//				$("#trProduct").hide();
				if($("input[name=productType]:checked").val()=="INNERLINE"){
				    $("input:checkbox[data2='逍遥驴行']").show();
			        $("input:checkbox[data2='逍遥驴行']").next().show();
				}
			}
		})
	}*/
	
	
	//修改类型后弹出提示信息
	$("input:checkbox[data=propId_615]").live("click",function(){
		var $that = this;
		if(this.checked){
			this.checked = false;
			$.confirm("你好，将产品勾选为“"+$(this).attr("data2")+"”系列，需与产品运营部沟通，确认本产品符合“"+$(this).attr("data2")+"”的八项标准，若未经批准擅自勾选，所引起的一切顾客投诉纠纷或赔偿责任由产品经理承担，我们也会定期拉取“"+$(this).attr("data2")+"”产品清单和查询后台操作日志予以监控。",function(){
				$that.checked = true;
				if($($that).attr('data2') == '驴色飞扬自驾'){
					showSaleReFangcha();
				}
				if($($that).attr('data2') == '开心驴行'){
				   $("input:checkbox[data2='逍遥驴行']").removeAttr("checked");
				}
				if($($that).attr('data2') == '逍遥驴行'){
				   $("input:checkbox[data2='开心驴行']").removeAttr("checked");
				}
			});
			
		}
		if($($that).attr('data2') == '驴色飞扬自驾'){
			showSaleReFangcha();
		}		
	});
	
	$("#promGeneration").click(function(){
  		$.alert("此功能暂未开放.");
  		var $promAdd = $("#promAdd");
		var add_tj = "<label><input type='text' class='w35' style='width:700px' name=\"promTitle\" id=\"promTitle\" value=\"${promTitle!''}\"  maxlength='10' disabled></label>";
  		var $addProm = $(add_tj);
  		if(!document.getElementById("promTitle")){
  			$promAdd.append($addProm);
  		}
  	});
  
	  $("#mainGeneration").click(function(){
	  		$.alert("请打包商品后再生成主标题.");
	  		var $mainAdd = $("#mainAdd");

 			var add_main = "<label><input type='text' class='w35' style='width:700px' name=\"mainTitle\" id=\"mainTitle\" value=\"${mainTitle!''}\"  maxlength='70'></label>";
  			var $addMain = $(add_main);
  			if(!document.getElementById("mainTitle")){
  				$mainAdd.append($addMain);
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
		
		var packageType = $("input[name=packageType]:checked").val();
		if("SUPPLIER"==packageType){
			$("#cc1").hide();
			$("#input_groupSupplierName").attr("readonly","readonly");
		}else{
			$("#cc1").show();
			$("#input_groupSupplierName").removeAttr("readonly");
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
                var this_package = $("input[name=packageType]:checked").val();
                if(this_package != undefined){
					if(this_package == "LVMAMA"){
						$("input[value=pack_traffic_flag]").parent().parent().parent().hide();
						try{
							$("input[value=pack_traffic_flag]").parent().find("input[type=radio]:checked").removeAttr("checked");
						}catch(e){
							
						}
					}
                }else{	
                	$("input[value=pack_traffic_flag]").parent().parent().parent().hide();
                	try{
						$("input[value=pack_traffic_flag]").parent().find("input[type=radio]:checked").removeAttr("checked");
					}catch(e){
							
					}
                }
            }else if(that.val()=="Y"){
                $("#districtTr").show();
                $("#district").show();
                var this_package = $("input[name=packageType]:checked").val();
                if(this_package != undefined){
					if(this_package == "LVMAMA"){
						$("input[value=pack_traffic_flag]").parent().parent().parent().show();
					}
                }else{
                	$("input[value=pack_traffic_flag]").parent().parent().parent().show();
                }
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
	if("${subCategoryId}"!= "184"){
	   $("#buTr").hide();
	   $("#attributionTr").hide();
	}
	
	
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
		resetDistrictRequiredStatus();
		getProductRecommends();

		//景酒 校验‘交通到达’是否添加提示
		if("${bizCategory.categoryId}"== "18" && "${subCategoryId}"== "181"  && $("input[name=productType]:checked").val()=="INNERLINE" ){
			if(!checkTrafficArrive()) {
				return false;
			}
		}

		//非大交通必须选择售卖方式		
		if(!checkSaleTypeOnSave()) {
			return false;
		}
		//检验按份售卖自定义是否填写正确
		if(!checkSaleCopiesParam()) {
			return false;
		}

        //检查被打包产品的信息
        if(!checkPackedProduct()){
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
			var packageType = $("input[name=packageType]:checked").val();	
			if("LVMAMA"==packageType){
	            $("i[for=\"FILIALE\"]").remove();
		            var econtractGroupSupplierName = $("#input_groupSupplierName").val();
		            if(econtractGroupSupplierName.trim()==""){
		               var $combo = $("#input_groupSupplierName");
		               $("<i for=\"FILIALE\" class=\"error\">该字段不能为空</i>").insertAfter($combo);
		               return;
	            	}
			}
        }
        
        
        //productNameVal是原先界面做必填验证，productNameValNew用于验证结构化
        var productNameVal = $("#productName").val();
        var productNameValNew = $(".JS_hidden_main_product_name").val();
        
        if("${bizCategory.categoryId}"== "18" && "${subCategoryId}"== "181" && $("input[name=productType]:checked").val()=="INNERLINE" && $("input[name=packageType]:checked").val()=="LVMAMA"){
        	
        	if((typeof(productNameVal) =="undefined"||productNameVal=="")&&(typeof(productNameValNew) =="undefined"||productNameValNew=="")){
        		alert('请填写产品名称！');
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
                },
                jjTitle:{
                	isChar : true
                }
			},
			messages : {
				productName : '不可输入特殊字符',
				suppProductName: '不可输入特殊字符',
				jjTitle:'不可输入特殊字符'
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
				if($("input[name='bizCategoryId']").val() == 15){
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
							$("#packageType",window.parent.document).val(result.attributes.packageType);				
							pandora.dialog({wrapClass: "dialog-mini", content:result.message, mask:true,okValue:"确定",ok:function(){
							parent.checkAndJump();
							parent.refreshProdFundLabel();
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
		resetDistrictRequiredStatus();
		getProductRecommends();
		//非大交通必须选择售卖方式		
		if(!checkSaleTypeOnSave()) {
			return false;
		}
		//检验按份售卖自定义是否填写正确
		if(!checkSaleCopiesParam()) {
			return false;
		}

        //检查被打包产品的信息
        if(!checkPackedProduct()){
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
		
		var promTitle = $("input[name='promTitle']").val();
		if(typeof(promTitle) =="undefined"){
            	promTitle = "";
            }
        var mainTitle = $("input[name='mainTitle']").val();
        if(typeof(mainTitle) =="undefined"){
            	mainTitle = "";
            }
        var subTitle = $("input[name='subTitle']").val();  
        
        var packTitle = promTitle + "#"+ mainTitle + "#" + subTitle;
        var title = encodeURI(packTitle).replace(/\+/g, '%2B');
		
			var productNameVal = $("#productName").val();
			var productNameValNew = $(".JS_hidden_main_product_name").val();
	        if((typeof(productNameVal) =="undefined"||productNameVal=="")&&(typeof(productNameValNew) =="undefined"||productNameValNew=="")){
	        	alert('请填写产品名称！');
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
                },
                jjTitle:{
                	isChar : true
                }
            },
            messages : {
                productName : '不可输入特殊字符',
                suppProductName: '不可输入特殊字符',
                jjTitle:'不可输入特殊字符'
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
                if($("input[name='bizCategoryId']").val() == 15){
                    parameter += "&"+trafficFlag.attr('name')+"="+trafficFlag.val();
                }
                
                if("${bizCategory.categoryId}"== "18" && "${subCategoryId}"== "181"  && $("input[name=productType]:checked").val()=="INNERLINE" && $("input[name=packageType]:checked").val()=="LVMAMA"){
					parameter += "&packTitle="+title;
            		//$("#productName1").val(title);
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
							$("#packageType",window.parent.document).val(result.attributes.packageType);
										
							//更新菜单
							refreshTable();
							parent.refreshProdFundLabel();
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


	$("#bu").live("change", function(){
        showSaleReFangcha();
	});

    $("input[name='prodProductSaleReList[0].houseDiffType']").live("change", function(){
        var houseDiffType = $("input[name='prodProductSaleReList[0].houseDiffType']:checked").val();
        if("NONEED"==houseDiffType){
            $("#houseDiffAmount").attr("disabled","disabled");
            $("#houseDiffAmount_percent").attr("disabled","disabled");
        }else if ("AMOUNT"==houseDiffType){
            $("#houseDiffAmount_percent").attr("disabled","disabled");
            $("#houseDiffAmount").removeAttr("disabled");
        }else if ("PERCENT"==houseDiffType){
            $("#houseDiffAmount").attr("disabled","disabled");
            $("#houseDiffAmount_percent").removeAttr("disabled");
        }
    });

    $("input[name='prodProductSaleReList[0].childPriceType']").live("change", function(){
        var childPriceType = $("input:[name='prodProductSaleReList[0].childPriceType']:checked").val();
        if("NONEED"==childPriceType){
            $("#childPriceAmount").attr("disabled","disabled");
        }else if("AMOUNT"==childPriceType){
            $("#childPriceAmount").removeAttr("disabled");
        }
    });

    $("input[name=distributorUserIds][data=112]").live("click",function(){
        showSaleReFangcha();
    });
    $("#distributorIds_4").live("click",function(){
        showSaleReFangcha();
    });

    //隐藏团结算
    function hideGroupSettleFlag(){

        $("input[value='group_settle_flag']").parents("tr").hide();
        //是否团结算选中否
        $("input[value='group_settle_flag']").parent().find("input:radio").eq(1).attr('checked','checked');
    }
    //显示团结算
    function showGroupSettleFlag(){
        $("input[value='group_settle_flag']").parents("tr").show();
        //是否团结算选中否
        $("input[value='group_settle_flag']").parent().find("input:radio").eq(1).attr('checked','checked');
    }
    function setFangchaValue(){
        if(${subCategoryId} =='181' && $("input:checkbox[data2='驴色飞扬自驾']").attr("checked")=="checked"
			  && $("#people").attr("checked")=="checked" && $("#bu").val() == "DESTINATION_BU"){
            if($("input[name='prodProductSaleReList[0].houseDiffType']:checked").val()=="AMOUNT"){
                $("input[name='prodProductSaleReList[0].houseDiffAmount']").val(Math.round(parseFloat($("#houseDiffAmount").val())*100));
            }else if($("input[name='prodProductSaleReList[0].houseDiffType']:checked").val()=="PERCENT"){
                $("input[name='prodProductSaleReList[0].houseDiffAmount']").val(Math.round(parseFloat($("#houseDiffAmount_percent").val())*100));
            }else{
                $("input[name='prodProductSaleReList[0].houseDiffAmount']").val("");
            }

            if($("input[name='prodProductSaleReList[0].childPriceType']:checked").val()=="AMOUNT"){
                $("input[name='prodProductSaleReList[0].childPriceAmount']").val(Math.round(parseFloat($("#childPriceAmount").val())*100));
            }else{
                $("input[name='prodProductSaleReList[0].childPriceAmount']").val("");
            }

        }else{
            $("input[name='prodProductSaleReList[0].houseDiffType'][value='NONEED']").attr("checked","checked");
            $("input[name='prodProductSaleReList[0].childPriceType'][value='NONEED']").attr("checked","checked");
            $("input[name='prodProductSaleReList[0].houseDiffAmount']").val("");
            $("input[name='prodProductSaleReList[0].childPriceAmount']").val("");
        }

    }

    function showSaleReFangcha() {
       if(${subCategoryId}=='181'&& $("input:checkbox[data2='驴色飞扬自驾']").attr('checked') == 'checked'
			&& $("#people").attr("checked")=="checked"  && $("#bu").val() == "DESTINATION_BU"){
            if($("input[name=productType]:checked").val()=="INNERLINE" && $("input[name=packageType]:checked").val()=="LVMAMA"){
               $("#prodProductSaleReFangcha").hide();
               $("input[name='prodProductSaleReList[0].houseDiffType']").attr("disabled", "disabled");
               $("#houseDiffAmount").attr("disabled", "disabled");
               $("#houseDiffAmount_percent").attr("disabled", "disabled");
               $("input[name='prodProductSaleReList[0].childPriceType']").attr("disabled", "disabled");
               $("#childPriceAmount").attr("disabled", "disabled");
            }else{
               $("#prodProductSaleReFangcha").show();
               $("input[name='prodProductSaleReList[0].houseDiffType']").removeAttr("disabled");
               $("input[name='prodProductSaleReList[0].houseDiffType'][value='NONEED']").attr("checked", "checked");
               $("input[name='prodProductSaleReList[0].childPriceType']").removeAttr("disabled");
               $("input[name='prodProductSaleReList[0].childPriceType'][value='NONEED']").attr("checked", "checked");
            }
        } else {
            $("#prodProductSaleReFangcha").hide();
            $("input[name='prodProductSaleReList[0].houseDiffType']").attr("disabled", "disabled");
            $("#houseDiffAmount").attr("disabled", "disabled");
            $("#houseDiffAmount_percent").attr("disabled", "disabled");
            $("input[name='prodProductSaleReList[0].childPriceType']").attr("disabled", "disabled");
            $("#childPriceAmount").attr("disabled", "disabled");
        }
    }

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
	
$("#new_info").live("click",function(){
	var $parent = $(this).parent().parent();
	var value = $parent.find("iframe").contents().find(".ke-content").html();
	var tipMsg = "以上交通信息均通过百度地图查询并供您参考，实际情况可能受天气、拥堵、各类突发情况等影响";
	if(value.indexOf(tipMsg)<0){
		$parent.find("iframe").contents().find(".ke-content").append("<p>" + tipMsg + "</p>");
		$("#info_tip").html("添加成功");
		$("#info_tip").show();
	}else{
		$("#info_tip").html("已添加参考文本信息，请勿重复添加");
		$("#info_tip").show();
	}

});
	
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
		if(typeof(addtion) == "undefined" || $("input[name='bizCategoryId']").val() == 15){
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
			var this_traffic = $("input[traffic=traffic_flag]:checked").val();
			if(this_traffic != undefined){
				if(this_traffic == "Y"){
					$("input[value=pack_traffic_flag]").parent().parent().parent().show();
				}
			}else{
				$("input[value=pack_traffic_flag]").parent().parent().parent().show();
			}
			$("#cc1").show();
			$("#input_groupSupplierName").removeAttr("readonly");
			if($("input[name=productType]:checked").val() == "INNERLINE" && $("#bu").val() == "DESTINATION_BU"){
			    $("input:checkbox[data2='逍遥驴行']").show();
			    $("input:checkbox[data2='逍遥驴行']").next().show();
			}
		}else{
			$("#buTr").hide();
			$("#attributionTr").hide();
			$("#bu").removeAttr("required");
			$("#attributionId").removeAttr("required");
			
			$("#tips").show();
			$("input[value=pack_traffic_flag]").parent().parent().parent().hide();
			try{
				$("input[value=pack_traffic_flag]").parent().find("input[type=radio]:checked").removeAttr("checked");
			}catch(e){
					
			}
			$("#cc1").hide();
			$("#input_groupSupplierName").attr("readonly","readonly");
			$("input:checkbox[data2='逍遥驴行']").removeAttr("checked");
			$("input:checkbox[data2='逍遥驴行']").hide();
			$("input:checkbox[data2='逍遥驴行']").next().hide();
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
if(categoryId==15){
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
    showSaleReFangcha();
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
    showSaleReFangcha();
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
		setFangchaValue();
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

function checkTrafficArrive(){
	//交通到达 判断是否添加 提示信息
	var $traffic_info = $("#new_info");
	var $traffic_val = $traffic_info.parent().parent().find("iframe").contents().find(".ke-content");
	var value = $traffic_val.html();
	if(value !=null && value !=""){
		var len = value.length;
		var tipMsg = "以上交通信息均通过百度地图查询并供您参考，实际情况可能受天气、拥堵、各类突发情况等影响";
		var index = value.indexOf(tipMsg);
		if(index<0){
			//交通到达不为空，并且无 参考信息，提示 并且 校验不通过
			$("#info_tip").html("未添加参考文本信息");
			$("#info_tip").show();
			return false;
		}else if(len-tipMsg.length -4 ==index){ //contain '<p>'
			return true;
		}else if(len-tipMsg.length -4> index){
			//提示信息位置不正确,进行调整至最后一行
			if(value.substr(index+tipMsg.length,4) == "</p>"){
				$traffic_val.html(value.substring(0,index-3)+value.substr(index+tipMsg.length +4)+"<p>" + tipMsg + "</p>");
				return true;
			}else{
				$traffic_val.html(value.substring(0,index)+value.substr(index+tipMsg.length)+"<p>" + tipMsg + "</p>");
				return true;
			}
		}
	}else{
		//交通到达为空
		return true;
	}

}

//  --为多出发地添加js start--   //
$(function(){

	//隐藏 基础信息中的 自动打包交通，是否使用被打包产品费用说明，被打包产品id，是否使用被打包产品行程明细    panyu 20160518
	$("input[value='auto_pack_traffic']").parent().parent().parent().hide();
	$("input[value='isuse_packed_cost_explanation']").parent().parent().parent().hide();
	$("input[value='packed_product_id']").parent().parent().parent().hide();
	$("input[value='isuse_packed_route_details']").parent().parent().parent().hide();
	
	showExistMuiltStartPintInput();//当页面加载完成时，判断是否显示多出发地按钮
	
	$("input[name='packageType']").live("click",function(){
		showExistMuiltStartPintInput();
	});
	
	$("input[traffic='traffic_flag']").live("click",function(){
		showExistMuiltStartPintInput();
	});
	
	//当 “类型” 切换触发 下面的 是否显示  “自动打包交通”  panyu 20160518
	$("input[name='productType']").live("click",function(){
		showExistMuiltStartPintInput();
	});
	
	//自动打包交通”默认选中"否"；如果选择“是”，显示“被打包产品ID”、“是否使用被打包产品行程明细”、“是否使用被打包产品费用说明”属性及供产品经理输入  panyu 20160518
//	$("input[autopack='auto_pack_traffic']").live("click",function(){
//		showPackedProductRouteInput();
//	});
	
	//显示“被打包产品ID”、“是否使用被打包产品行程明细”、“是否使用被打包产品费用说明”属性    panyu
	function showPackedProductRouteInput(){
		var autoPackTraffic = $("input[autopack='auto_pack_traffic']:checked").val(); //自动打包交通（是:'Y',否：'N'）
		parent.isTraffic(autoPackTraffic);//调用父页面方法判断选择交通是否显示
		if(autoPackTraffic == 'Y'){
		    $("#mulitStartPointLabel").hide();
		    $("#isMultiStartPoint").hide();
		    
			$("input[value='isuse_packed_cost_explanation']").parent().parent().parent().show();
			$("input[value='packed_product_id']").parent().parent().parent().show();
			$("input[value='isuse_packed_route_details']").parent().parent().parent().show();
			//“自动打包交通”属性为“是”时，只提供“驴妈妈前台”渠道供勾选，其他渠道不展示
			$("#distributorIds_selectAll").attr("disabled",true);  
		//	$("#distributorIds_2").attr("disabled",true);
		//	$("#distributorIds_4").attr("disabled",true);
			$("#distributorIds_5").attr("disabled",true);
			$("#distributorIds_6").attr("disabled",true);	
		}else{
		    $("#mulitStartPointLabel").show();
		    $("#isMultiStartPoint").show();

			$("input[value='isuse_packed_cost_explanation']").parent().parent().parent().hide();
			$("input[value='packed_product_id']").parent().parent().parent().hide();
			$("input[value='isuse_packed_route_details']").parent().parent().parent().hide();
			$("#distributorIds_selectAll").attr("disabled",false);
			$("#distributorIds_2").attr("disabled",false);
			$("#distributorIds_4").attr("disabled",false);
			$("#distributorIds_5").attr("disabled",false);
			$("#distributorIds_6").attr("disabled",false);
		}
	}
	
	//显示多出发地按钮（条件：1.所属品类自由行或跟团游 2.打包类型为自主打包  3.有大交通的）
	function showExistMuiltStartPintInput() {
		var categoryId = $("input[name='bizCategoryId']").val(); //品类id (跟团游->15 自由行->18 当地有->16)
		//不对出境做屏蔽
		var productType = $("input[name='productType']:checked").val(); //类别 (跟团游：(国内短线：'INNERSHORTLINE', 国内长线:'INNERLONGLINE') 非跟团游：(国内：'INNERLINE'),出境：'FOREIGNLINE')
		var packageType = $("input[name='packageType']:checked").val(); //打包类型（自主打包：'LVMAMA',供应商打包：'SUPPLIER'）
		var isTraffic = $("input[traffic='traffic_flag']:checked").val(); //是否为大交通（是:'Y',否：'N'）
	
		if ((categoryId == '15' || categoryId == '18') && packageType =='LVMAMA' && isTraffic == 'Y') {
		   if($("#subCategoryId").val() == 184&&productType == 'INNERLINE'){}
		   else{
		    var muiltStartPintInput = '<input type="checkbox" id="isMultiStartPoint" name="muiltDpartureFlag" value="N"/><span id="mulitStartPointLabel">是否为多出发地</span>';
			if(productType == 'INNERLINE' &&($("#subCategoryId").val() == 182 || $("#subCategoryId").val() == 183)){
			   muiltStartPintInput = '<input type="checkbox" id="isMultiStartPoint" name="muiltDpartureFlag" value="N"/><span id="mulitStartPointLabel">是否为多出发地&nbsp(提示：若勾选是否为多出发，则必须在“选择交通”模块中打包交通产品)</span>';
			}
	
			if ($("#isMultiStartPoint").length == 0) { // 如果没有改元素
				$("#district").after(muiltStartPintInput);
				districtRequired();//如果为未选中状态，出发地为必填项
			}
			
			//如果所属品类为“自由行”或者“跟团游”，类别为“国内”且打包类型为“自主打包”且“是否含有大交通”属性为“是”，则显示属性“自动打包交通”，“自动打包交通”默认选中"否"；  panyu 20160518
			if($("#subCategoryId").val() == 182){//当为 机+酒
				if(productType.indexOf("INNERLINE")!=-1 || productType.indexOf("INNERSHORTLINE")!=-1 || productType.indexOf("INNERLONGLINE")!=-1){
					 //$("input[value='auto_pack_traffic']").parent().parent().parent().show();
				}else{
					$("input[value='auto_pack_traffic']").parent().parent().parent().hide();
					$("input[value='isuse_packed_cost_explanation']").parent().parent().parent().hide();
					$("input[value='packed_product_id']").parent().parent().parent().hide();
					$("input[value='isuse_packed_route_details']").parent().parent().parent().hide();
				}	
			}
		 }
		} else {
				//条件不符合隐藏   “自动打包交通”
				$("input[value='auto_pack_traffic']").parent().parent().parent().hide();
				$("input[value='isuse_packed_cost_explanation']").parent().parent().parent().hide();
				$("input[value='packed_product_id']").parent().parent().parent().hide();
				$("input[value='isuse_packed_route_details']").parent().parent().parent().hide();
				
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
		if (categoryId == '15') {
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
		if(typeof(addtion) == "undefined" || $("input[name='bizCategoryId']").val() == 15){
			addtion="";
		}
		showRequire($("input[name='bizCategoryId']").val(),$("input[name=productType]:checked").val(),addtion);

	}
});
//  --为EBK&VST跟团游优化添加js end--  //


$(function() {
    // 产品经理推荐 start
    var $addOneTJ = $(".addOne_tj");
    var $ltAddTjBtn = $(".lt-add-tj-btn");
    $ltAddTjBtn.on("click", function() {
        var recoArray = $addOneTJ.find("input[name='productRecommends']");
        var countReco = recoArray.length;
        if (countReco > 2) {
            $.alert("产品经理推荐最多3条");
            return;
        }
        var add_tj = "<tr class='lt-tj'><td class='e_label' width='150'></td><td><input type='text' name=\"productRecommends\" class='textWidthPro' style='width:400px;' placeholder='输入产品推荐语，每句话最多输入30个汉字' data-validate=\"true\"  maxlength=\"30\"/><a class='lt-tj-delete-btn' href='javascript:;'>删除</a></td></tr>";
        var $addTj = $(add_tj);
        $addOneTJ.append($addTj);
        var $del = $addOneTJ.find(".lt-tj-delete-btn");

        $.each($del, function(index, item) {
                $(item).show();
        });
      
    });
    $addOneTJ.on("click", ".lt-tj-delete-btn", function() {
        $(this).parents(".lt-tj").remove();

        var $del = $addOneTJ.find(".lt-tj-delete-btn");

        $.each($del, function(index, item) {
                $(item).show();
        });

    });
    // 产品经理推荐 end
});

function getProductRecommends() {
	//产品经理推荐
	var proRecommendStr = "";
	var $proRecommend = $(".addOne_tj").find("input[name='productRecommends']");
	$proRecommend.each(function() {
		var $this = $(this);
		proRecommendStr += $this.val() + "\r\n";
	});
	$("#proRecommendHidden").val(proRecommendStr);

}
//供应商打包总产子销
$(function(){
    $("input[name='packageType']").change("click",function(){//供应商打包显示总产子销的多出发地
        showSupplierPackageMuiltStartPintInput();
    });
    $("input[name='productType']").change("click",function(){//供应商打包显示总产子销的多出发地
        showSupplierPackageMuiltStartPintInput();
    });
    $("input[traffic=traffic_flag]").live("change",function(){
        showSupplierPackageMuiltStartPintInput();
    });
    /**
     * 供应商打包点击是否为多出发地按钮
     */
    $("#isMuiltDpartureInput").live("click", function() {
        if ($(this).is(':checked')) {
            districtNotRequiredSupplier();//如果为选中状态，出发地为非必填项
            //弹出多选框
            districtMutilSelectDialog = new xDialog("/vst_admin/biz/district/multiSelectDistrictList.do?elementId=multiToStartPointHidden&nameId=isMuiltDpartureDiv",{},{title:"选择行政区",iframe:true,width:"1000",height:"600"});
        } else {
            districtRequiredSupplier();//如果为未选中状态，出发地为必填项
			//清空城市
			deleteAllCity();
        }
    });
    $("#isMuiltDpartureSpan").live("click", function() {
        districtMutilSelectDialog = new xDialog("/vst_admin/biz/district/multiSelectDistrictList.do?elementId=multiToStartPointHidden&nameId=isMuiltDpartureDiv",{},{title:"选择行政区",iframe:true,width:"1000",height:"600"});
    });
});
    //显示多出发地按钮（条件：1.所属品类自由行或跟团游 2.打包类型为自主打包  3.有大交通的）
    function showSupplierPackageMuiltStartPintInput() {
    	var productType = $("input[name='productType']:checked").val();
        var packageType = $("input[name='packageType']:checked").val();
        var categoryId = $("input[name='bizCategoryId']").val();
        var subCategoryId = $("input[name='subCategoryId']").val();
        
        if (((categoryId == '15' || (categoryId == '18'&&(subCategoryId=='181'||subCategoryId=='182'||subCategoryId=='183'))) && packageType =='SUPPLIER'&&productType=='FOREIGNLINE')) {
            var muiltStartPintInput = '<input type="checkbox" id="isMuiltDpartureInput" name="isMuiltDeparture" value="N"/><span>是否为多出发地</span>&nbsp;<a id="isMuiltDpartureSpan" href="javascript:void(0);">修改多出发地</a><div id="isMuiltDpartureDiv" style="overflow:hidden;"></div>';

            if ($("#isMuiltDpartureInput").length == 0) { // 如果没有改元素
                $("#district").after(muiltStartPintInput);
                districtRequiredSupplier();//如果为未选中状态，出发地为必填项
            }
        } else {
            if ($("#isMuiltDpartureInput").length > 0) { // 如果有该元素
                $("#isMuiltDpartureSpan").remove();
                $("#isMuiltDpartureInput").remove();
                $("#isMuiltDpartureDiv").remove();
            }

            $("#district").attr("required", "required");
        }
    }
    
    /**
     * 供应商打包产品出发地为必填项（情况：没有勾选多出发地时）
     */
    function districtRequiredSupplier(){
        $("#isMuiltDpartureInput").val("N");
        $("#district").attr("required", "required");
        $("#districtFlag").show();
    }
    /**
     * 供应商打包产品出发地为非必填项（情况：勾选多出发地时）
     */
    function districtNotRequiredSupplier(){
        /*$("#isMuiltDpartureInput").val("Y");
        $("#district").removeAttr("required");
        $("#districtError").empty();
        $("i[for='district']").remove();
        $("#districtFlag").hide();*/
        $("#isMuiltDpartureInput").val("Y");
        $("#district").attr("required", "required");
        $("#districtFlag").show();
    }
    /**
	 * 出发地多选的回调函数
     * @param location
     * @param districts
     */
    //选择行政区（多选）
    function onMultiSelectDistrict(location, districts){
        if(location != null && districts!=null){
            var mutilDiv = $("#"+location.nameId);
            var html = addCity(districts);
            mutilDiv.append(html.hasXhtml)
        }
        districtMutilSelectDialog.close();
        //$("#districtError").hide();
    }
    //添加城市
    function addCity(districts) {
        var oldCityIds = $("#multiToStartPointIds").val();
        var cityArray = new Array();
        if (oldCityIds != '') {
            cityArray = oldCityIds.split(',')
        }

        var hasXhtml = '';// 将要返回的有删除的多城市信息的拼接字符串
        var nohasXhtml = '';// 将要返回的没有删除的多城市信息的拼接字符串
        $.each(districts, function(index, district){
            var isNewCity = true;
            $.each(cityArray, function(index, cityId) {
                if (cityId == district.districtId) {
                    isNewCity = false;
                }
            });

            if (isNewCity) {
                cityArray.push(district.districtId);
                hasXhtml += '<div class="city"><span>' + district.districtName + '</span><span data="' + district.districtId + '">X</span></div>';
                nohasXhtml += '<div class="city"><span>' + district.districtName + '</span><span data="' + district.districtId + '"></span></div>';
            }
        });

        $("#multiToStartPointIds").val(cityArray.join(','));
        var html = {};
        html.hasXhtml = hasXhtml;
        html.nohasXhtml = nohasXhtml;
        return html;
    }
    //点击删除某城市红X
    $("tr .city span:nth-child(2)").live("click",function(){
        var cityId = $(this).attr("data");
        deleteCity(cityId);
    });

    //删除城市
    function deleteCity(cityId){
        var oldCityIds = $("#multiToStartPointIds").val();
        var cityArray = new Array();
        if (oldCityIds != '') {
            cityArray = oldCityIds.split(',')
        }

        console.log('删除前：' + cityArray);
        if ($.inArray(cityId,cityArray) != -1) {
            cityArray.splice($.inArray(cityId, cityArray), 1);
            $('.city span:nth-child(2)[data=' + cityId +']').closest('div').remove();
        }
        $("#multiToStartPointIds").val(cityArray.join(','));
        console.log('删除后：' +cityArray);
    }
    //删除城市
    function deleteAllCity(cityId){
        $("#multiToStartPointIds").val('');
        $('#isMuiltDpartureDiv').html('');
    }
    
    /**
	*如果是多出发地， 去掉[name=district]的required属性
	*/
	function resetDistrictRequiredStatus() {
		if($("#isMultiStartPoint").val() == 'Y') {
			$("#isMultiStartPoint").closest("table").find("input[name=district]").removeAttr("required");
		}
	}

    Date.prototype.Format = function (fmt) { //author: fangxiang
        var o = {
            "M+": this.getMonth() + 1, //月份
            "d+": this.getDate(), //日
            "h+": this.getHours(), //小时
            "m+": this.getMinutes(), //分
            "s+": this.getSeconds(), //秒
            "q+": Math.floor((this.getMonth() + 3) / 3), //季度
            "S": this.getMilliseconds() //毫秒
        };
        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        return fmt;
    }
</script>