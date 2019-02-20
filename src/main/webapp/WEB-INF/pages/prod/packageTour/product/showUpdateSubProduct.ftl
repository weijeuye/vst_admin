<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
<link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/channel/custom/v1/component-chosen.css">
<#include "/base/findSubProductInputType.ftl"/>
<#include "/base/BuGenerator.ftl"/>
<link rel="stylesheet" href="/vst_admin/css/calendar.css" type="text/css"/>
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
<body onload="initReservationLimit();">
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">${prodProduct.bizCategory.categoryName}</a> &gt;</li>
            <li><a href="#">产品维护</a> &gt;</li>
            <li class="active">修改产品</li>
        </ul>
</div> 
<div class="iframe_content mt10">
<div class="tiptext tip-warning"><span class="tip-icon tip-icon-warning"></span>注：产品创建后，不能变更所属的品类</div>
<form action="/vst_admin/prod/product/addProduct.do" method="post" id="dataForm">
    <input type="hidden" id="userName" value="${userName}">
	   <input type="hidden" name="senisitiveFlag" value="N">
       <div class="p_box box_info p_line">
            <div class="box_content">
            <table class="e_table form-inline">
            <tbody>
                <tr>
                	<td width='150' class="e_label"><span class="notnull">*</span>所属品类：</td>
                	<td>
                		<input type="hidden" id="categoryId" name="bizCategoryId" value="${prodProduct.bizCategory.categoryId}" required/>
                		<input type="hidden" name="categoryName" value="${prodProduct.bizCategory.categoryName}"/>
                		<input type="hidden"  name="prodLineRoute.productId"  value="${prodProduct.productId }" required/>
                		<input type="hidden" id="auto_pack_traffic" value="${auto_pack_traffic}">
                        <input type="hidden" id="isuse_packed_route_details" value="${isuse_packed_route_details}">
                        <input type="hidden" id="validNewHotelPriceRule" value="${validNewHotelPriceRule}"/>
                		${prodProduct.bizCategory.categoryName}
                	</td>
                </tr>
                <tr>
                	<td class="e_label"><span class="notnull">*</span>产品ID：</td>
                    <td>
                    	<input type="text" class="w35" id="productId" name="productId" value="${prodProduct.productId}" readonly="readonly">
                    	<input type="hidden" id="subCategoryId" name="subCategoryId" value="${prodProduct.subCategoryId}">
                    </td>
                </tr>
                <tr>
                	<td class="e_label"><i class="cc1">*</i>类别：</td>
                 	 <td >
                    	<span style="background:#ddd">
                    		<!-- categoryId=15 跟团游-->
			                <#if prodProduct.bizCategory.categoryId != 15 >
                  				<#list productTypeList as list>
                  					<#if list.code != 'INNERSHORTLINE' && list.code != 'INNERLONGLINE' && list.code != 'INNER_BORDER_LINE'>
										<input type="radio" name="productTypeTD" value="${list.code!''}" 
											<#if prodProduct.productType != null>disabled</#if> <#if prodProduct.productType == list.code>checked</#if>/>  ${list.cnName!''}
                  					</#if>
               	 				</#list>
               	 			</#if>
               	 			<#if prodProduct.bizCategory.categoryId == 15 >
                  				<#list productTypeList as list>
                  					<#if list.code != 'INNERLINE'>
										<input type="radio" name="productTypeTD" value="${list.code!''}" <#if prodProduct.productType != null>disabled</#if>
										<#if prodProduct.productType == list.code>checked</#if>  />  ${list.cnName!''}
									</#if>
               	 				</#list>
               	 			</#if>
               	 			<input type="hidden" name="productType" value="${prodProduct.productType!''}" /> 
                 	 	</span>
                    	<div id="productTypeError"></div>
                    </td>
               </tr>
                <#if bizCategory.categoryId == '15' || bizCategory.categoryId == '16'>
		                <tr>
		                	<td class="e_label"><i class="cc1">*</i>行程类别：</td>
		                 	 <td>  
								<input type="radio" name="producTourtType" value="ONEDAYTOUR" disabled <#if prodProduct.producTourtType == 'ONEDAYTOUR'>checked</#if>/> 一日游&nbsp;&nbsp;
								<input type="radio" name="producTourtType" value="MULTIDAYTOUR" disabled <#if prodProduct.producTourtType == 'MULTIDAYTOUR'>checked</#if>/> 多日游
		                    </td>
		                </tr>
	            </#if>
               
               <#if prodProduct.bizCategory.categoryId==18&&prodProduct.subCategoryId=='181'>
       				<#if prodProduct.productType=='INNERLINE'>
           		   	<tr style="display:none">
	              		<td class="e_label">产品类型：</td>
	              		<td>
		                	<input type="radio" name="productOrigin"  value="" /> 普通产品
		                	<input type="radio" name="productOrigin"  value="DISNEY" <#if prodProduct.productOrigin == "DISNEY">checked</#if> required /> 迪士尼产品
		                	<input type="radio" name="productOrigin"  value="CHANGLONG" <#if prodProduct.productOrigin == "CHANGLONG">checked</#if> required /> 长隆产品
                    	<div id="productOriginError"></div>
                    	</td>
	               	</tr>
           		   </#if>
	           </#if>
               <#if (prodProduct.packageType =='SUPPLIER' && prodProduct.subCategoryId =='181'&& prodProduct.productType == "INNERLINE")||( prodProduct.bu == 'DESTINATION_BU' && prodProduct.productType == "INNERLINE" &&prodProduct.subCategoryId!='184')>
               		<#if prodProduct.bizCategory.categoryId==18&&prodProduct.subCategoryId!='181'>
		               <tr>
		              		<td class="e_label"><span class="notnull">*</span>产品名称：</td>
		              		
		              		<td>
			                    	<label><input type="text" class="w35" style="width:700px" name="productName" id="productName" value="${prodProduct.productName}" required=true maxlength="100">&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||"</label>
			                    	<div id="productNameError"></div>
			                </td>
		               </tr>
		            <#else>
		                <tr id="trProduct">
		                	<td class="e_label"><span class="notnull">*</span>产品名称：</td>
		               		<td id="zyxJjGn" class="lt-product-name-td">
		                		 <p class="lt-product-name-view-main">
                                <span class="lt-pnv-content-main">
                                <#if prodProduct.subCategoryId == '181' && prodProduct.productType=='INNERLINE'>
                                	<#if prodProductNameVo.mainTitle?? &&prodProductNameVo.mainTitle!=''>
                                		主标题：${prodProductNameVo.mainTitle!''} 
                            		<#if prodProductNameVo.subTitle??&&prodProductNameVo.subTitle!=''></br>副标题：${prodProductNameVo.subTitle!''}</#if>
                                	<#else>
                                			${prodProduct.productName!''}
                                	</#if>
                                	<a href="javascript:;" class="js-pnv-modify" data-dialog="
	                                    <#if prodProduct.bizCategory.categoryId==18&&prodProduct.productType == 'INNERLINE'>
	                                    	.addName_zyx_gn_dialog
	                                    <#elseif prodProduct.bizCategory.categoryId==18&&prodProduct.productType == 'FOREIGNLINE'>
	                                    	.addName_zyx_cj_dialog
	                                    </#if>">修改</a>
                                <#else>
                                	<#if prodProductNameVo.version == '1.0'>
                                		主标题：${prodProductNameVo.mainTitle!''}
                                		
                                	<#else>
                                		${prodProduct.productName!''}
                                	</#if>
                                </#if>
                                	
                                </span>
                            </p>
                            <input type="hidden" class="JS_hidden_main_product_name" id="productName" name="productName" value="${prodProduct.productName!''}" data-validate="true" required>
	                   			<div class="JS_hidden_product_name_vo_div">
	                            	<input type="hidden" class="JS_hidden_vo_main_title" name="prodProductNameVO.mainTitle" value="${prodProductNameVo.mainTitle!''}">
	                            	<input type="hidden" class="JS_hidden_vo_sub_title" name="prodProductNameVO.subTitle" value="${prodProductNameVo.subTitle!''}">
	                            	<input type="hidden" class="JS_hidden_vo_destination" name="prodProductNameVO.destination" value="${prodProductNameVo.destination!''}">
	                            	<input type="hidden" class="JS_hidden_vo_night_number" name="prodProductNameVO.nightNumber" value="${prodProductNameVo.nightNumber!''}">
	                            	<input type="hidden" class="JS_hidden_vo_day_number" name="prodProductNameVO.dayNumber" value="${prodProductNameVo.dayNumber!''}">
	                            	<input type="hidden" class="JS_hidden_vo_mainTitleAttr" name="prodProductNameVO.mainTitleAttr" value="${prodProductNameVo.mainTitleAttr!''}">
	                            	<input type="hidden" class="JS_hidden_vo_hotelName" name="prodProductNameVO.hotelName" value="${prodProductNameVo.hotelName!''}">
	                            	<input type="hidden" class="JS_hidden_vo_hotelAttr" name="prodProductNameVO.hotelAttr" value="${prodProductNameVo.hotelAttr!''}">
	                            	<input type="hidden" class="JS_hidden_vo_spotName" name="prodProductNameVO.spotName" value="${prodProductNameVo.spotName!''}">
	                            	<input type="hidden" class="JS_hidden_vo_spotAttr" name="prodProductNameVO.spotAttr" value="${prodProductNameVo.spotAttr!''}">
	                            	<input type="hidden" class="JS_hidden_vo_sellAttr" name="prodProductNameVO.sellAttr" value="${prodProductNameVo.sellAttr!''}">
	                            </div>
	                    	</td>
	                    	</tr>
		            </#if>
               <#else>
				<tr>
                	<td class="e_label"><span class="notnull">*</span>产品名称：</td>
                	<#if prodProduct.bizCategory.categoryId==18&&prodProduct.subCategoryId!='181'>
                		<td class="lt-product-name-td">
                             <p class="lt-product-name-view-main">
                                <span class="lt-pnv-content-main">
                                
                                	<#if prodProductNameVo.version == '1.0'>
                                		主标题：${prodProductNameVo.mainTitle!''}
                                	<#else>
                                		${prodProduct.productName!''}
                                	</#if>
                                </span>
                                
                                <a href="javascript:;" class="lt-pnv-modify" data-dialog="
                                    <#if prodProduct.bizCategory.categoryId==18&&prodProduct.productType == 'INNERLINE'>
                                    	.addName_zyx_gn_dialog
                                    <#elseif prodProduct.bizCategory.categoryId==18&&prodProduct.productType == 'FOREIGNLINE'>
                                    	.addName_zyx_cj_dialog
                                    </#if>">修改</a>
                            </p>

                            <input type="hidden" id="productName" name="productName" value="${prodProduct.productName!''}" class="JS_hidden_main_product_name" data-validate="true" required>
                            <div class="JS_hidden_product_name_vo_div">
                            	<input type="hidden" class="JS_hidden_vo_main_title" name="prodProductNameVO.mainTitle" value="${prodProductNameVo.mainTitle!''}">
                            	<input type="hidden" class="JS_hidden_vo_sub_title" name="prodProductNameVO.subTitle" value="${prodProductNameVo.subTitle!''}">
                            	<input type="hidden" class="JS_hidden_vo_sub_title_4_tnt" name="prodProductNameVO.subTitle4Tnt" value="${prodProductNameVo.subTitle4Tnt!''}">
                            	<input type="hidden" class="JS_hidden_vo_destination" name="prodProductNameVO.destination" value="${prodProductNameVo.destination!''}">
                            	<input type="hidden" class="JS_hidden_vo_night_number" name="prodProductNameVO.nightNumber" value="${prodProductNameVo.nightNumber!''}">
                            	<input type="hidden" class="JS_hidden_vo_day_number" name="prodProductNameVO.dayNumber" value="${prodProductNameVo.dayNumber!''}">
                            	<input type="hidden" class="JS_hidden_vo_play_type" name="prodProductNameVO.playType" value="${prodProductNameVo.playType!''}">
                            	<input type="hidden" class="JS_hidden_vo_benefit" name="prodProductNameVO.benefit" value="${prodProductNameVo.benefit!''}">
                            	<input type="hidden" class="JS_hidden_vo_theme_content" name="prodProductNameVO.themeContent" value="${prodProductNameVo.themeContent!''}">
                            	<input type="hidden" class="JS_hidden_vo_hotel" name="prodProductNameVO.hotel" value="${prodProductNameVo.hotel!''}">
                            	<input type="hidden" class="JS_hidden_vo_main_feature" name="prodProductNameVO.mainFeature" value="${prodProductNameVo.mainFeature!''}">
                            	<input type="hidden" class="JS_hidden_vo_level_star" name="prodProductNameVO.levelStar" value="${prodProductNameVo.levelStar!''}">
                            	<input type="hidden" class="JS_hidden_vo_hotel_or_feature" name="prodProductNameVO.hotelOrFeature" value="${prodProductNameVo.hotelOrFeature!''}">
                            	<input type="hidden" class="JS_hidden_vo_flight_feature" name="prodProductNameVO.flightFeature" value="${prodProductNameVo.flightFeature!''}">
                            	<input type="hidden" class="JS_hidden_vo_other_feature" name="prodProductNameVO.otherFeature" value="${prodProductNameVo.otherFeature!''}">
                            	<input type="hidden" class="JS_hidden_vo_hotel_package" name="prodProductNameVO.hotelPackage" value="${prodProductNameVo.hotelPackage!''}">
                            	<input type="hidden" class="JS_hidden_vo_hotel_feature" name="prodProductNameVO.hotelFeature" value="${prodProductNameVo.hotelFeature!''}">
                            	<input type="hidden" class="JS_hidden_vo_traffic" name="prodProductNameVO.traffic" value="${prodProductNameVo.traffic!''}">
                            	<input type="hidden" class="JS_hidden_vo_large_activity" name="prodProductNameVO.largeActivity" value="${prodProductNameVo.largeActivity!''}">
                            	
                            	<input type="hidden" class="JS_hidden_vo_promotion_or_hotel" name="prodProductNameVO.promotionOrHotel" value="${prodProductNameVo.promotionOrHotel!''}">
                            	<input type="hidden" class="JS_hidden_vo_product_feature" name="prodProductNameVO.productFeature" value="${prodProductNameVo.productFeature!''}">
                            	<input type="hidden" class="JS_hidden_vo_product_name" name="prodProductNameVO.productName" value="${prodProductNameVo.productName!''}">
                            	<input type="hidden" class="JS_hidden_vo_version" name="prodProductNameVO.version" value="${prodProductNameVo.version!''}">
                            </div>
                        </td>
                    <#elseif prodProduct.bizCategory.categoryId==18&&prodProduct.subCategoryId=='181'>
                    	<#if prodProduct.productType == 'FOREIGNLINE'>
                    		<td class="lt-product-name-td">
                             <p class="lt-product-name-view-main">
                                <span class="lt-pnv-content-main">
                                	<#if prodProductNameVo.version == '1.0'>
                                		主标题：${prodProductNameVo.mainTitle!''}
                                	<#else>
                                		${prodProduct.productName!''}
                                	</#if>
                                </span>
                                
                                <a href="javascript:;" class="lt-pnv-modify" data-dialog="
                                    <#if prodProduct.bizCategory.categoryId==18&&prodProduct.productType == 'INNERLINE'>
                                    	.addName_zyx_gn_dialog
                                    <#elseif prodProduct.bizCategory.categoryId==18&&prodProduct.productType == 'FOREIGNLINE'>
                                    	.addName_zyx_cj_dialog
                                    </#if>">修改</a>
                            </p>

                            <input type="hidden" id="productName" name="productName" value="${prodProduct.productName!''}" class="JS_hidden_main_product_name" data-validate="true" required>
                            <div class="JS_hidden_product_name_vo_div">
                            	<input type="hidden" class="JS_hidden_vo_main_title" name="prodProductNameVO.mainTitle" value="${prodProductNameVo.mainTitle!''}">
                            	<input type="hidden" class="JS_hidden_vo_sub_title" name="prodProductNameVO.subTitle" value="${prodProductNameVo.subTitle!''}">
                            	<input type="hidden" class="JS_hidden_vo_sub_title_4_tnt" name="prodProductNameVO.subTitle4Tnt" value="${prodProductNameVo.subTitle4Tnt!''}">
                            	<input type="hidden" class="JS_hidden_vo_destination" name="prodProductNameVO.destination" value="${prodProductNameVo.destination!''}">
                            	<input type="hidden" class="JS_hidden_vo_night_number" name="prodProductNameVO.nightNumber" value="${prodProductNameVo.nightNumber!''}">
                            	<input type="hidden" class="JS_hidden_vo_day_number" name="prodProductNameVO.dayNumber" value="${prodProductNameVo.dayNumber!''}">
                            	<input type="hidden" class="JS_hidden_vo_play_type" name="prodProductNameVO.playType" value="${prodProductNameVo.playType!''}">
                            	<input type="hidden" class="JS_hidden_vo_benefit" name="prodProductNameVO.benefit" value="${prodProductNameVo.benefit!''}">
                            	<input type="hidden" class="JS_hidden_vo_theme_content" name="prodProductNameVO.themeContent" value="${prodProductNameVo.themeContent!''}">
                            	<input type="hidden" class="JS_hidden_vo_hotel" name="prodProductNameVO.hotel" value="${prodProductNameVo.hotel!''}">
                            	<input type="hidden" class="JS_hidden_vo_main_feature" name="prodProductNameVO.mainFeature" value="${prodProductNameVo.mainFeature!''}">
                            	<input type="hidden" class="JS_hidden_vo_level_star" name="prodProductNameVO.levelStar" value="${prodProductNameVo.levelStar!''}">
                            	<input type="hidden" class="JS_hidden_vo_hotel_or_feature" name="prodProductNameVO.hotelOrFeature" value="${prodProductNameVo.hotelOrFeature!''}">
                            	<input type="hidden" class="JS_hidden_vo_flight_feature" name="prodProductNameVO.flightFeature" value="${prodProductNameVo.flightFeature!''}">
                            	<input type="hidden" class="JS_hidden_vo_other_feature" name="prodProductNameVO.otherFeature" value="${prodProductNameVo.otherFeature!''}">
                            	<input type="hidden" class="JS_hidden_vo_hotel_package" name="prodProductNameVO.hotelPackage" value="${prodProductNameVo.hotelPackage!''}">
                            	<input type="hidden" class="JS_hidden_vo_hotel_feature" name="prodProductNameVO.hotelFeature" value="${prodProductNameVo.hotelFeature!''}">
                            	<input type="hidden" class="JS_hidden_vo_traffic" name="prodProductNameVO.traffic" value="${prodProductNameVo.traffic!''}">
                            	<input type="hidden" class="JS_hidden_vo_large_activity" name="prodProductNameVO.largeActivity" value="${prodProductNameVo.largeActivity!''}">
                            	
                            	<input type="hidden" class="JS_hidden_vo_promotion_or_hotel" name="prodProductNameVO.promotionOrHotel" value="${prodProductNameVo.promotionOrHotel!''}">
                            	<input type="hidden" class="JS_hidden_vo_product_feature" name="prodProductNameVO.productFeature" value="${prodProductNameVo.productFeature!''}">
                            	<input type="hidden" class="JS_hidden_vo_product_name" name="prodProductNameVO.productName" value="${prodProductNameVo.productName!''}">
                            	<input type="hidden" class="JS_hidden_vo_version" name="prodProductNameVO.version" value="${prodProductNameVo.version!''}">
                            </div>
                        </td>
                    	<#elseif prodProduct.productType == 'INNERLINE'>
                    	<td>
	                    	<label><input type="text" class="w35" style="width:700px" name="productName" id="productName" value="${prodProduct.productName}" required=true maxlength="100">&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||"</label>
	                    	<div id="productNameError"></div>
	                    	
							
	                    </td>
                    	</#if>
                	<#else>
                		<#if prodProduct.packageType =='SUPPLIER'>
                	</#if>
	                    <td>
	                    	<label><input type="text" class="w35" style="width:700px" name="productName" id="productName" value="${prodProduct.productName}" required=true maxlength="100">&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||"</label>
	                    	<div id="productNameError"></div>
	                    </td>
                    </#if>
                </tr>
                <#if (prodProduct.bizCategory.categoryId==18&&prodProduct.subCategoryId!='181')||(prodProduct.bizCategory.categoryId==18&&prodProduct.subCategoryId=='181'&&prodProduct.productType == 'FOREIGNLINE')>
                	<tr>
                        <td class="e_label" width="150"></td>
                        <td class="lt-product-sub-name-td">
                        	<p class="lt-product-name-view-sub">
                        		<span class="lt-pnv-content-sub">
                        			<#if prodProductNameVo.version == '1.0'>
                            		副标题：${prodProductNameVo.subTitle!''}
                            		</#if>
                            	</span>
						    </p>
                        </td>
                    </tr>
                </#if>
                </#if>
                <tr>
                	<td class="e_label"><span class="notnull">*</span>供应商产品名称：</td>
                    <td>
                    	<label><input type="text" class="w35" style="width:700px" name="suppProductName" id="suppProductName" value="${prodProduct.suppProductName}" required=true maxlength="100">&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||"</label>
                    	<div id="productNameError"></div>
                    </td>
                </tr>
               	<tr>
					<td class="e_label"><span class="notnull">*</span>是否有效：</td>
					<td>
						<select id="cancelFlag" name="cancelFlag" required>
			                    <option value='Y' <#if prodProduct.cancelFlag == 'Y'>selected</#if> >是</option>
			                    <option value='N' <#if prodProduct.cancelFlag == 'N'>selected</#if> >否</option>
	                    </select>
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
                        <td class="e_label" width="150"><i class="cc1">*</i>产品等级：</td>
                        <td>
                            <select name="productGrade">
                                <option  value=""  >无</option>
                                <option <#if prodProduct.productGrade == 'LVHSH'>selected</#if>  value="LVHSH">驴惠实惠</option>
                                <option <#if prodProduct.productGrade == 'LVYZD'>selected</#if>  value="LVYZD">驴悠中端</option>
                                <option <#if prodProduct.productGrade == 'LVZGD'>selected</#if>  value="LVZGD">驴尊高端</option>
                            </select>
                            <span>说明：驴惠实惠：全程入住四星级以下酒店、驴悠中端：全程入住四星级酒店及以上-五星级以下酒店、驴尊高端：全程入住五星级酒店及以上酒店</span>
                        </td>
                </tr>
              	<tr>
                	<td class="e_label"><i class="cc1">*</i>打包类型：</td>
                 	 <td>
                 	 		<span style="background:#ddd">
                 	 			<#list packageTypeList as list>
                 	 					<input type="radio" name="packageTypeTD" value="${list.code!''}"  required="true" <#if prodProduct.packageType == list.code>  checked </#if> 
                 	 					  <#if prodProduct.packageType != null>disabled</#if> />${list.cnName!''}
                 	 			</#list>
                 	 			<input type="hidden" name="packageType" value="${prodProduct.packageType!''}"  />
                 	 		</span>
                    	<div id="packageTypeError"></div>
                    </td>
                </tr>
               	 <tr>
                	<td class="e_label"><i class="cc1">*</i>产品经理：</td>
                 	 <td>
                    	<input type="text" class="w35 searchInput" name="managerName" id="managerName" required value="${prodProduct.managerName }"/>
						<input type="hidden" name="managerId" id="managerId" required value="${prodProduct.managerId }"/>
						<span id="tips" style="display:none; color:red;">注：该处信息仅供参考，如需修改请至商品基础设置下进行维护</span>
						<div id="managerNameError"></div>
                    </td>
                </tr>
               	<tr>
                	<td class="e_label"><i class="cc1">*</i>所属分公司：</td>
                 	 <td>
                    	<select name="filiale" class="filialeCombobox" id="filiale">
                    		<option value="">请选择</option>
						  	<#list filiales as filiale>
			                    <option value="${filiale.code}" <#if prodProduct.filiale == filiale>selected</#if>>${filiale.cnName}</option>
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
		                	<option value=${list.code!''} <#if prodProduct.bu == list.code>selected</#if> <#if prodProduct.subCategoryId == "181"&&list.code=='TICKET_BU'>disabled="disabled"</#if> >
		                		${list.cnName!''}
		                	</option>
			            </#list>
				    	</select>-->
				    	<#--http://ipm.lvmama.com/index.php?m=story&f=view&t=html&id=12992-->
				    	<#if prodProduct.bu??>
				    	<@BuGenerator buList prodProduct.bu prodProduct.bizCategory.categoryId prodProduct.subCategoryId/>
				    	</#if>
	                </td>
	            </tr>
                
                <tr id="attributionTr">
					<td class="e_label"><i class="cc1">*</i>归属地：</td>
					<td colspan=2>
						<input type="text" name="attributionName" id="attributionName" value="${prodProduct.attributionName}"  readonly="readonly" required/>
						<input type="hidden" name="attributionId" id="attributionId" value="${prodProduct.attributionId}" />
                    </td>
                </tr>
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
                                <option value="" <#if econtract != null && econtract.econtractTemplate == ''>selected</#if>>自动调取</option>
                                <option value="PREPAYMENTS" <#if econtract !=null && econtract.econtractTemplate == 'PREPAYMENTS'>selected</#if>>预付款协议</option>
                                <option value="PRESALE_AGREEMENT" <#if econtract !=null && econtract.econtractTemplate == 'PRESALE_AGREEMENT'>selected</#if>>旅游产品预售协议</option>
                                <option value="TAIWAN_AGREEMENT" <#if econtract !=null && econtract.econtractTemplate == 'TAIWAN_AGREEMENT'>selected</#if>>赴台旅游预订须知</option>
                                <option value="DONGGANG_ZHEJIANG_CONTRACT" <#if econtract !=null && econtract.econtractTemplate == 'DONGGANG_ZHEJIANG_CONTRACT'>selected</#if>>浙江省赴台旅游合同</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td width="150" class="e_label td_top"><i class="cc1">*</i>组团方式：</td>
                        <td>
                        	<input type="radio" name="prodEcontract.groupType" value="SELF_TOUR" <#if econtract != null && econtract.groupType == 'SELF_TOUR'>checked</#if> />自行组团&nbsp;
							<input type="radio" name="prodEcontract.groupType" value="COMMISSIONED_TOUR" <#if econtract != null && econtract.groupType == 'COMMISSIONED_TOUR'>checked</#if> />委托组团&nbsp;
							<label id="label_groupSupplierName" <#if econtract != null && (econtract.groupType == 'SELF_TOUR' || econtract.groupType == null)>style="display:none;"</#if>><i class="cc1" id="cc1">*</i>被委托组团方:</div>
							<input id="input_groupSupplierName" type="text" name="prodEcontract.groupSupplierName" <#if econtract != null>value="${econtract.groupSupplierName!''}"</#if> <#if econtract != null && (econtract.groupType == 'SELF_TOUR' || econtract.groupType == null)>style="display:none;"</#if> />
							<input type="hidden" id="input_groupSupplierNameHidden"  value="${groupSupplierName!''}"/>
							
                        </td>
                    </tr>
                    <!--
						<tr>
							<td class="e_label"><i class="cc1">*</i>合同主体</td>
							<td>
								<select name="companyType" required style="width:250px;" <#if prodProduct.auditStatus=='AUDITTYPE_PASS'>disabled="disabled"</#if>>
									<#if prodProduct.auditStatus?exists && prodProduct.auditStatus = 'AUDITTYPE_PASS'>
										<#if prodProduct.companyType?exists>
											<option value="${prodProduct.companyType}" >${companyTypeMap[prodProduct.companyType]}</option>
										<#else>
											<option value="XINGLV" >${companyTypeMap['XINGLV']}</option>
										</#if>
									<#else>
										<#list companyTypeMap?keys as key>
								  			<option value="${key}"<#if key == "${prodProduct.companyType}" >selected="selected"</#if> >${companyTypeMap[key]}</option>
									  	</#list>
									</#if>
							  	</select>
							</td>
						</tr>
					-->	
                 </table>
             </div>
             <input type="hidden" name="prodEcontract.productId" value="${productId}" />
        </div>
        
        	<!-- 条款品类属性分组Id -->
       		<#assign suggGroupIds = [26,27,28,29,30,31,32,33]/>  
 			<#assign productId="${prodProduct.productId}" />
  			<#assign index=0 />
 			<#list bizCatePropGroupList as bizCatePropGroup>
	            <#if (!suggGroupIds?seq_contains(bizCatePropGroup.groupId)) && bizCatePropGroup.bizCategoryPropList?? && (bizCatePropGroup.bizCategoryPropList?size &gt; 0) >
		            <div class="p_box box_info">
		            <div class="title">
					    <h2 class="f16"><#if bizCatePropGroup.groupId == 105> <#else>${bizCatePropGroup.groupName!''}：</#if></h2>
				    </div>
		            <div class="box_content">
		            	<table class="e_table form-inline">
		             		<tbody>
			                	<#list bizCatePropGroup.bizCategoryPropList as bizCategoryProp>
			                		<#if prodProduct.bizCategory.categoryId == '15' || prodProduct.bizCategory.categoryId == '16' || prodProduct.bizCategory.categoryId == '17' || prodProduct.bizCategory.categoryId == '18'>
			                		 <#--产品经理推荐-->
			                		<#if bizCategoryProp?? && bizCategoryProp.propCode=='recommend'>
			                		 <tr>
			                		  <td colspan="2">
                                      <table class="e_table form-inline addOne_tj">
                                        <tbody>
                                          <#if bizCategoryProp.prodProductPropList?? && bizCategoryProp.prodProductPropList?size gt 0 && bizCategoryProp.prodProductPropList[0].propValue!="" && bizCategoryProp.prodProductPropList[0].propValue??>
                                            <#assign recommendList=bizCategoryProp.prodProductPropList[0].propValue?split("\r\n")/>
                                              <#list recommendList as recommend>
                                              <tr class='lt-tj'>
                                                   <td class="e_label" width="150"><#if recommend_index == 0>产品经理推荐：</#if></td>
                                                   <td><input type="text" value="${recommend!''}" name="productRecommends"  style="width:400px;" placeholder="输入产品推荐语，每句话最多输入30个汉字" data-validate="true"  maxlength="30"/>
                                                  <#if recommend_index == 0><a id="editOldData"  class="btn btn_cc1">编辑产品经理推荐</a></#if>
                                                   <#if recommend_index gt 1><a class='lt-tj-delete-btn' href='javascript:;'>删除</a></#if>
                                                   </td>
                                                </tr>
                                                <#if recommendList?size==1>
                                                   <tr class='lt-tj'>
                                                   <td class="e_label" width="150"></td>
                                                   <td><input type="text" value="" name="productRecommends"  style="width:400px;" placeholder="输入产品推荐语，每句话最多输入30个汉字" data-validate="true"  maxlength="30"/>
                                                   </td>
                                                </tr>
                                                </#if>
                                              </#list>
                                          
                                          <#else>
                                           <#list 1..2 as num>
                                              <tr class='lt-tj'>
                                                <td class="e_label" width="150"><#if num_index == 0>产品经理推荐：</#if></td>
                                                <td><input type="text" name="productRecommends"  style="width:400px;" placeholder="输入产品推荐语，每句话最多输入30个汉字" data-validate="true"  maxlength="30"/>
                                                </td>
                                              </tr>
                                           </#list>
                                         </#if>
                                          <input type="hidden" name="prodProductPropList[${index}].prodPropId" value="${(bizCategoryProp.prodProductPropList[0].prodPropId)!''}"  />
                                          <input type="hidden" id="proRecommendHidden" name="prodProductPropList[${index}].propValue"  value="${(bizCategoryProp.prodProductPropList[0].propValue)!''}" />
                                          <input type="hidden" name="prodProductPropList[${index}].propId" value="${bizCategoryProp.propId}" />
                                          <input type="hidden" name="prodProductPropList[${index}].bizCategoryProp.propCode" value="${bizCategoryProp.propCode!''}"/>
                                       </tbody>
                                          <input id="editOldDataHidden" value="true"  type="hidden" />
                                     </table>
                                     <p class="add_one_word"><a class="lt-add-tj-btn" style="margin-left:150px;" href="javascript:;">增加一条</a></p>
                                     <p  style="color:grey;margin-left:150px;">注：最少1到2条，最多3条</p>
                                     </td>
                                    </tr>
                                     <#assign index=index+1 />
			                			<#else>

					               			<#if (bizCategoryProp??)>
					               			  <#if bizCategoryProp.propCode!='feature'>
												  <#if bizCategoryProp.propCode=='group_settle_flag' && prodProduct.productType!='FOREIGNLINE'>
												  <#--非出境 不显示团结算-->
												  <#else>
						                		<#assign disabled='' />
						                		<#if bizCategoryProp.cancelFlag=='N'>
						                			<#assign disabled='disabled' />
						                		</#if>
						                		<#assign prodPropId='' />
						                		<#assign propId=bizCategoryProp.propId />
						                		<#if bizCategoryProp?? && bizCategoryProp.prodProductPropList[0]!=null>
							                		<#assign prodPropId=bizCategoryProp.prodProductPropList[0].prodPropId />
						                		</#if>
						                		
							                	<tr <#if prodProduct.subCategoryId==181&&propId==600>style="display:none;"</#if>>
								                <td width="150" class="e_label td_top">
								                	<#if bizCategoryProp.nullFlag == 'Y'><span class="notnull">*</span></#if>
								                	${bizCategoryProp.propName!''}
								                	<#if bizCategoryProp.cancelFlag=='N'><span style="color:red" class="cancelProp">[无效]</span></#if>：
								                </td>
							                	<td> <span class="${bizCategoryProp.inputType!''}">     		
							                		<input type="hidden" name="prodProductPropList[${index}].prodPropId" value="${prodPropId}" ${disabled}  />
							                		<input type="hidden" name="prodProductPropList[${index}].propId" value="${propId}" ${disabled} />
							                		<input type="hidden" name="prodProductPropList[${index}].bizCategoryProp.propCode" value="${bizCategoryProp.propCode!''}"/>
							                		 <!-- 調用通用組件 -->
							                		<@displayHtml productId index bizCategoryProp  />
							                		<#if bizCategoryProp.inputType = 'INPUT_TYPE_RICH' && prodProduct.bizCategory.categoryId==18 && prodProduct.subCategoryId == '181' && prodProduct.productType == "INNERLINE">
								                		<span id = "traffic_arrive_info" >
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
							              </#if>
							             </#if>
							           <#else>
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
						                		
							                	<tr <#if prodProduct.subCategoryId==181&&propId==600>style="display:none;"</#if>>
								                <td width="150" class="e_label td_top">
								                	<#if bizCategoryProp.nullFlag == 'Y'><span class="notnull">*</span></#if>
								                	${bizCategoryProp.propName!''}
								                	<#if bizCategoryProp.cancelFlag=='N'><span style="color:red" class="cancelProp">[无效]</span></#if>：
								                </td>
							                	<td> <span class="${bizCategoryProp.inputType!''}">     		
							                		<input type="hidden" name="prodProductPropList[${index}].prodPropId" value="${prodPropId}" ${disabled}  />
							                		<input type="hidden" name="prodProductPropList[${index}].propId" value="${propId}" ${disabled} />
							                		<input type="hidden" name="prodProductPropList[${index}].bizCategoryProp.propCode" value="${bizCategoryProp.propCode!''}"/>
							                		 <!-- 調用通用組件 -->
							                		<@displayHtml productId index bizCategoryProp  />
							                		<div id="errorEle${index}Error" style="display:inline"></div>
							                		<span style="color:grey">${bizCategoryProp.propDesc!''}</span>
							        				</span></td>
								        		</tr>
							              	</#if>
							               <#assign index=index+1 />
						               </#if>
                             <!-- 获取自动打包交通属性，是否选择是选项 -->
                             <#if bizCategoryProp.propCode == "auto_pack_traffic">
                                  <#if bizCategoryProp.prodProductPropList?? && bizCategoryProp.prodProductPropList?size gt 0>
                                       <#list bizCategoryProp.prodProductPropList as prodProductProp>
                                            <#if prodProductProp.propValue?? && "Y" == prodProductProp.propValue>
                                                <input type="hidden" id="propValue" value="${prodProductProp.propValue}">
                                            </#if>
                                       </#list>
                                  </#if>
                             </#if>


		                	</#list>
		                 </tbody>
				       </table>
		            </div>
		        </div>
	        </#if>
		</#list>
        
        <!-- 插件位置 -->
		<div class="p_box box_info p_line">
			  <div class="box_content">
                <table class="e_table form-inline">
                    <tbody>
                     <#if prodProduct.bizCategory.categoryCode != 'category_route_hotelcomb'>
		                <tr id="districtTr">
		                <input type="hidden" id="currentMuiltDpartureFlag" value="<#if prodProduct.muiltDpartureFlag??>${prodProduct.muiltDpartureFlag}</#if>" >
		                	<td class="e_label"><#if prodProduct.bizCategory.categoryId!=16><i id="districtFlag" class="cc1">*</i></#if>出发地：</td>
		                 	 <td>
                                 <input type="hidden" name="multiToStartPointIds" id="multiToStartPointIds" value=""/>
		                    	<input type="text" class="w35" id="district" name="district" readonly = "readonly" value="<#if prodProduct.bizDistrict??>${prodProduct.bizDistrict.districtName!''}</#if>" <#if prodProduct.bizCategory.categoryId != 16>required</#if>/>
		                    	<input type="hidden" name="bizDistrictId" id="districtId" value="<#if prodProduct.bizDistrict??>${prodProduct.bizDistrict.districtId}</#if>" >
		                    	<div id="bizDistrictIdError"></div>
		                    </td>
		                </tr>
	                </#if>
	                <#if prodProduct.prodDestReList ?? &&  prodProduct.prodDestReList?size gt 0>
	                <#list prodProduct.prodDestReList as prodDestRe>
		                <tr <#if prodDestRe_index=0>name='no1'</#if>>
		                	<#if prodDestRe_index=0>
					   			<td name="addspan" rowspan='${prodProduct.prodDestReList?size}' class="e_label"><i class="cc1">*</i>目的地：</td>
					   		</#if>
				            <td>
				            	<input type="text" name="dest" class="w35" id="dest${prodDestRe_index}" value="${prodDestRe.destName}[${prodDestRe.destTypeCnName }]" readonly = "readonly" required>
				            	<input type="hidden" name="prodDestReList[${prodDestRe_index}].destId" id="destId" value="${prodDestRe.destId}"> <#if prodDestRe_index gt 0 >  <a class='btn btn_cc1' name='del_button'>删除</a></#if>
				            	<input type="hidden" name="prodDestReList[${prodDestRe_index}].reId" id="reId" value="${prodDestRe.reId}">
				            	<input type="hidden" name="prodDestReList[${prodDestRe_index}].productId" value="${prodProduct.productId}">
				            	<#if prodDestRe_index=0><a class="btn btn_cc1" id="new_button">添加目的地</a></#if>
				            	<#if prodProduct.subCategoryId!="181">
				            	<#if prodDestRe.parentDestName!=null><span type="text" id="spanId_${prodDestRe_index}" >上级目的地：${prodDestRe.parentDestName}</span>
				            	<#else><span type="text" id="spanId_${prodDestRe_index}" ></span>
				            	</#if>
				            	</#if>
				            </td>
		        	    </tr>
                	</#list>
                	<#else>
                	<tr name='no1'>
	                	<td name="addspan" class="e_label"><i class="cc1">*</i>目的地：</td>
	                 	 <td>
	                    	<input type="text" class="w35" id="dest0" name="dest" readonly = "readonly" required>
	                    	<input type="hidden" name="prodDestReList[0].destId" id="destId0" />
	                    	<input type="hidden" name="prodDestReList[0].reId" id="reId0" >
                            <input type="hidden" name="prodDestReList[0].productId" id="productId0" >
	                    	<a class="btn btn_cc1" id="new_button">添加</a>
	                    	<span type="text" id="spanId_0"></span>
	                    	<div id="destError"></div>
	                    </td>
	                </tr>
                	</#if>
                
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
				 <#if prodProduct.prodProductSaleReList ?? && prodProduct.prodProductSaleReList?size gt 0>
					 <#if prodProduct.categoryCombTicket=='true' && prodProduct.prodProductSaleReList[0].saleType == 'COPIES'>
					 <span style="background:#ddd">
						<input id="people" type="radio" class="saleType" name="prodProductSaleReList[0].saleType"  value="PEOPLE" checked="checked" disabled="disabled"><span>人</span>
						&nbsp;&nbsp;
					    <input id="copies" type="radio" class="saleType" name="prodProductSaleReList[0].saleType"  value="COPIES" ><span>份</span>
					    <select id="copiesValue" style="width:100px; display:none;" disabled="disabled">
	                    	<#list copiesList as item>
		                    	<option value="${item.code}">${item.cName}</option>
	                    	</#list>
                        </select>
					  <input id="prodSaleTypeId" type="hidden" name="prodProductSaleReList[0].prodSaleTypeId" value="${(prodProduct.prodProductSaleReList[0].prodSaleTypeId)!''}" />
					  <input id="isPackageGroupHotel" type="hidden" name="isPackageGroupHotel" value="${isPackageGroupHotel!''}" />
                      <span id="custom" style="display:none;">
                		成人：<input type="text" id="adult" name="prodProductSaleReList[0].adult" style="width:80px;" readonly="readonly" placeholder="大于等于2"/>
                		儿童：<input type="text" id="child" name="prodProductSaleReList[0].child" style="width:80px;" readonly="readonly" placeholder="大于等于0"/>
                	  </span>
                	   </span>
					  <#else>
					  <input id="people" type="radio" class="saleType" name="prodProductSaleReList[0].saleType"  value="PEOPLE" checked="checked"><span>人</span>
						&nbsp;&nbsp;
					    <input id="copies" type="radio" class="saleType" name="prodProductSaleReList[0].saleType" value="COPIES" ><span>份</span>
						<select id="copiesValue" style="width:100px; display:none;">
	                    	<#list copiesList as item>
		                    	<option value="${item.code}">${item.cName}</option>
	                    	</#list>
	                    </select>
	                    <input id="prodSaleTypeId" type="hidden" name="prodProductSaleReList[0].prodSaleTypeId" value="${(prodProduct.prodProductSaleReList[0].prodSaleTypeId)!''}" />
					    <input id="isPackageGroupHotel" type="hidden" name="isPackageGroupHotel" value="${isPackageGroupHotel!''}" />
                        <span id="custom" style="display:none;">
                		成人：<input type="text" id="adult" name="prodProductSaleReList[0].adult" style="width:80px;" placeholder="大于等于2"/>
                		儿童：<input type="text" id="child" name="prodProductSaleReList[0].child" style="width:80px;" placeholder="大于等于0"/>
                	     </span>
					  </#if>
				</#if>
				</td>
			</table>
			<div style="display:none;" id="prodProductSaleReFangcha">
				<table class="p_box box_info p_line">
                    <tr>
                        <td width="150" class="e_label td_top">房差：</td>
                        <td>
                            <input id="houseDiffType" type="radio" name="prodProductSaleReList[0].houseDiffType" value="NONEED"
								   <#if prodProduct.prodProductSaleReList ?? && prodProduct.prodProductSaleReList?size gt 0
								   && prodProduct.prodProductSaleReList[0].saleType == 'PEOPLE' && prodProduct.prodProductSaleReList[0].houseDiffType == 'NONEED' >checked="checked" </#if>>
									   <span>不需要设置房差</span>
                        </td>
						<td>
                            <input id="houseDiffType" type="radio" name="prodProductSaleReList[0].houseDiffType" value="AMOUNT"
								   <#if prodProduct.prodProductSaleReList ?? && prodProduct.prodProductSaleReList?size gt 0
								   && prodProduct.prodProductSaleReList[0].saleType == 'PEOPLE' && prodProduct.prodProductSaleReList[0].houseDiffType == 'AMOUNT' >checked="checked" </#if>>
								<span>固定价格</span>
                            <input id="houseDiffAmount" type="text" name="prodProductSaleReList[0].houseDiffAmountInput"
								   <#if prodProduct.prodProductSaleReList ?? && prodProduct.prodProductSaleReList?size gt 0
							&& prodProduct.prodProductSaleReList[0].saleType == 'PEOPLE' && prodProduct.prodProductSaleReList[0].houseDiffType == 'AMOUNT' >
                                   value="${prodProduct.prodProductSaleReList[0].houseDiffAmountYuan}"<#else> disabled="disabled" </#if>
								    required="required" number=true min=0 ><span>元</span>
                        </td>
						<td>
                            <input id="houseDiffType" type="radio" name="prodProductSaleReList[0].houseDiffType" value="PERCENT"
								   <#if prodProduct.prodProductSaleReList ?? && prodProduct.prodProductSaleReList?size gt 0
								   && prodProduct.prodProductSaleReList[0].saleType == 'PEOPLE' && prodProduct.prodProductSaleReList[0].houseDiffType == 'PERCENT' >checked="checked" </#if>>
								<span>基于酒店销售价的百分比</span>
                            <input id="houseDiffAmount_percent" type="text" name="prodProductSaleReList[0].houseDiffAmountInput"
							<#if prodProduct.prodProductSaleReList ?? && prodProduct.prodProductSaleReList?size gt 0
							&& prodProduct.prodProductSaleReList[0].saleType == 'PEOPLE' && prodProduct.prodProductSaleReList[0].houseDiffType == 'PERCENT' >
                                   value="${prodProduct.prodProductSaleReList[0].houseDiffAmountYuan}"<#else> disabled="disabled" </#if>
								   required="required" number=true min=0 ><span>%</span>
                        </td>
						<input type="hidden" name="prodProductSaleReList[0].houseDiffAmount" value="" />
                    </tr>
                    <tr>
                        <td width="150" class="e_label td_top">儿童价：</td>
                        <td>
                            <input id="childPriceType" type="radio" name="prodProductSaleReList[0].childPriceType" value="NONEED"
								   <#if prodProduct.prodProductSaleReList ?? && prodProduct.prodProductSaleReList?size gt 0
								   && prodProduct.prodProductSaleReList[0].saleType == 'PEOPLE' && prodProduct.prodProductSaleReList[0].childPriceType == 'NONEED' >checked="checked" </#if>
									><span>不需要设置儿童价</span>
                        </td>
						<td>
                            <input id="childPriceType" type="radio" name="prodProductSaleReList[0].childPriceType" value="AMOUNT"
								   <#if prodProduct.prodProductSaleReList ?? && prodProduct.prodProductSaleReList?size gt 0
								   && prodProduct.prodProductSaleReList[0].saleType == 'PEOPLE' && prodProduct.prodProductSaleReList[0].childPriceType == 'AMOUNT' >checked="checked" </#if>
									><span>固定价格</span>
                            <input id="childPriceAmount" type="text" name="prodProductSaleReList[0].childPriceAmountInput"
							<#if prodProduct.prodProductSaleReList ?? && prodProduct.prodProductSaleReList?size gt 0
							&& prodProduct.prodProductSaleReList[0].saleType == 'PEOPLE' && prodProduct.prodProductSaleReList[0].childPriceType == 'AMOUNT' >
                                   value="${prodProduct.prodProductSaleReList[0].childPriceAmountYuan}"<#else> disabled="disabled" </#if>
								   required="required" number=true min=0 ><span>元</span>
                        </td>
                        <input type="hidden" name="prodProductSaleReList[0].childPriceAmount" value="" />
                    </tr>
				</table>
			</div>
		</div>
		
		<!-- 条款品类属性分组Id -->
       		<#assign suggGroupIds = [37]/>
       		  
 			<#list subCatePropGroupList as bizCatePropGroup>

	            <#if (suggGroupIds?seq_contains(bizCatePropGroup.groupId)) && bizCatePropGroup.bizCategoryPropList?? && (bizCatePropGroup.bizCategoryPropList?size &gt; 0) >
		            <div class="p_box box_info">
		            <!-- <div class="title">
					    <h2 class="f16">${bizCatePropGroup.groupName!''}：</h2>
				    </div> -->
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
					                	<td> <span class="${bizCategoryProp.inputType!''}">     		
					                		<input type="hidden" name="prodProductPropList[${index}].prodPropId" value="${prodPropId}" ${disabled}  />
					                		<input type="hidden" name="prodProductPropList[${index}].propId" value="${propId}" ${disabled} />
					                		<input type="hidden" name="prodProductPropList[${index}].bizCategoryProp.propCode" value="${bizCategoryProp.propCode!''}"/>
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
		
		<div class="p_box box_info p_line">
			<#include "/prod/packageTour/product/showDistributorProd.ftl"/>
		</div>

    	<input type="hidden" id="hasProdTraffic" name="hasProdTraffic" />
		</form>       
        <div class="p_box box_info p_line" id="reservationLimit">
			<div class="title">
			   <h2 class="f16">预订限制</h2>
			</div>
			<#include "/common/reservationLimit.ftl"/>
		</div>
        
        <div class="p_box box_info clearfix mb20">
            <div class="fl operate">
	            <a class="btn btn_cc1" id="save">保存</a>
	            <a class="btn btn_cc1" id="saveAndNext">保存并维护下一步</a>
	            <a href="javascript:void(0);" style="margin-left:100px;" class="showLogDialog btn btn_cc1" param='objectId=${productId}&objectType=PROD_PRODUCT_PRODUCT&sysName=VST'>查看操作日志</a>
            </div>
        </div>


</div>
<#include "/base/foot.ftl"/>

<!-- 产品名称结构化  css，js start -->
<#if prodProduct.bizCategory.categoryId == '18'>
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
.lt_dialog .lt-not-null{ color:#f00;}
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

</#if>
<!-- 产品名称结构化  css，js end -->

<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/kindeditor.js"></script>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/plugins/image/image.js"></script>
<script type="text/javascript" src="/vst_admin/js/contentManage/kindEditorConf.js?v1"></script>
<script type="text/javascript" src="/vst_admin/js/prod/packageTour/product/autoPackCheck.js"></script>
<script type="text/javascript" src="/vst_admin/js/prod/packageTour/chosen-jquery.js?v1"></script>
<script type="text/javascript">
$(function(){

	<#if prodProduct.subCategoryId?? &&  prodProduct.subCategoryId == 181>
	window.SPECIAL_PROCESS_KEY_13 = true;
	</#if>
			
	$(document).ready(function () {
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
                    content +=  addMddNote;
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
		}else if( jsFromHotel.length < 1 ){
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
			$('#zyxJjGn').find(".JS_hidden_vo_sub_title").val(content);
			$('#zyxJjGn').find(".JS_hidden_vo_main_title").val(mainTitle);
			var name =mainTitle+content;
			
			<#if prodProduct.subCategoryId?? &&  prodProduct.subCategoryId == 181>
			var	maxNameLength = 70;
			<#else>
			var maxNameLength = 200;
			</#if>
			if(name.length>maxNameLength){
				alert("产品名称长度不能超过"+maxNameLength)
				return false;
			}
			$('.lt-pnv-content-main').html('主标题：'+mainTitle+'</br>'+'副标题：'+content+'<a href="javascript:;" class="js-pnv-modify">修改</a>');
			$('.JS_hidden_main_product_name').val(name);
			$('#zyxJjGn').find(".JS_hidden_vo_destination").val(jsAddMdd);
			$('#zyxJjGn').find(".JS_hidden_vo_day_number").val(dayCount);
			$('#zyxJjGn').find(".JS_hidden_vo_night_number").val(nightCount);
			$('#zyxJjGn').find(".JS_hidden_vo_mainTitleAttr").val(addMddNote);
			$('#zyxJjGn').find(".JS_hidden_vo_hotelAttr").val(hotelAddNote);
			$('#zyxJjGn').find(".JS_hidden_vo_spotAttr").val(soptAddNote);
			$('#zyxJjGn').find(".JS_hidden_vo_sellAttr").val(jsSaleVal);
			$('#zyxJjGn').find(".JS_hidden_vo_hotelName").val(jsFromHotelText);
			$('#zyxJjGn').find(".JS_hidden_vo_spotName").val(jsFromSpotText);
			$('.lt-dialog-close').click()
		}
	})
	
	$(document).on('click','.js-pnv-modify',function(){
		var $dialog =$($(this).attr("data-dialog"));
		var $dialog2 =$('.INNERLINE');
		$dialog.find(".hotel-add-note").val( $(".JS_hidden_product_name_vo_div").find(".JS_hidden_vo_hotelAttr").val());
		$dialog.find(".spot-add-note").val( $(".JS_hidden_product_name_vo_div").find(".JS_hidden_vo_spotAttr").val());
		$dialog.find(".jd-sale-mdd").val( $(".JS_hidden_product_name_vo_div").find(".JS_hidden_vo_sellAttr").val());
		$dialog.find(".js-add-mdd").val( $(".JS_hidden_product_name_vo_div").find(".JS_hidden_vo_destination").val());
		$dialog.find(".add-main-title").val($(".JS_hidden_product_name_vo_div").find(".JS_hidden_vo_main_title").val());
		$dialog.find(".add-sub-title").val($(".JS_hidden_product_name_vo_div").find(".JS_hidden_vo_sub_title").val());
		$dialog.find(".night-count").val($(".JS_hidden_product_name_vo_div").find(".JS_hidden_vo_night_number").val());
		$dialog.find(".day-count").val($(".JS_hidden_product_name_vo_div").find(".JS_hidden_vo_day_number").val());
		$dialog.find(".add-mdd-note").val($(".JS_hidden_product_name_vo_div").find(".JS_hidden_vo_mainTitleAttr").val());
		var $jsFromHotel = $dialog2.find('.js-from-hotel').siblings('.chosen-container').find('.chosen-choices').find('.search-field');
        var $jsFromSpot = $dialog2.find('.js-from-spot').siblings('.chosen-container').find('.chosen-choices').find('.search-field');
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
		$('.INNERLINE').show()
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

$(function(){
 		var packageType ='${prodProduct.packageType}';		
 		$("#trTitle1").hide();
		$("#trTitle2").hide();
		$("#trTitle3").hide();
	   if("SUPPLIER"==packageType){
			$("#cc1").remove();
			$("#input_groupSupplierName").attr("readonly","readonly");
			if($("input[name='productType']").val() == "INNERLINE"){
				$("#trProduct").show();
			}
	   }
	   
		if($("input[name='productType']").val() == "FOREIGNLINE"){
	       $("select[name='productGrade']").val("");
	       $("select[name='productGrade']").attr('disabled','disabled');
	    }
})

//保存后修改“自动打包交通”属性和“是否使用被打包产品行程明细”属性
$(document).ready(function(){
	   //var auto_pack_traffic = $('#auto_pack_traffic').val();
	   var isuse_packed_route_details = $('#isuse_packed_route_details').val();
	   //$("#auto_pack_traffic",parent.document).val(auto_pack_traffic);
	   $("#isuse_packed_route_details",parent.document).val(isuse_packed_route_details); 
	   $("#modelVersion",parent.document).val(${modelVersion});
	   if("${prodProduct.productType}" != "INNERLINE" || "${prodProduct.bu}" != "DESTINATION_BU" || "${prodProduct.packageType}" != "LVMAMA"){
	       $("input:checkbox[data2='逍遥驴行']").hide();
	       $("input:checkbox[data2='逍遥驴行']").next().hide();
	   }
});

	//页面加载完毕判断类型是否可以被操作
	if("${prodProduct.subCategoryId}"== "181" || "${prodProduct.subCategoryId}"== "182" || "${prodProduct.subCategoryId}"== "183"|| "${prodProduct.subCategoryId}"== "184"){
		$("input:checkbox[data=propId_615]").attr("disabled",false);
        $("input:checkbox[data=propId_615]").parent().parent().parent().show();
	}else{
		$("input:checkbox[data=propId_615]").attr("checked",false);
		$("input:checkbox[data=propId_615]").attr("disabled","disabled");
        $("input:checkbox[data=propId_615]").parent().parent().parent().hide();
	}	
	
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
				if($($that).attr('data2') == '逍遥驴行'){
				    $("input:checkbox[data2='开心驴行']").removeAttr("checked");				
				}
				if($($that).attr('data2') == '开心驴行'){
				    $("input:checkbox[data2='逍遥驴行']").removeAttr("checked");				
				}
			});
			
		}
		if($($that).attr('data2') == '驴色飞扬自驾'){
			showSaleReFangcha();
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
			$("#input_groupSupplierName").val($("#input_groupSupplierNameHidden").val());
		}
		
		var packageType ='${prodProduct.packageType}';	
		if("SUPPLIER"==packageType){
			$("#cc1").hide();
			$("#input_groupSupplierName").attr("readonly","readonly");
		}else{
			$("#cc1").show();
			$("#input_groupSupplierName").removeAttr("readonly");
		}
	});
	
	$("input[name=packageTypeTD]").live("change",function(){
		$("input[name=packageType]").val($("input[name=packageTypeTD]:checked").val());
		var packageType = $("input[name=packageTypeTD]:checked").val();	
		if("SUPPLIER"==packageType){
			$("#cc1").hide();
			$("#input_groupSupplierName").attr("readonly","readonly");
		}else{
			$("#cc1").show();
			$("#input_groupSupplierName").removeAttr("readonly");
		}
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
	$("#bu").live("change", function(){
        showSaleReFangcha();
        if("${prodProduct.productType}" == "INNERLINE" && $(this).val() == "DESTINATION_BU"){
            $("input:checkbox[data2='逍遥驴行']").show();
	        $("input:checkbox[data2='逍遥驴行']").next().show();
	//		$("#trStructName1").show();
	//		$("#trStructName2").show();
	//		$("#trProduct").hide();
			$("#productNameEC").attr("disabled", "disabled");
        }else{
            $("input:checkbox[data2='逍遥驴行']").hide();
	        $("input:checkbox[data2='逍遥驴行']").next().hide();
//	        $("#trStructName1").hide();
//			$("#trStructName2").hide();
			$("#trProduct").show();
			$("#productNameEC").removeAttr("disabled");
        }
	});
	
	$("a[name=updateStructName]").live("click",function(){
		var productId = ${prodProduct.productId};
			$.ajax({
					url : "/vst_admin/packageTour/prod/product/updateStructName.do",
					type : "post",
					dataType : 'json',
					data : "productId="+productId,
					success : function(result) {
						if(result.code=="success"){
							var destAndDays = result.attributes.destAndDays
							$("#destAndDays").val(destAndDays);
							$("#destAndDays").removeAttr("readonly");
						}
						if(result.code=="error"){
							$.alert(result.message);
						}
					},
					error : function(result) {
							$.alert("更新失败 "+result.message);
						}	
			});
		
		
	});
	
	function setFangchaValue(){
		if(${prodProduct.subCategoryId} =='181' && $("input:checkbox[data2='驴色飞扬自驾']").attr("checked")=="checked"
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
	
	function showSaleReFangcha(){
		if( ${prodProduct.subCategoryId}=='181'&& $("input:checkbox[data2='驴色飞扬自驾']").attr('checked') == 'checked'
           && $("#people").attr("checked")=="checked"  && $("#bu").val() == "DESTINATION_BU"){
	            if("${prodProduct.productType}"=="INNERLINE" && "${prodProduct.packageType}"=="LVMAMA"){
                   $("#prodProductSaleReFangcha").hide();
                   $("input[name='prodProductSaleReList[0].houseDiffType']").attr("disabled", "disabled");
                   $("#houseDiffAmount").attr("disabled", "disabled");
                   $("#houseDiffAmount_percent").attr("disabled", "disabled");
                   $("input[name='prodProductSaleReList[0].childPriceType']").attr("disabled", "disabled");
                   $("#childPriceAmount").attr("disabled", "disabled");
                }else{
                   $("#prodProductSaleReFangcha").show();
	               $("input[name='prodProductSaleReList[0].houseDiffType']").removeAttr("disabled");
	               $("input[name='prodProductSaleReList[0].houseDiffType'][value='NONEED']").attr("checked","checked");
	               $("input[name='prodProductSaleReList[0].childPriceType']").removeAttr("disabled");
	               $("input[name='prodProductSaleReList[0].childPriceType'][value='NONEED']").attr("checked","checked");
                }
			}else{
				$("#prodProductSaleReFangcha").hide();
				$("input[name='prodProductSaleReList[0].houseDiffType']").attr("disabled","disabled");
	            $("#houseDiffAmount").attr("disabled","disabled");
	            $("#houseDiffAmount_percent").attr("disabled","disabled");
	            $("input[name='prodProductSaleReList[0].childPriceType']").attr("disabled","disabled");
	            $("#childPriceAmount").attr("disabled","disabled");
			}
	}
	
	$("input[name=productType]").live("change",function(){
		var addtion=$("input[traffic=traffic_flag]:checked").val();
		if(typeof(addtion) == "undefined" || $("input[name='bizCategoryId']").val() == 15){
			addtion="";
		}
		showRequire($("input[name='bizCategoryId']").val(),$("input[name=productType]:checked").val(),addtion);
		
	});
	
	//判断打包类型，然后更新父页面菜单
	var packageType = $("input[name=packageTypeTD]:checked").val();
	$("#packageType",parent.document).val(packageType);
	if("SUPPLIER"==packageType){
		$("#lvmama",parent.document).remove();
		$("#supplier",parent.document).show();
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
	}else if("LVMAMA"==packageType){
		$("#buTr").show();
		$("#attributionTr").show();
		$("#bu").attr("required","true");
		$("#attributionId").attr("required","true");
		
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
		$("#transportType",parent.document).val(transportType);
		if(transportType == 'Y'){
			$("#transportLi",parent.document).show();
		}else {
			$("#transportLi",parent.document).hide();
		}
	}

   //巴士+酒  国内 是否有大交通'否'不可选
    var subCategoryId ='${prodProduct.subCategoryId}';
    if(subCategoryId==184&&$("input[name='productType']").val() == "INNERLINE"){
       var trafficFlags=$("input[traffic=traffic_flag]");
      if(trafficFlags[0].value=='N'){
         trafficFlags[0].setAttribute("disabled","disabled");
      }else if(trafficFlags[1].value=='N'){
         trafficFlags[1].setAttribute("disabled","disabled"); 
      }
    }
    

	function initReservationLimit(){
		if($("input[name='bizCategoryId']").val()==18 && $("input[name=productTypeTD]:checked").val()=="INNERLINE"){
			var addtion=$("input[traffic=traffic_flag]:checked").val();
			showRequire($("input[name='bizCategoryId']").val(),$("input[name=productTypeTD]:checked").val(),addtion);
		}else{
			showRequire($("input[name='bizCategoryId']").val(),$("input[name=productTypeTD]:checked").val(),"");
		}
	}
	
var coordinateSelectDialog;
$(function(){

	//隐藏 基础信息中的 自动打包交通，是否使用被打包产品费用说明，被打包产品id，是否使用被打包产品行程明细    panyu 20160519
	$("input[value='auto_pack_traffic']").parent().parent().parent().hide();
	$("input[value='isuse_packed_cost_explanation']").parent().parent().parent().hide();
	$("input[value='packed_product_id']").parent().parent().parent().hide();
	$("input[value='isuse_packed_route_details']").parent().parent().parent().hide();
	
	var categoryId = $("input[name='bizCategoryId']").val(); //品类id (跟团游->15 自由行->18 当地有->16)
	var productType = $("input[name='productTypeTD']:checked").val(); //类别 (跟团游：(国内短线：'INNERSHORTLINE', 国内长线:'INNERLONGLINE') 非跟团游：(国内：'INNERLINE'),出境：'FOREIGNLINE')
	var packageType = $("input[name='packageTypeTD']:checked").val(); //打包类型（自主打包：'LVMAMA',供应商打包：'SUPPLIER'）
	var isTraffic = $("input[traffic='traffic_flag']:checked").val(); //是否为大交通（是:'Y',否：'N'）
	//如果 自由行 （机+酒）修改类别为“国内”且打包类型为“自主打包”且“是否含有大交通”属性为“是”"自动打包交通" 设置不可修改   panyu 20160519
	if(categoryId==18 && packageType =='LVMAMA' && isTraffic == 'Y'&& productType == 'INNERLINE'){
		//$("input[value='auto_pack_traffic']").parent().parent().parent().show();
		//var autopack = $("input[autopack=auto_pack_traffic]");
		//autopack.attr('disabled',true);
		if($("input[autopack='auto_pack_traffic']:checked").val() == 'Y'){//如果"自动打包交通"选择的为“是”，则显示其他三项
			//$("input[value='isuse_packed_cost_explanation']").parent().parent().parent().show();
			//$("input[value='packed_product_id']").parent().parent().parent().show();
			//$("input[value='isuse_packed_route_details']").parent().parent().parent().show();
			
			//“自动打包交通”属性为“是”时，只提供“驴妈妈前台”渠道供勾选，其他渠道不展示
			//“自动打包交通”属性为“是”时,提供“驴妈妈前台”“分销商”渠道供勾选，其他渠道不展示
			//$("#distributorIds_selectAll").attr("disabled",true);  
		//	$("#distributorIds_2").attr("disabled",true);
		//	$("#distributorIds_4").attr("disabled",true);
			//$("#distributorIds_5").attr("disabled",true);
			//$("#distributorIds_6").attr("disabled",true);
		}else{
			$("#distributorIds_selectAll").attr("disabled",false);
			$("#distributorIds_2").attr("disabled",false);
			$("#distributorIds_4").attr("disabled",false);
			$("#distributorIds_5").attr("disabled",false);
			$("#distributorIds_6").attr("disabled",false);
		}
	}	
	
	var dataObj=[],markList=[];
		
	$("#cancelFlag").attr("disabled","disabled");
	
	$(".sensitiveVad").each(function(){
		var mark=$(this).attr('mark');
	 	var t = lvmamaEditor.editorCreate('mark',mark);
	 	dataObj.push(t);
	 	markList.push(mark);
	});
	
	showOrHideSaleTypeOnLoadPage();
	
	//判断是否有大交通
	var trafficValue = $("input[traffic=traffic_flag]:checked").val();
	$("#transportType",parent.document).val(trafficValue);
	//如果没有大交通则因此出发地
	if(trafficValue=="N"){
		$("#districtTr").hide();
		$("#district").hide();
		$("#district").val(null);
		$("#districtId").val(null);
		$("input[value=pack_traffic_flag]").parent().parent().parent().hide();
		try{
			$("input[value=pack_traffic_flag]").parent().find("input[type=radio]:checked").removeAttr("checked");
		}catch(e){
				
		}
	}
	//交通按钮切换
	$("input[traffic=traffic_flag]").click(function(){
		if('${prodProduct.subCategoryId}'=='181')
			return;
		var that = $(this);
		if(that.attr("checked")=="checked"){
			if(that.val()=="N"){
				$("#districtTr").hide();
				$("#district").hide();
				$("#district").val(null);
				$("#districtId").val(null);
				$("input[value=pack_traffic_flag]").parent().parent().parent().hide();
				try{
					$("input[value=pack_traffic_flag]").parent().find("input[type=radio]:checked").removeAttr("checked");
				}catch(e){
						
				}
			}else if(that.val()=="Y"){
				$("#districtTr").show();
				$("#district").show();
				
				if($("input[name='bizCategoryId']").val()==15){
					$("input[traffic=traffic_flag]").attr('disabled', true);
	            }
	            var this_package = $("input[name=packageTypeTD]:checked").val();
                if(this_package != undefined){
					if(this_package == "LVMAMA"){
						$("input[value=pack_traffic_flag]").parent().parent().parent().show();
					}
                }
			}
            onChangeTrafficFlag();
            
		}
		
	});
	
	
	//自由行品类属性是否有大交通 选择是必填 选择否 则置灰不维护
	onChangeTrafficFlag();
	
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
	
	$("#save").bind("click",function(){
			resetDistrictRequiredStatus();
		   if(!valiateOldData(true,false)){
             return false;
            };
            getProductRecommends();

			//景酒 校验‘交通到达’是否添加提示
			if(${prodProduct.subCategoryId}=='181' && '${prodProduct.productType}' !='FOREIGNLINE'){
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
			var productSubType = $("input[name=productOrigin]:checked").val();
			
			var productTypevalue = $("input[name=productType]").val();
			if(productTypevalue == "undefined" || productTypevalue == ''){
				alert("请填写产品类别.");
				return;
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
			
			var econtractGroupTypeVal = $("input:radio[name='prodEcontract.groupType']:checked").val();
			if(typeof(econtractGroupTypeVal) =="undefined"){
				alert("请选择组团方式!");
				return;
			}else if(econtractGroupTypeVal == "COMMISSIONED_TOUR"){
			var packageType ='${prodProduct.packageType}';			
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
            
	        
            var promTitle;
	        var mainTitle;
	        var subTitle;
	        var productNameEC;
            
            promTitle = $("input[name='promTitle']").val();
            if(typeof(promTitle) =="undefined"){
            	promTitle = "";
            }
            mainTitle = $("input[name='mainTitle']").val();
            if(typeof(mainTitle) =="undefined"){
            	mainTitle = "";
            }
            subTitle = $("input[name='subTitle']").val();
            productNameEC = $("#productNameEC").val();
            
            
            if(typeof(subTitle) =="undefined"){
	            var productNameVal = $("#productName").val();
	            if("${isValidateTitle!'N'}"=='N'&&(typeof(subTitle) =="undefined"||subTitle=="")){
			        if(typeof(productNameVal) =="undefined"||productNameVal==""){
			        	alert('请填写产品名称！');
			        	return;
			        }
			    }
			}else{
                if(productSubType == ""){
                	if(subTitle==""){
                		alert('请输入副标题');
	                	return;
                	}
                }else{
                	if(productNameEC==""){
                		alert('请输入产品名称');
	                	return;
	                }
                }
			}  
	        
	        
	        if(checkAddPrice() == true){
                $.alert("门店和其他分销不适用于酒店结算百分比加价",function(){
                   $("#distributorIds_10").removeAttr("checked");
                   $("#distributorIds_20").removeAttr("checked");
                   $("#distributorUserIds_0").removeAttr("checked");
                });
                return;
			}
			
			//验证
			var flag1;
			var flag2;
			var bFormValidation = $("#dataForm").validate({
				rules : {
	                productName : {
	                    isChar : true
	                },
	                suppProductName: {
	                    isChar : true
	                },
	                jjDestDay:{
	                	isChar : true
	                },
	                jjTitle:{
	                	isChar : true
	                }
	            },
	            messages : {
	                productName : '不可输入特殊字符',
	                suppProductName: '不可输入特殊字符',
	                jjDestDay:'不可输入特殊字符',
	                jjTitle:'不可输入特殊字符'
	            }
			}).form();
			var filialeName = $("select.filialeCombobox").combobox("getValue");
			if(!filialeName) {
				var $combo = $("select.filialeCombobox").next();
				$("i[for=\"FILIALE\"]").remove();
				$combo.css('border-color', "red");
				$("<i for=\"FILIALE\" class=\"error\">该字段不能为空</i>").insertAfter($combo);
			}

			if(!bFormValidation || !filialeName) {
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
			var msg = '确认修改吗 ？';	
			 if(refreshSensitiveWord($("input[type='text'],textarea"))){
			 	 $("input[name=senisitiveFlag]").val("Y");
			 	msg = '内容含有敏感词,是否继续?'
			 }else {
			$("input[name=senisitiveFlag]").val("N");
			}

            var hasProdTraffic = $("input[traffic=traffic_flag]:checked").val();
			$("#hasProdTraffic").val(hasProdTraffic);


    		$.confirm(msg,function(){
    			
    			$("#cancelFlag").removeAttr("disabled");
    			var loading = top.pandora.loading("正在努力保存中...");
    			//设置附加属性的值
				refreshAddValue();
    			
				var trafficFlag = $("input[traffic=traffic_flag]:checked");
				var parameter = $("#dataForm").serialize()+"&"+$("#reservationLimitForm").serialize();
                if($("input[name='bizCategoryId']").val() == 15 && trafficFlag.attr("disabled") == 'disabled'){
                    parameter += "&"+trafficFlag.attr('name')+"="+trafficFlag.val();
                }
                
                //20160608   panyu
                var categoryId = $("input[name='bizCategoryId']").val(); //品类id (跟团游->15 自由行->18 当地有->16)
                var productType = $("input[name='productTypeTD']:checked").val(); //类别 (跟团游：(国内短线：'INNERSHORTLINE', 国内长线:'INNERLONGLINE') 非跟团游：(国内：'INNERLINE'),出境：'FOREIGNLINE')
				var packageType = $("input[name='packageTypeTD']:checked").val(); //打包类型（自主打包：'LVMAMA',供应商打包：'SUPPLIER'）
				var isTraffic = $("input[traffic='traffic_flag']:checked").val(); //是否为大交通（是:'Y',否：'N'）
                //如果 自由行 （机+酒）修改类别为“国内”且打包类型为“自主打包”且“是否含有大交通”属性为“是”"自动打包交通" 设置不可修改   panyu 20160519
				//var autopack = $("input[autopack=auto_pack_traffic]:checked");
				//if(categoryId==18 && packageType =='LVMAMA' && isTraffic == 'Y'&& productType == 'INNERLINE' && autopack.attr("disabled") == 'disabled'){
					//parameter += "&"+autopack.attr('name')+"="+autopack.val();
                //}
                
                if(typeof(subTitle) !="undefined"&&subTitle!=null){
                	var packTitle = promTitle + "#"+ mainTitle + "#" + subTitle;
                	var title = encodeURI(packTitle).replace(/\+/g, '%2B');
                	parameter += "&packTitle="+title;
            }
				$.ajax({
					url : "/vst_admin/packageTour/prod/product/updateProduct.do",
					type : "post",
					dataType : 'json',
					data : parameter,
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
	
	$("#saveAndNext").bind("click",function(){
		resetDistrictRequiredStatus();
		 if(!valiateOldData(true,false)){
             return false;
            };
            getProductRecommends();

			//景酒 校验‘交通到达’是否添加提示
			if(${prodProduct.subCategoryId}=='181' && '${prodProduct.productType}' !='FOREIGNLINE'){
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
			var productSubType = $("input[name=productOrigin]:checked").val();
			var productTypevalue = $("input[name=productType]").val();
			if(productTypevalue == "undefined" || productTypevalue == ''){
				alert("请填写产品类别.");
				return;
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
			
			var econtractGroupTypeVal = $("input:radio[name='prodEcontract.groupType']:checked").val();
			if(typeof(econtractGroupTypeVal) =="undefined"){
				alert("请选择组团方式!");
				return;
			}
			
			var promTitle;
	        var mainTitle;
	        var subTitle;
	        var productNameEC;
            
            promTitle = $("input[name='promTitle']").val();
            if(typeof(promTitle) =="undefined"){
            	promTitle = "";
            }
            mainTitle = $("input[name='mainTitle']").val();
            if(typeof(mainTitle) =="undefined"){
            	mainTitle = "";
            }
            subTitle = $("input[name='subTitle']").val();
            productNameEC = $("#productNameEC").val();
            
            
            if(typeof(subTitle) =="undefined"){
	            var productNameVal = $("#productName").val();
	            if("${isValidateTitle!'N'}"=='N'&&(typeof(subTitle) =="undefined"||subTitle=="")){
			        if(typeof(productNameVal) =="undefined"||productNameVal==""){
			        	alert('请填写产品名称！');
			        	return;
			        }
			    }
			}else{
                if(productSubType == ""){
                	if(subTitle==""){
                		alert('请输入副标题');
	                	return;
                	}
                }else{
                	if(productNameEC==""){
                		alert('请输入产品名称');
	                	return;
	                }
                }
			}         
	        
	        //if("${isValidateTitle!'N'}"=='Y'||(typeof(subTitle) !="undefined"&&subTitle=="")){
	        	//promTitle = $("input[name='promTitle']").val();
               // mainTitle = $("input[name='mainTitle']").val();
                //subTitle = $("input[name='subTitle']").val();
                //if(typeof(promTitle) =="undefined"||promTitle==""){
                //	alert('请输入促销标题');
                //	return;
                //}
	        	//if(typeof(mainTitle) =="undefined"||mainTitle==""){
                //	alert('请输入主标题');
                //	return;
                //}
                //if(typeof(subTitle) =="undefined"||subTitle==""){
                //	alert('请输入副标题');
                //	return;
                //}
	        //}
			
	
			
			if(checkAddPrice() == true){
                $.alert("门店和其他分销不适用于酒店结算百分比加价",function(){
                   $("#distributorIds_10").removeAttr("checked");
                   $("#distributorIds_20").removeAttr("checked");
                   $("#distributorUserIds_0").removeAttr("checked");
                });
                return;
			}
			
			//验证
			var flag1;
			var flag2;
			var bFormValidation = $("#dataForm").validate({
				rules : {
	                productName : {
	                    isChar : true
	                },
	                suppProductName: {
	                    isChar : true
	                },
	                jjDestDay:{
	                	isChar : true
	                },
	                jjTitle:{
	                	isChar : true
	                }
	            },
	            messages : {
	                productName : '不可输入特殊字符',
	                suppProductName: '不可输入特殊字符',
	                jjDestDay:'不可输入特殊字符',
	                jjTitle:'不可输入特殊字符'
	            }
				}).form();
			var filialeName = $("select.filialeCombobox").combobox("getValue");
			if(!filialeName) {
				var $combo = $("select.filialeCombobox").next();
				$("i[for=\"FILIALE\"]").remove();
				$combo.css('border-color', "red");
				$("<i for=\"FILIALE\" class=\"error\">该字段不能为空</i>").insertAfter($combo);
			}

			if(!bFormValidation || !filialeName) {
				flag1 = false;
			}
			if(!$("#reservationLimitForm").validate().form()){
				flag2 = false;
			}
			if(flag1==false || flag2==false){
				return false;
			}
			
			if(!validateSensitiveVad()){
		        return false;
		    }
			
			var msg = '确认修改吗 ？';	
			 if(refreshSensitiveWord($("input[type='text'],textarea"))){
			 	 $("input[name=senisitiveFlag]").val("Y");
			 	msg = '内容含有敏感词,是否继续?'
			 }else {
				$("input[name=senisitiveFlag]").val("N");
			}

			var hasProdTraffic = $("input[traffic=traffic_flag]:checked").val();
        	$("#hasProdTraffic").val(hasProdTraffic);

			$.confirm(msg, function () {
			
			$("#cancelFlag").removeAttr("disabled");
			
			var loading = top.pandora.loading("正在努力保存中...");
			//设置附加属性的值
			refreshAddValue();
			
			var trafficFlag = $("input[traffic=traffic_flag]:checked");
			var parameter = $("#dataForm").serialize()+"&"+$("#reservationLimitForm").serialize();
            if($("input[name='bizCategoryId']").val() == 15 && trafficFlag.attr("disabled") == 'disabled'){
                parameter += "&"+trafficFlag.attr('name')+"="+trafficFlag.val();
            }
			
			//20160608   panyu
            var categoryId = $("input[name='bizCategoryId']").val(); //品类id (跟团游->15 自由行->18 当地有->16)
            var productType = $("input[name='productTypeTD']:checked").val(); //类别 (跟团游：(国内短线：'INNERSHORTLINE', 国内长线:'INNERLONGLINE') 非跟团游：(国内：'INNERLINE'),出境：'FOREIGNLINE')
			var packageType = $("input[name='packageTypeTD']:checked").val(); //打包类型（自主打包：'LVMAMA',供应商打包：'SUPPLIER'）
			var isTraffic = $("input[traffic='traffic_flag']:checked").val(); //是否为大交通（是:'Y',否：'N'）
            //如果 自由行 （机+酒）修改类别为“国内”且打包类型为“自主打包”且“是否含有大交通”属性为“是”"自动打包交通" 设置不可修改   panyu 20160519
			//var autopack = $("input[autopack=auto_pack_traffic]:checked");
			//if(categoryId==18 && packageType =='LVMAMA' && isTraffic == 'Y'&& productType == 'INNERLINE' && autopack.attr("disabled") == 'disabled'){
				//parameter += "&"+autopack.attr('name')+"="+autopack.val();
            //}
            
            if(typeof(subTitle) !="undefined"&&subTitle!=null){
                	var packTitle = promTitle + "#"+ mainTitle + "#" + subTitle;
                	var title = encodeURI(packTitle).replace(/\+/g, '%2B');
                	parameter += "&packTitle="+title;
            }
          
			$.ajax({
				url : "/vst_admin/packageTour/prod/product/updateProduct.do",
				type : "post",
				dataType : 'json',
				data : parameter,
				success : function(result) {
					loading.close();
					$.alert(result.message);
					$("#route",parent.document).parent("li").trigger("click");
				},
				error : function(result) {
					loading.close();
					$.alert(result.message);
				}
			});
			});
	});

    isView();
});

function showAddFlagSelect(params,index){
	$(params).next().remove();
	if($(params).find("option:selected").attr('addFlag') == 'Y'){
		$(params).after("<input type='text' style='width:120px' data='"+$(params).val()+"' alias='prodProductPropList["+index+"].addValue' remark='remark'>");
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

var dests = [];//子页面选择项对象数组
var count = $("input[name=dest]").size();
var markDest;
var markDestId;
var spanId;


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
        $("#"+markDest).val(params.destName + "[" + params.destType + "]");
        $("#"+markDestId) .val(params.destId);
        if(params.parentDest==""){
        //alert("空");
         $("#"+spanId).html("");
        }else{
        //alert("非空");
        $("#"+spanId).html("上级目的地："+params.parentDest);
       }
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
	if(${prodProduct.subCategoryId}!=181){
		$tbody.append("<tr><td><input type='text' class='w35' name='dest' id='dest"+size+"' readonly = 'readonly' required/>"+
		"<input type='hidden' name='prodDestReList["+size+"].destId' id='destId"+size+"'/>"+
	                        "<input type='hidden' name='prodDestReList["+count+"].reId'	 id='reId"+count+"'/>"+
	                        "<input type='hidden' name='prodDestReList["+count+"].productId' id='productId"+count+"'/>"+
	                        "<a class='btn btn_cc1' name='del_button'>删除</a>"+
	                        "<span type='text' id='spanId_"+count+"'></span></td></tr>");
     }else{
          //alert("这里不用显示上级目录！！！");
          $tbody.append("<tr><td><input type='text' class='w35' name='dest' id='dest"+size+"' readonly = 'readonly' required/>"+
		"<input type='hidden' name='prodDestReList["+size+"].destId' id='destId"+size+"'/>"+
	                        "<input type='hidden' name='prodDestReList["+count+"].reId'	 id='reId"+count+"'/>"+
	                        "<input type='hidden' name='prodDestReList["+count+"].productId' id='productId"+count+"'/>"+
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
//alert(${prodProduct.subCategoryId});
	markDest = $(this).attr("id");
	markDestId = $(this).next().attr("id");
	spanId=$(this).next().next().next().next().next().attr("id");
	var url = "/vst_admin/biz/dest/selectDestList.do?type=main";
	destSelectDialog = new xDialog(url,{},{title:"选择目的地",iframe:true,width:"1000",height:"600"});
});
	
//产品类别选择
$("input[name=productTypeTD]").live("change",function(){

	var addtion=$("input[traffic=traffic_flag]:checked").val();
	if(typeof(addtion) == "undefined"){
		addtion="";
	}
	showRequire($("input[name='bizCategoryId']").val(),$("input[name=productTypeTD]:checked").val(),addtion);
	
	$("input[name=productType]").val($("input[name=productTypeTD]:checked").val());
});
	
$("input[traffic=traffic_flag]").live("change",function(){
	//只有自由行的时候才需要判断大交通
	if($("input[name='bizCategoryId']").val()==18 && $("input[name=productTypeTD]:checked").val()=="INNERLINE"){
		var addtion=$("input[traffic=traffic_flag]:checked").val();
		showRequire($("input[name='bizCategoryId']").val(),$("input[name=productTypeTD]:checked").val(),addtion);
	}
});	
              
 
refreshSensitiveWord($("input[type='text'],textarea"));

$("input[name=packageType]").click(function(){
		var val = $(this).val();
		if(val=="SUPPLIER"){
			$("#reservationLimit").show();
		}else if(val=="LVMAMA"){
			$("#reservationLimit").hide();
		}
});

vst_pet_util.superUserSuggest("#managerName", "input[name=managerId]");

var categoryId = $("input[name='bizCategoryId']").val();

//打开选择归属地窗口
$("input[name=attributionName]").bind("click",function(){
	markDest = $(this).attr("id");
	markDestId = $(this).next().attr("id");
	var url = "/vst_admin/biz/attribution/selectAttributionList.do";
	destSelectDialog = new xDialog(url,{},{title:"选择归属地",iframe:true,width:"1000",height:"600"});
});


if(categoryId == 15){
    var traffic = $("input[traffic=traffic_flag]");
    var trafficFlag = $("input[traffic=traffic_flag]:checked").val();
    
    if(trafficFlag === 'Y') {
    	traffic.attr('disabled',true);
    }
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

$("input[name='prodProductSaleReList[0].saleType']").live("change", function(){
	var saleType = $(this).val();
	if(saleType == "PEOPLE") {
		if(!checkPeople()){
			restoreCopies();
			return;
		}
		showSaleTypeOfPeople();
	}else if(saleType == "COPIES") {
		showSaleTypeOfCopies();
	}
    showSaleReFangcha();
});

/**
 * 恢复按份
 */
function restoreCopies(){
	var adult =$("#adult").val();
	var child =$("#child").val();
	$("#copies").trigger("click");
	$("#adult").val(adult);
	$("#child").val(child);
}

/**
 * 检查份切换人不满足条件
 */
function checkPeople(){
//	var bu =$("select[name=bu]").val() == 'DESTINATION_BU';//bu
//	if(!bu){
//		alert("请选择【目的地事业部】BU");
//		return false;
//	}
	var isPackageGroupHotel = $("#isPackageGroupHotel").val();
	//酒店套餐
	if(isPackageGroupHotel == 'true'){
		alert("打包了酒店套餐按份售卖的产品不能切换成按人售卖");
		return false;
	}
	return true;
}

function showSaleTypeOfPeople() {
	$("#copiesValue").hide();
	$("#custom").hide();
	$("#adult").val("1");
	$("#child").val("0");
}

function showSaleTypeOfCopies() {
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
	var productTypeRadio = $("input[name=productTypeTD]");
	if(productTypeRadio == null || productTypeRadio == 'undefined') {
		return false;
	}
	var productType = $("input[name=productTypeTD]:checked").val() == 'INNERLINE';
	var packageType = $("input[name=packageTypeTD]:checked").val() == "LVMAMA";
	var tracffic = $("input[traffic=traffic_flag]:checked").val() == 'N';
	
	return 	showSaleTypeBool == "YES" && productType && packageType && tracffic;
}

/**
* 当页面加载完毕之后,判断是否显示按份售卖,如果显示则设置对应的值
*/
function showOrHideSaleTypeOnLoadPage() {
	if(isShowSaleType()) {
		$("#saleType").show();
		setSaleTypeValueOnLoadPage();
	}else {
		$("#saleType").hide();
	}
}

var saleType = '${(prodProduct.prodProductSaleReList[0].saleType)!0}';
var adult = ${(prodProduct.prodProductSaleReList[0].adult)!0};
var child = ${(prodProduct.prodProductSaleReList[0].child)!0};

function setSaleTypeValueOnLoadPage() {
	if($("#prodSaleTypeId").val() == '') {
		$("#people").attr("checked", "checked");
		showSaleTypeOfPeople();
		return;
	}
	if(saleType == 'PEOPLE') {
		$("#people").attr("checked", "checked");
		showSaleTypeOfPeople();
	}else if(saleType == 'COPIES') {
		$("#copies").attr("checked", "checked");
		showSaleTypeOfCopies();
		//如果是当前是按份售卖则不能修改
		//$("#people").attr("disabled", "true");
		
		//如果是当前是按份售卖则不能修改是否大交通
		$("input[traffic=traffic_flag]:unchecked").attr("disabled", "true");
		$("input[traffic=traffic_flag]:unchecked").parent().css("background","#ddd");
		$("input[traffic=traffic_flag]:checked").parent().css("background","#ddd");
		if(adult == 2 && child == 0) {
			$("#adult").val("2");
			$("#child").val("0");
		  	$("#copiesValue").find("option[value='2-0']").attr("selected",true);
		}else if(adult == 2 && child == 1) {
			$("#adult").val("2");
			$("#child").val("1");
			$("#copiesValue").find("option[value='2-1']").attr("selected",true);
		}else if(adult == 1 && child == 1) {
			$("#adult").val("1");
			$("#child").val("1");
			$("#copiesValue").find("option[value='1-1']").attr("selected",true);
		}else {
			$("#custom").show();
			$("#adult").val(adult);
			$("#child").val(child);
			$("#copiesValue").find("option[value='0-0']").attr("selected",true);
		}
	}
//    showSaleReFangcha();
}

function showOrHideSaleType() {
	if(isShowSaleType()) {
		$("#saleType").show();
		$("#saleType").find("input[name^='prodProductSaleReList[0]']").removeAttr("disabled");
	}else {
		$("#saleType").hide();
		$("#saleType").find("input[name^='prodProductSaleReList[0]']").attr("disabled","disabled");
	}
}

function checkSaleTypeOnSave() {
	//国内游、自主打包且非大交通必须选择售卖方式
	if(isShowSaleType() && (saleType == null || saleType == '')) {
		alert("请选择售卖方式!");
		return false;
	}else {
		return true;
	}
}

function checkTrafficArrive(){
	//交通到达 判断是否 添加 提示信息
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
			$("#info_tip").css("display", "inline");
			return false;
		}else if(len-tipMsg.length -4 ==index){ //contain '<p>'
			return true;
		}else if(len-tipMsg.length -4 > index){
			//提示信息位置不正确,进行调整至最后一行
			if(value.substr(index+tipMsg.length,4) == "</p>"){
				$traffic_val.html(value.substring(0,index-3)+value.substr(index+tipMsg.length + 4)+"<p>" + tipMsg + "</p>");
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


function checkSaleCopiesParam() {
	var saleType = $("input[name='prodProductSaleReList[0].saleType']:checked").val();

    setFangchaValue();

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
	
	var propValue = $("#propValue").val();
	if(propValue != 'Y'){
	    showExistMuiltStartPintInput();//当页面加载完成时，判断是否显示多出发地按钮
	}
	
	$("input[traffic='traffic_flag']").live("click",function(){
		showExistMuiltStartPintInput();
	});
	
	//显示多出发地按钮（条件：1.所属品类自由行或跟团游  2.打包类型为自主打包  3.有大交通的）
	function showExistMuiltStartPintInput() {

		var categoryId = $("input[name='bizCategoryId']").val(); //品类id (跟团游->15 自由行->18 当地游->16)
		var packageType = $("input[name='packageTypeTD']:checked").val(); //打包类型（自主打包：'LVMAMA',供应商打包：'SUPPLIER'）
		var isTraffic = $("input[traffic='traffic_flag']:checked").val(); //是否为大交通（是:'Y',否：'N'）
		var currentMuiltDpartureFlag = $("#currentMuiltDpartureFlag").val(); //当前的产品是否为多出发地

		if ((categoryId == '15' || categoryId == '18') && packageType =='LVMAMA' && isTraffic == 'Y') {
		  
		  if("${prodProduct.subCategoryId}" == "184"&&"${prodProduct.productType}" == 'INNERLINE'){
		  }else{
			var muiltStartPintCheckedInput = '<input type="checkbox" id="isMultiStartPoint" name="muiltDpartureFlag" checked value="Y"/><span id="mulitStartPointLabel">是否为多出发地</span>';
			var muiltStartPintUnCheckedInput = '<input type="checkbox" id="isMultiStartPoint" name="muiltDpartureFlag" value="N"/><span id="mulitStartPointLabel">是否为多出发地</span>';
			if("${prodProduct.productType}" == 'INNERLINE' &&("${prodProduct.subCategoryId}" == "182" || "${prodProduct.subCategoryId}" == "183" )){
			   muiltStartPintCheckedInput = '<input type="checkbox" id="isMultiStartPoint" name="muiltDpartureFlag" checked value="Y"/><span id="mulitStartPointLabel">是否为多出发地&nbsp(提示：若勾选是否为多出发，则必须在“选择交通”模块中打包交通产品)</span>';
			   muiltStartPintUnCheckedInput = '<input type="checkbox" id="isMultiStartPoint" name="muiltDpartureFlag" value="N"/><span id="mulitStartPointLabel">是否为多出发地&nbsp(提示：若勾选是否为多出发，则必须在“选择交通”模块中打包交通产品)</span>';
			}

			if ($("#isMultiStartPoint").length == 0) { // 如果没有改元素
				if (currentMuiltDpartureFlag == 'Y') {
					$("#district").after(muiltStartPintCheckedInput);
					districtNotRequired();//如果为选中状态，出发地为非必填项
				} else {
					$("#district").after(muiltStartPintUnCheckedInput);
					districtRequired();//如果为未选中状态，出发地为必填项
				}
			}
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

//  --jQuery easy UI 初始化combobox--  //
$("select.filialeCombobox").combobox({
    multiple:false,
    width: 170,
    filter:function(q,row){
		var opts=$(this).combobox("options");
		return row[opts.textField].indexOf(q) > -1;
	},
	onHidePanel: function () {
		var filialeName = $(this).combobox("getValue");
		if(!!filialeName) {
			$(".combo").css('border-color', "#abc");
			$("i[for=\"FILIALE\"]").css("display", "none");
		}
	}
});


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
    var add_tj = "<tr class='lt-tj'><td class='e_label' width='150'></td><td><input type='text' name='productRecommends'  style='width:400px;' placeholder='输入产品推荐语，每句话最多输入30个汉字' data-validate=\"true\"  maxlength=\"30\"/><a class='lt-tj-delete-btn' href='javascript:;'>删除</a></td></tr>";
    var $addTj = $(add_tj);
    $addOneTJ.append($addTj);
    var $del = $addOneTJ.find(".lt-tj-delete-btn");

    $.each($del, function(index, item) {
      $(item).show();
    });

    $("input[name='productRecommends']").keyup(function() {
      valiateOldData(false, false);
    });
  });
    $addOneTJ.on("click", ".lt-tj-delete-btn", function() {
        $(this).parents(".lt-tj").remove();

        var $del = $addOneTJ.find(".lt-tj-delete-btn");

        $.each($del, function(index, item) {
                $(item).show();
        });
        valiateOldData(false, false);

    });

 
  $("#editOldData").css("display", "none");
  valiateOldData(false, true);
  $("input[name='productRecommends']").keyup(function() {
    valiateOldData(false, false);
  });

  $("#editOldData").click(function() {
    var $proRecommend = $(".addOne_tj").find("input[name='productRecommends']");
    $("#editOldData").css("display", "none");
    $("#editOldDataHidden").attr("value", "true");
    $(".lt-tj-delete-btn").css("display", "");
    $(".lt-add-tj-btn").css("display", "");
    $proRecommend.each(function() {
      var $this = $(this);
      $this.removeAttr("readonly");
      $this.attr("data-validate", true);
    });

  });   
  
  $("input:radio[name=productOrigin]").click(function(){

		if($("input[name=productOrigin]:checked").val()==""){
				$("#trTitle1").show();
				$("#trTitle2").show();
				$("#trTitle3").show();
				//$("input[name='productName']").val("");
//				$("#trProduct").hide();
		}else{
			//$("input[name='promTitle']").val("");
			//$("input[name='mainTitle']").val("");
			//$("input[name='subTitle']").val("");
			$("#trTitle1").hide();
			$("#trTitle2").hide();
			$("#trTitle3").hide();
			$("#trProduct").show();
		}
	});
  
  var $promAdd = $("#promAdd");

  var add_tj = "<label><input type='text' class='w35' style='width:700px' name=\"promTitle\" id=\"promTitle\" value=\"${promTitle!''}\"  maxlength='10' disabled></label>";
  var $addProm = $(add_tj);
  
  $("#promGeneration").click(function(){
  		
  		var productId = ${prodProduct.productId};
  		$.ajax({
  				url : "/vst_admin/packageTour/prod/title/generatePromInfo.do",
				type : "post",
				dataType : 'json',
				data : {"productId":productId},
				success : function(result) {
				 	if(!result.success){
				 		//$.alert(result.message);
				 		$.alert("此功能暂未开放.");
				 		$promAdd.append($addProm);
				 	}else{
				 		$promAdd.append($addProm);
					 	var title = result.attributes.promPromotion.title;
					 	var nostr = result.attributes.promPromotion.instrs;
					 	var prom = "";
					 	if(nostr==null){
					 		prom = title;
					 	}else{
					 		prom = title + "-" +  nostr;
					 	}
						//$("#promTitle").val(prom);
						//parent.refreshIframeMain("/vst_prom/prom/promotion/showAddPreferentialSchemes.do?promPromotionId="+result.attributes.promPromotionId+"&promResultId="+result.attributes.promResultId);
				 	}
				}
  		
  			  });
  });
  
  $("#promUpdate").click(function(){
  		
  		var productId = ${prodProduct.productId};
  		$.ajax({
  				url : "/vst_admin/packageTour/prod/title/generatePromInfo.do",
				type : "post",
				dataType : 'json',
				data : {"productId":productId},
				success : function(result) {
				 	if(!result.success){
				 		//$.alert(result.message);
				 		$.alert("促销标题功能暂未开放.");
				 	}else{
					 	var title = result.attributes.promPromotion.title;
					 	var nostr = result.attributes.promPromotion.instrs;
					 	var prom = "";
					 	if(nostr==null){
					 		prom = title;
					 	}else{
					 		prom = title + "-" +  nostr;
					 	}
						//$("#promTitle").val(prom);
						//parent.refreshIframeMain("/vst_prom/prom/promotion/showAddPreferentialSchemes.do?promPromotionId="+result.attributes.promPromotionId+"&promResultId="+result.attributes.promResultId);
				 	}
				}
  		
  			  });
  });
  
  var $mainAdd = $("#mainAdd");

  var add_main = "<label><input type='text' class='w35' style='width:700px' name=\"mainTitle\" id=\"mainTitle\" value=\"${mainTitle!''}\"  maxlength='70'></label>";
  var $addMain = $(add_main);
  
  $("#mainGeneration").click(function(){
  		var productId = ${prodProduct.productId};
  		$.ajax({
  				url : "/vst_admin/packageTour/prod/title/generateMainTitleInfo.do",
				type : "post",
				dataType : 'json',
				data : {"productId":productId},
				success : function(result) {
				 	if(!result.success){
				 		$.alert(result.message);
				 		$mainAdd.append($addMain);
				 	}else{
				 		$mainAdd.append($addMain);
				 		//alert(result.message);
				 		//$.alert(result.message);
					 	$("#mainTitle").val(result.message);
						//parent.refreshIframeMain("/vst_prom/prom/promotion/showAddPreferentialSchemes.do?promPromotionId="+result.attributes.promPromotionId+"&promResultId="+result.attributes.promResultId);
				 	}
				}
  		
  			  });
  });
  
  $("#mainUpdate").click(function(){
  		var productId = ${prodProduct.productId};
  		$.ajax({
  				url : "/vst_admin/packageTour/prod/title/generateMainTitleInfo.do",
				type : "post",
				dataType : 'json',
				data : {"productId":productId},
				success : function(result) {
				 	if(!result.success){
				 		$.alert(result.message);
				 	}else{
				 		//alert(result.message);
				 		//$.alert(result.message);
					 	$("#mainTitle").val(result.message);
						//parent.refreshIframeMain("/vst_prom/prom/promotion/showAddPreferentialSchemes.do?promPromotionId="+result.attributes.promPromotionId+"&promResultId="+result.attributes.promResultId);
				 	}
				}
  		
  			  });
  });

    
});

function valiateOldData(errorFlag, readFlag) {
    //自定义验证老产品经理推荐数据
    var $addOneTJ = $(".addOne_tj");
    var $error = $addOneTJ.find('tr.errorTr');
    var flag = true;
    var $proRecommend = $addOneTJ.find("input[name='productRecommends']");
    if ($proRecommend.length > 3 && $("#editOldDataHidden").val() == "true") {
        setValiateRecommend(readFlag, $error, errorFlag, $proRecommend,$addOneTJ );
        return false;
    }
    $proRecommend.each(function() {
        var $this = $(this);
        var inputValue = $this.val();
        if (inputValue.length > 30 && $("#editOldDataHidden").val() == "true") {
            setValiateRecommend(readFlag, $error, errorFlag, $proRecommend,$addOneTJ );
            flag = false;
            return false;
        }
    });

    if (flag) {
        $error.each(function() {
            $(this).remove();
        });
    }
    return flag;
}

function setValiateRecommend(readFlag,$error,errorFlag,$proRecommend,$addOneTJ) {
    if (readFlag) {
        $("#editOldData").css("display", "");
        $(".lt-tj-delete-btn").css("display", "none");
        $(".lt-add-tj-btn").css("display", "none");
        $("#editOldDataHidden").attr("value", "false");
        $proRecommend.each(function() {
            var $this = $(this);
            $this.attr("readonly", "readonly");
            $this.attr("data-validate", false);

        });
    }
    if ($error.length == 0 && errorFlag) {
        $("<tr class=\"lt-tj errorTr\"><td></td><td class=\"error\">不满足录入规范(每条最多30个汉字，最多3条)</td><tr>").appendTo($addOneTJ);

    }
}

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
$(function () {
    showSupplierPackageMuiltStartPintInput();
    //初始化供应商多出发地
	initSupplierPackageMuiltStartPintInput();
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
    var productType = $("input[name='productType']").val();
    var packageType = $("input[name='packageType']").val();
    var categoryId = $("input[name='bizCategoryId']").val();
    var subCategoryId = $("input[name='subCategoryId']").val();

    if (((categoryId == '15' || (categoryId == '18'&&(subCategoryId=='181'||subCategoryId=='182'||subCategoryId=='183'))) && packageType =='SUPPLIER'&&productType=='FOREIGNLINE')) {
        //初始化供应商出发地的数据
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
function initSupplierPackageMuiltStartPintInput() {
    var productType = $("input[name='productType']").val();
    var packageType = $("input[name='packageType']").val();
    var categoryId = $("input[name='bizCategoryId']").val();
    var subCategoryId = $("input[name='subCategoryId']").val();

    if (((categoryId == '15' || (categoryId == '18'&&(subCategoryId=='181'||subCategoryId=='182'||subCategoryId=='183'))) && packageType =='SUPPLIER'&&productType=='FOREIGNLINE')) {
        //初始化供应商出发地的数据
        var startDistricts = '${startDistricts}';
        var isMuiltDeparture = '${prodProduct.isMuiltDeparture}';
        var startDistrictIds = '';
        var citysHtml = '';
        if (startDistricts) {
            var startDistrictsJson = $.parseJSON(startDistricts);
            for (var i = 0; i < startDistrictsJson.length; i++) {
                var districtId = startDistrictsJson[i].districtId;
                var districtName = startDistrictsJson[i].districtName;
                startDistrictIds += districtId + ',';
                citysHtml += '<div class="city"><span>' + districtName + '</span><span data="' + districtId + '">X</span></div>';
            }
        }
        if (startDistrictIds) {
            startDistrictIds = startDistrictIds.substring(0, startDistrictIds.length - 1);
            $('#multiToStartPointIds').val(startDistrictIds);
        }
        if (isMuiltDeparture == 'Y') {
            $('#isMuiltDpartureInput').attr('checked', 'checked');
            districtNotRequiredSupplier();
            $('#isMuiltDpartureDiv').html(citysHtml);
        } else {
            districtRequiredSupplier();
        }
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