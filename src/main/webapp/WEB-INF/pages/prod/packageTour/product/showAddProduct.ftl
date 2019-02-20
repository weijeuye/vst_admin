<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
<link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/channel/custom/v1/component-chosen.css">
<#include "/base/findProductInputType.ftl"/>
<#include "/base/BuGenerator.ftl"/>

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
        <input type="hidden" name="senisitiveFlag" value="N">
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
                                    <input type="radio" name="productType" value="${list.code!''}" required/>  ${list.cnName!''}
								</#if>
							</#list>
                            <span class="info-dd-note info-category-note1" >注意：选择产品类别并保存后，不可更改</span>
                            <span class="info-dd-note info-category-note2">请删除当前产品名称再修改产品类别</span>
                            <!-- categoryId=16 当地游-->
						<#elseif bizCategory.categoryId == '16'>
							<#list productTypeList as list>
								<#if list.code != 'INNERLINE' && list.code != 'INNER_BORDER_LINE'>
                                    <input type="radio" name="productType" value="${list.code!''}" required/>  ${list.cnName!''}
								</#if>
							</#list>
                            <span class="info-dd-note info-category-note1" >注意：选择产品类别并保存后，不可更改</span>
                            <span class="info-dd-note info-category-note2">请删除当前产品名称再修改产品类别</span>
						<#else>
							<#list productTypeList as list>
								<#if list.code != 'INNERSHORTLINE' && list.code != 'INNERLONGLINE' && list.code != 'INNER_BORDER_LINE'>
                                    <input type="radio" name="productType" value="${list.code!''}" required/>  ${list.cnName!''}
								</#if>
							</#list>
						</#if>

                            <div id="productTypeError"></div>
                        </td>
                    </tr>

					<#if bizCategory.categoryId == '15' || bizCategory.categoryId == '16'>
                    <tr>
                        <td class="e_label"><i class="cc1">*</i>行程类别：</td>
                        <td>
                            <input type="radio" name="producTourtType" value="ONEDAYTOUR" required/> 一日游&nbsp;&nbsp;
                            <input type="radio" name="producTourtType" value="MULTIDAYTOUR" required/> 多日游
                            <span class="tourclass">注意：选择产品行程类别并保存后，不可更改</span>
                        </td>
                    </tr>
					</#if>

                    <tr>
                        <td class="e_label"><i class="cc1">*</i>产品名称：</td>
					<#if bizCategory.categoryId == '16'||bizCategory.categoryId == '15' >
                        <td class="lt-product-name-td">
                            <a href="javascript:;" class="lt-add-name-btn lt-link-disabled">添加名称</a>
                            <input type="hidden" class="JS_hidden_main_product_name required" id="productName" name="productName" required=true>
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
                    <#elseif bizCategory.categoryId == '17'  >
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
                    	<td id="zyxJjCj" style="display:none;" disabled>
                            <label><input type="text" class="w35" style="width:700px" name="productName" id="productName" required=true maxlength="100">&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||"</label>
                            <div id="productNameError"></div>
                        </td>
					<#else>
                        <td>
                            <label><input type="text" class="w35" style="width:700px" name="productName" id="productName" required=true maxlength="100">&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||"</label>
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
                            <select name="filiale" class="filialeCombobox" id="filiale">
                                <option value="">请选择</option>
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
			                	<option value=${list.code!''}>${list.cnName!''}</option>
				            </#list>
					    	</select>-->
					    	<#--http://ipm.lvmama.com/index.php?m=story&f=view&t=html&id=12992-->
					    	<@BuGenerator buList "" bizCategory.categoryId ""/>
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
                                <option class="group_agreement" value="COMMISSIONED_SERVICE_AGREEMENT">委托服务协议</option>
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
								<#if companyTypeMap??>
									<#list companyTypeMap?keys as key>
							  			<option value="${key}"<#if key == "XINGLV" >selected="selected"</#if> >${companyTypeMap[key]}</option>
								  	</#list>
							  	</#if>
							  	</select>
	                        </td>
	                    </tr>
                    -->
            <tr class="prod_groupMode" style="display:none">
                <td class="e_label" width="150"><i class="cc1">*</i>出团模式：</td>
                <td>
                    <input type="radio" name="prodEcontract.groupMode" value="COMMON_GROUP" data-validate="true" required="" />常规跟团游&nbsp;
                    <input type="radio" name="prodEcontract.groupMode" value="NOLEADER_GROUP" data-validate="true" required="" />无领队小团&nbsp;
                    <input type="radio" name="prodEcontract.groupMode" value="PARENTAGE_GROUP" data-validate="true" required="" />亲子游学&nbsp;
                </td>
            </tr>
            </table>
        </div>
</div>

<!-- 条款品类属性分组Id -->
<#assign suggGroupIds = [26,27,28,29,30,31,32,33]/>
<input type="hidden" id="minOrderQuantityCheck">
<input type="hidden" id="operationCategoryCheck">
<div class="p_box box_info p_line">
<#assign index=0 />
<#assign productId="" />
<#list bizCatePropGroupList as bizCatePropGroup>
	<#if (!suggGroupIds?seq_contains(bizCatePropGroup.groupId)) && bizCatePropGroup.bizCategoryPropList?? && (bizCatePropGroup.bizCategoryPropList?size gt 0)>
        <div class="title">
            <h2 class="f16"><#if bizCatePropGroup.groupId == 106> <#else>${bizCatePropGroup.groupName!''}：</#if> </h2>
        </div>
        <div class="box_content">
            <table class="e_table form-inline">
                <tbody>
					<#if bizCatePropGroup.groupId == 14>
                    <tr class="min_order_quantity" style="display:none">
                        <td class="e_label" width="150"><i class="cc1">*</i>最小起订份数（成人）：</td>
                        <td><input type="text" name="minOrderQuantity" id="minOrderQuantity" style="width:200px;" data-validate="true" maxlength="3" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,'');}).call(this)" onblur="this.v();" /></td>
                    </tr>
					</#if>
					<#if bizCatePropGroup.groupId == 14 || bizCatePropGroup.groupId == 17>
                    <tr  class="operation_category" style="display:none">
                        <td class="e_label" width="150"><i class="cc1">*</i>运营类别：</td>
                        <td>
                            <input type="radio"    name="operationCategory" id="operationCategory"  value="LONGGROUP" ><#if bizCategory.categoryId == 15>长线跟团游<#else>长线当地游</#if>
                            <input type="radio"    name="operationCategory" id="operationCategory"  value="SHORTGROUP"><#if bizCategory.categoryId == 15>短线跟团游<#else>短线当地游</#if>
                        </td>
                    </tr>

					</#if>
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
                                                <td><input type="text" name="productRecommends" class="textWidthPro" style="width:400px;" placeholder="输入产品推荐语，每句话最多输入30个汉字" data-validate="true"  maxlength="30"/>
                                                </td>
                                            </tr>
											</#list>
                                        <input type="hidden" name="prodProductPropList[${index}].propId" value="${bizCategoryProp.propId!''}"/>
                                        <input type="hidden" name="prodProductPropList[${index}].bizCategoryProp.propCode" value="${bizCategoryProp.propCode!''}"/>
                                        <input type="hidden" id="proRecommendHidden" name="prodProductPropList[${index}].propValue"  value="" />
                                        </tbody>
                                    </table>
                                    <p class="add_one_word"><a class="lt-add-tj-btn" style="margin-left:150px;" href="javascript:;">增加一条</a></p>
                                    <p  style="color:grey;margin-left:150px;">注：最少2到3条，最多4条</p>
                                </td>
                            </tr>
								<#assign index=index+1 />
							<#else>

								<#if bizCategoryProp.propCode!='feature'>
                                <tr <#--<#if bizCategoryProp.propId?? && bizCategoryProp.propId==565 >style="display:none;"</#if>-->>
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
							</#if>
						<#else>
                        <tr <#--<#if bizCategoryProp.propId?? && bizCategoryProp.propId==565 >style="display:none;"</#if>-->>
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
                    <!-- 获取自动打包交通属性，是否选择是选项 -->
						<#if bizCategoryProp.propCode == "auto_pack_traffic">
							<#if bizCategoryProp.prodProductPropList?? && bizCategoryProp.prodProductPropList?size gt 0>
								<#list bizCategoryProp.prodProductPropList as prodProductProp>
									<#if prodProductProp.propValue?? && "Y" == prodProductProp.propValue>
                                    <input type="text" id="propValue" value="${prodProductProp.propValue}">
									</#if>
								</#list>
							</#if>
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
            <tr id="districtTr">
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
				<#if bizCategory.categoryId!=17>
                    <span type= "text" id="spanId_0" ></span>
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



<#if bizCategory.categoryId == '16'||bizCategory.categoryId == '15' ||bizCategory.categoryId == '17' >
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
    .tourclass { color: red; display: none; vertical-align: top;}
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

<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/kindeditor.js"></script>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/plugins/image/image.js"></script>
<script type="text/javascript" src="/vst_admin/js/contentManage/kindEditorConf.js?v1"></script>

<script type="text/javascript" src="/vst_admin/js/prod/packageTour/product/autoPackCheck.js"></script>
<script type="text/javascript" src="/vst_admin/js/prod/packageTour/chosen-jquery.js?v1"></script>
<script  type="text/javascript">
$(function(){
$(document).ready(function () {
	<#if bizCategory.categoryId == 17>
		window.SPECIAL_PROCESS_KEY_13 = true;
	</#if>
		//初始化
//		$('.form-control-chosen').chosen({
//            allow_single_deselect: true,
//            no_results_text: "没有找到",
//           max_selected_options:10,
//            placeholder_text_single:'1e',
//            width: '100%'
//        });
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
                    content += hotelAddNote;
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
			jsFromHotelText = jsFromHotelText.substring(0, jsFromHotelText.length-1);
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
			
			<#if bizCategory.categoryId == 17>
			var	maxNameLength = 70;
			<#else>
			var maxNameLength = 200;
			</#if>
			if(name.length>maxNameLength){
				alert("产品名称长度不能超过" + maxNameLength)
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
        }else{
            $("select[name='productGrade']").removeAttr("disabled");
            hideGroupSettleFlag();
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
            var packageType = $("input[name=packageType]:checked").val();
            if("SUPPLIER"==packageType){
                $("#cc1").hide();
                $("#input_groupSupplierName").attr("readonly","readonly");
            }
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

    //“最小起订份数”显示或隐藏
    $("input:radio[name='productType']").change(function(){
        var prodType = $("input:radio[name='productType']:checked").val();
        var categoryId = $("#categoryId").val();
        if(prodType == "INNERSHORTLINE" || prodType == "INNERLONGLINE"
                || prodType == "INNER_BORDER_LINE" || prodType == "INNERLINE" || prodType=="FOREIGNLINE") {
            if(categoryId == "15"){
                $(".min_order_quantity").show();
                $("#minOrderQuantityCheck").val("Y");
            }
            if(categoryId == "15" || categoryId == "16"){
                $(".operation_category").show();
                $("#operationCategoryCheck").val("Y");
            }
            //如果国内跟团游、自主打包，“是否有大交通”可选择
            var packageType = $("input[name=packageType]:checked").val();
            var traffic = $("input[traffic=traffic_flag]");
            traffic.val(['Y']);
            if (categoryId == '15' && "LVMAMA"==packageType){
                traffic.removeAttr("disabled");
            } else {
                traffic.attr("disabled",true);
            }
        }
        else {
            $(".min_order_quantity").hide();
            $(".operation_category").hide();
            $("#minOrderQuantityCheck").val("N");
            //出境跟团游，“是否有大交通”不能修改
            var traffic = $("input[traffic=traffic_flag]");
            traffic.val(['Y']);
            traffic.attr("disabled",true);
        }
    });

    //运营类型的隐藏 显示
    $("input:radio[name='producTourtType']").click(function(){
        var producTourtType = $("input:radio[name='producTourtType']:checked").val();//行程类别
        var prodType = $("input:radio[name='productType']:checked").val();
        var categoryId = $("#categoryId").val();
        if((categoryId == "15" || categoryId == "16") &&
                (prodType == "INNERSHORTLINE" || prodType == "INNERLONGLINE"
                || prodType == "INNER_BORDER_LINE" || prodType == "INNERLINE")) {
            $(".operation_category").show();
            $("#operationCategoryCheck").val("Y");
        }else{
            $(".operation_category").hide();
            $("#operationCategoryCheck").val("");
        }
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

    //如果国内跟团游、自主打包，返回true
    function isInnerTour() {
        var ret = false;
        var categoryId = $("#categoryId").val();
        var packageType = $("input[name=packageType]:checked").val();
        if (categoryId == '15' && "LVMAMA"==packageType) {
            var productType = $("input[name='productType']:checked").val();
            if(!productType){
                productType="";
            }
            if(productType.indexOf("INNERLINE")!=-1 || productType.indexOf("INNERSHORTLINE")!=-1 || productType.indexOf("INNERLONGLINE")!=-1 || productType.indexOf("INNER_BORDER_LINE")!=-1){
                ret= true;
            }
        }
        return ret;
    }

    //交通按钮切换
    $("input[traffic=traffic_flag]").click(function(){
        var that = $(this);
        if(that.attr("checked")=="checked"){
            if(that.val()=="N"){
                if(!isInnerTour()){
                    $("#districtTr").hide();
                    $("#district").hide();
                    $("#district").val(null);
                    $("#districtId").val(null);
                }
            }else if(that.val()=="Y"){
                $("#districtTr").show();
                $("#district").show();
            }
        }
    });

    //修改类型后弹出提示信息
    $("input:checkbox[data=propId_leixing]").live("click",function(){
        var $that = this;
        if(this.checked){
            this.checked = false;
            var data2 = $(this).attr("data2");
            if(data2 == "私享团"){
                $("input:checkbox[data=propId_leixing]").each(function(){
                    this.checked = false;
                });
            }else{
                $("input:checkbox[data=propId_leixing]").each(function(){
                    if($(this).attr("data2") == "私享团"){
                        this.checked = false;
                    }
                });
            }

            if(data2 == "逍遥驴行"){
                $.alert("逍遥驴行仅支持目的地事业部的国内产品，请先创建相应产品");
                return;
            }

            $.confirm("你好，将产品勾选为“"+$(this).attr("data2")+"”系列，需与产品运营部沟通，确认本产品符合“"+$(this).attr("data2")+"”的八项标准，若未经批准擅自勾选，所引起的一切顾客投诉纠纷或赔偿责任由产品经理承担，我们也会定期拉取“"+$(this).attr("data2")+"”产品清单和查询后台操作日志予以监控。",function(){
                $that.checked = true;
            });

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

 //       var productNameVal = $("#productName").val();
  //      if(typeof(productNameVal) =="undefined"||productNameVal==""){
 //           alert('请填写产品名称！');
 //           return;
 //       }
        var radioArray = $('input[name=producTourtType]');
        if(radioArray != null && radioArray.length > 0){
            var val=$('input:radio[name="producTourtType"]:checked').val();
            if(val == null){
                alert('请选择行程类别！');
                return;
            }
        }
        if(checkMinOrderQuantity() == false){
            alert('请填写最小起订份数（成人）！');
            $("#minOrderQuantity").focus();
            return;
        }
        if(checkOperationCategory() == false){
            alert('请勾选运营类别！');
            return;
        }

        var flag1;
        var flag2;
        var bFormValidation = $("#dataForm").validate({
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
        }).form();
        var filialeName = $("select.filialeCombobox").combobox("getValue");
        if(!filialeName) {
            var $combo = $("select.filialeCombobox").next();
            $("i[for=\"FILIALE\"]").remove();
            $combo.css('border-color', "red");
            $("<i for=\"FILIALE\" class=\"error\">该字段不能为空</i>").insertAfter($combo);
        }

        if(!bFormValidation || !filialeName) {
            $("#dataForm").removeAttr("disabled");
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
            if($("input[name='bizCategoryId']").val() == 15 && trafficFlag.attr("disabled") == 'disabled'){
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
                            if(parent.refreshProdFundLabel) {
                                parent.refreshProdFundLabel();
                            }

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

    function checkMinOrderQuantity(){
        if($("#minOrderQuantityCheck").val() == "Y"){
            var minOrderQuantity = $("#minOrderQuantity").val();
            if(typeof(minOrderQuantity) =="undefined"||minOrderQuantity==""){
                return false;
            }
        }
        return true;
    }

    //运营类别校验
    function checkOperationCategory(){
        if($("#operationCategoryCheck").val() == "Y"){
            var operationCategory = $("input:radio[name='operationCategory']:checked").val();//运营类别
            if(typeof(operationCategory) =="undefined"||operationCategory==""){
                return false;
            }
        }
        return true;
    }

    $("#saveAndNext").click(function(){
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

   //     var productNameVal = $("#productName").val();
 //       if(typeof(productNameVal) =="undefined"||productNameVal==""){
 //           alert('请填写产品名称！');
//            return;
//        }

        var radioArray = $('input[name=producTourtType]');
        if(radioArray != null && radioArray.length > 0){
            var val=$('input:radio[name="producTourtType"]:checked').val();
            if(val == null){
                alert('请选择行程类别！');
                return;
            }
        }
        if(checkMinOrderQuantity() == false){
            alert('请填写最小起订份数（成人）！');
            $("#minOrderQuantity").focus();
            return;
        }

        if(checkOperationCategory() == false){
            alert('请勾选运营类别！');
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
            if($("input[name='bizCategoryId']").val() == 15 && trafficFlag.attr("disabled") == 'disabled'){
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
                        $("#packageType",window.parent.document).val(result.attributes.packageType);
                        //更新菜单
                        refreshTable();
                        if(parent.refreshProdFundLabel) {
                            parent.refreshProdFundLabel();
                        }
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
        if(${bizCategory.categoryId}!=17){
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
        //清除是否团结算选中状态
        $("input[value='group_settle_flag']").parent().find("input:radio").removeAttr('checked');

        //出境情况下取消勾选并隐藏私享团
        if("FOREIGNLINE" == $("input[name=productType]:checked").val()){
            $("input[data2='私享团']").attr("checked",false);
            $("input[data2='私享团']").hide();
            $("input[data2='私享团']").next().hide();
            showGroupSettleFlag();
            if("15" == $("#categoryId").val()){
//                $(".group_agreement").show();
                $(".prod_groupMode").show();
                $("input:radio[name='prodEcontract.groupMode']").each(function(){
                    $(this).attr("data-validate","true");
                    $(this).attr('required',"");
                });
            }
        }else{
            $("input[data2='私享团']").show();
            $("input[data2='私享团']").next().show();
            hideGroupSettleFlag();
            $("input:radio[name='prodEcontract.groupMode']").each(function(){
                $(this).removeAttr('data-validate');
                $(this).removeAttr('required');
            });
            $(".prod_groupMode").hide();
//            $(".group_agreement").hide();
        }

    });

    //监听行程类别发生改变
    $("input[name=producTourtType]").live("change",function(){
        $("span[class='tourclass']").show();
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

            $("#cc1").show();
            $("#input_groupSupplierName").removeAttr("readonly");
        }else{
            $("#buTr").hide();
            $("#attributionTr").hide();
            $("#bu").removeAttr("required");
            $("#attributionId").removeAttr("required");

            $("#tips").show();
            $("#cc1").hide();
            $("#input_groupSupplierName").attr("readonly","readonly");
        }
    });

    $("input[name=packageType]").click(function(){
        var val = $(this).val();
        if(val=="SUPPLIER"){
            $("#reservationLimit").show();
            $("#cc1").hide();
            $("#input_groupSupplierName").attr("readonly","readonly");
        }else if(val=="LVMAMA"){
            $("#reservationLimit").hide();
            $("#cc1").show();
            $("#input_groupSupplierName").removeAttr("readonly");
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
        $("input[name='productType']").live("click",function(){
            showExistMuiltStartPintInput();
        });
//	$("input[autopack='auto_pack_traffic']").live("click",function(){
//		showExistMuiltStartPintInput();
//	});

        $("input[name='packageType']").live("click",function(){
            showExistMuiltStartPintInput();
        });

        $("input[traffic='traffic_flag']").live("click",function(){
            showExistMuiltStartPintInput();
        });

        //显示多出发地按钮（条件：1.所属品类自由行或跟团游 2.打包类型为自主打包  3.有大交通的）
        function showExistMuiltStartPintInput() {

            var categoryId = $("input[name='bizCategoryId']").val(); //品类id (跟团游->15 自由行->18 当地有->16)
            //不对出境做屏蔽
            var packageType = $("input[name='packageType']:checked").val(); //打包类型（自主打包：'LVMAMA',供应商打包：'SUPPLIER'）
            var isTraffic = $("input[traffic='traffic_flag']:checked").val(); //是否为大交通（是:'Y',否：'N'）
//		var auto_pack_traffic = $("input[autopack=auto_pack_traffic]:checked").val();// 自动打包交通（是:'Y',否：'N'）

//(categoryId == '15' || categoryId == '18') && packageType =='LVMAMA' && isTraffic == 'Y' && auto_pack_traffic != 'Y'
            if (((categoryId == '15' || categoryId == '18') && packageType =='LVMAMA' && isTraffic == 'Y') || isInnerTour()) {
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

        //隐藏 基础信息中的 自动打包交通，是否使用被打包产品费用说明，被打包产品id，是否使用被打包产品行程明细    panyu 20160519
        $("input[value='auto_pack_traffic']").parent().parent().parent().hide();
        $("input[value='isuse_packed_cost_explanation']").parent().parent().parent().hide();
        $("input[value='packed_product_id']").parent().parent().parent().hide();
        $("input[value='isuse_packed_route_details']").parent().parent().parent().hide();

        //自动打包交通”默认选中"否"；如果选择“是”，显示“被打包产品ID”、“是否使用被打包产品行程明细”、“是否使用被打包产品费用说明”属性及供产品经理输入  panyu 20160519
//	$("input[autopack='auto_pack_traffic']").live("click",function(){
//		showPackedProductRouteInput();
//	});

        //当 “类型” 切换触发 下面的 是否显示  “自动打包交通”  panyu 20160519
        $("input[name='productType']").live("click",function(){
            checkedProductType();
        });

        //显示“被打包产品ID”、“是否使用被打包产品行程明细”、“是否使用被打包产品费用说明”属性    panyu 20160519
        function showPackedProductRouteInput(){
            var autoPackTraffic = $("input[autopack='auto_pack_traffic']:checked").val(); //自动打包交通（是:'Y',否：'N'）
            parent.isTraffic(autoPackTraffic);//调用父页面方法判断选择交通是否显示
            if(autoPackTraffic == 'Y'){
                $("input[value='isuse_packed_cost_explanation']").parent().parent().parent().show();
                $("input[value='packed_product_id']").parent().parent().parent().show();
                $("input[value='isuse_packed_route_details']").parent().parent().parent().show();

                //“自动打包交通”属性为“是”时，只提供“驴妈妈前台”渠道供勾选，其他渠道不展示
                //“自动打包交通”属性为“是”时,提供“驴妈妈前台”“分销商”“驴妈妈后台”渠道供勾选，其他渠道不展示
                $("#distributorIds_selectAll").attr("disabled",true);
                //	$("#distributorIds_2").attr("disabled",true);
                //	$("#distributorIds_4").attr("disabled",true);
                $("#distributorIds_5").attr("disabled",true);
                $("#distributorIds_6").attr("disabled",true);
            }else{
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

        checkedPackageType();

        checkedProductType();

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

        /**
         * 跟团游 打包类型默认选中自主打包（当点击类别含有“国内”时，显示“自动打包交通”选择项） panyu 20160519
         */
        function checkedProductType() {
            var categoryId = $("#categoryId").val();
            if (categoryId == '15') {
                //如果所属品类为“自由行”或者“跟团游”，类别为“国内”且打包类型为“自主打包”且“是否含有大交通”属性为“是”，则显示属性“自动打包交通”，“自动打包交通”默认选中"否"
                var productType = $("input[name='productType']:checked").val(); //类别 (跟团游：(国内短线：'INNERSHORTLINE', 国内长线:'INNERLONGLINE') 非跟团游：(国内：'INNERLINE'),出境：'FOREIGNLINE')
                if(!productType){
                    productType="";
                }
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

    });
    //  --为EBK&VST跟团游优化添加js end--  //

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

    // 产品经理推荐 start
    $(function() {
        var $addOneTJ = $(".addOne_tj");
        var $ltAddTjBtn = $(".lt-add-tj-btn");

        $ltAddTjBtn.on("click", function() {
            var recoArray = $addOneTJ.find("input[name='productRecommends']");
            var countReco = recoArray.length;
            if (countReco > 3) {
                $.alert("产品经理推荐最多4条");
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
</script>