<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>产品商品基本信息</title>

    <#include "/base/head_meta.ftl"/>
    <#include "/base/findProductInputType.ftl"/>

    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/vst-line-travel.css"/>
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
        <li><a href="#">跟团游</a> &gt;</li>
        <li><a href="#">产品维护</a> &gt;</li>
        <li class="active">更新产品</li>
    </ul>
</div>

<div class="iframe_content mt10">
    <div class="tiptext tip-warning"><span class="tip-icon tip-icon-warning"></span>注：产品创建后，不能变更所属的品类</div>
    <#if prodProduct??>
    <div class="p_box box_info">
        <#-- 产品基础From表单 strat-->
        <form id="productFrom">
            <#-- 存放隐藏域 DIV -->
            <div id="productFormHiddenDiv">
                <input type="hidden" id="productId" name="productId" value="${prodProduct.productId}">
                <input type="hidden" id="categoryId" name="bizCategoryId" value="15">
                <input type="hidden" id="categoryName" name="bizCategory.categoryName" value="跟团游" >
                <#-- 产品类型-->
                <input type="hidden" id="productType" name="productType" value="${prodProduct.productType}" class="js_product_type">
                <#-- 产品是否有效-->
                <input type="hidden" name="cancelFlag" value="${prodProduct.cancelFlag}" >
                <#-- 电子合同中的产品ID-->
                <input type="hidden" name="prodEcontract.productId" value="${prodProduct.productId}" />
                <#-- 是否存在敏感词 -->
                <input type="hidden" name="senisitiveFlag" value="N">
            </div>

            <div class="box_content info_line">
                <table class="e_table form-inline">
                    <tbody>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>所属品类：</td>
                        <td>跟团游</td>
                    </tr>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1"></i>产品ID：</td>
                        <td>${prodProduct.productId!''}</td>
                    </tr>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>产品类型：</td>
                        <td>
                            <#-- 该值产品编辑页面无法修改，存储域在productFormHiddenDiv隐藏域的input数据框中-->
                            <select class="lt-category" disabled data-validate="true" required>
                                <option data-value="addName_default">选择产品类别</option>
                                <#list productTypes as productType>
                                    <#if productType.code == prodProduct.productType>
                                        <option value="${productType.code!''}" selected>${productType.cnName!''}</option>
                                    </#if>
                                </#list>
                            </select>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>行程类别：</td>                     
                        <td>  
							 <input type="radio" name="producTourtType" value="ONEDAYTOUR" disabled <#if prodProduct.producTourtType == 'ONEDAYTOUR'>checked</#if>/> 一日游&nbsp;&nbsp;
						      <input type="radio" name="producTourtType" value="MULTIDAYTOUR" disabled <#if prodProduct.producTourtType == 'MULTIDAYTOUR'>checked</#if>/> 多日游
		                 </td>                       
                    </tr>
                    <tr>
                        <td class="e_label e_label_top" width="150"><i class="cc1">*</i>驴妈妈产品名称：</td>
                        <td class="lt-product-name-td">
                            <#if prodProduct.productName != "">
                             <p class="lt-product-name-view-main">
                             	
                                <span class="lt-pnv-content-main">
                                	<#if prodProductNameVo!= ''&&prodProductNameVo.mainTitle != ''>
                                		主标题：${prodProductNameVo.mainTitle!''}
                                	<#else>
                                		${prodProduct.productName!''}
                                	</#if>
                                </span>
                                
                                <a href="javascript:;" class="lt-pnv-modify" data-dialog="
                                    <#if prodProduct.productType == 'INNERSHORTLINE'>.addName_dx_dialog
                                    <#elseif prodProduct.productType == 'INNERLONGLINE'>.addName_cx_dialog
                                    <#elseif prodProduct.productType == 'INNER_BORDER_LINE'>.addName_bjy_dialog
                                    <#elseif prodProduct.productType == 'FOREIGNLINE'>.addName_cj_dialog</#if>">修改</a>
                            </p>
                            </#if>

                            <a href="javascript:;" class="lt-add-name-btn lt-link-disabled" <#if prodProduct.productName != "">style="display: none;"</#if> >添加名称</a>
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

                    </tr>
                    <tr>
                        <td class="e_label" width="150"></td>
                        <td class="lt-product-sub-name-td">
                        	<p class="lt-product-name-view-sub">
                        		<span class="lt-pnv-content-sub">
                        		<#if prodProductNameVo!= ''&&prodProductNameVo.subTitle != ''>
                            		副标题：${prodProductNameVo.subTitle!''}
                            	</#if>
                            	</span>
						    </p>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>供应商产品名称：</td>
                        <td>
                            <input type="text" id="suppProductName" name="suppProductName" value="${prodProduct.suppProductName!''}" class="wl_300 notSymbolTest" data-validate="true" required maxlength="100"/>
                            <span>&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||"</span>
                        </td>
                    </tr>
                    <tr>
                        <#-- 该值产品编辑页面无法修改，存储域在productFormHiddenDiv隐藏域的input数据框中-->
                        <td class="e_label" width="150"><i class="cc1">*</i>状态：</td>
                        <td>
                            <select class="pginfo_state" disabled data-validate="true" required>
                                <option value="N" <#if prodProduct.cancelFlag == 'N'>selected</#if> >无效</option>
                                <option value="Y" <#if prodProduct.cancelFlag == 'Y'>selected</#if> >有效</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>推荐级别：</td>
                        <td>
                            <select name="recommendLevel" data-validate="true" required>
                                <option value="5" <#if prodProduct.recommendLevel == '5'>selected</#if> >5</option>
                                <option value="4" <#if prodProduct.recommendLevel == '4'>selected</#if> >4</option>
                                <option value="3" <#if prodProduct.recommendLevel == '3'>selected</#if> >3</option>
                                <option value="2" <#if prodProduct.recommendLevel == '2'>selected</#if> >2</option>
                                <option value="1" <#if prodProduct.recommendLevel == '1'>selected</#if> >1</option>
                            </select>
                            <span>说明：由高到低排列，即数字越高推荐级别越高</span>
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
                        <td class="e_label" width="150"><i class="cc1">*</i>打包类型：</td>
                        <td>
                            <#list packageTypeList as list>
                                <input type="radio" name="packageType" value="${list.code!''}" <#if list.code == prodProduct.packageType >checked</#if> onclick="return false;" readonly data-validate="true" required />${list.cnName!''}
                            </#list>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>产品经理：</td>
                        <td>
                            <input type="text" id="managerName" name="managerName" value="${prodProduct.managerName!''}" />
                            <input type="hidden" id="managerId" name="managerId" value="${prodProduct.managerId }" data-validate="true" required>
                            <span id="tips" style="color:red;">注：该处信息仅供参考，如需修改请至商品基础设置下进行维护</span>
                            <div id="managerNameError"></div>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>所属分公司：</td>
                        <td>
                            <select name="filiale" class="filialeCombobox"  data-validate="true">
                            	<option value="">请选择</option>
                                <#list filiales as filiale>
                                    <option value="${filiale.code}" <#if prodProduct.filiale == filiale>selected</#if> >${filiale.cnName}</option>
                                </#list>
                            </select>
                            <div id="filialeError"></div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="box_content info_line">
                <p class="info_title">电子合同</p>
                <table class="e_table form-inline">
                    <tbody>
                    <tr>
                        <td class="e_label" width="150">电子合同范本：</td>
                        <td>
                            <select name="prodEcontract.econtractTemplate" id="econtract">
                                <option <#if econtract != null && econtract.econtractTemplate == ''>selected</#if> >自动调取</option>
                                <option value="PREPAYMENTS" <#if econtract != null && econtract.econtractTemplate == 'PREPAYMENTS'>selected</#if> >预付款协议</option>
                                <option value="PRESALE_AGREEMENT" <#if econtract != null && econtract.econtractTemplate == 'PRESALE_AGREEMENT'>selected</#if>>旅游产品预售协议</option>
                                <option value="TAIWAN_AGREEMENT" <#if econtract != null && econtract.econtractTemplate == 'TAIWAN_AGREEMENT'>selected</#if>>赴台旅游预订须知</option>
                                <option value="DONGGANG_ZHEJIANG_CONTRACT" <#if econtract != null && econtract.econtractTemplate == 'DONGGANG_ZHEJIANG_CONTRACT'>selected</#if>>浙江省赴台旅游合同</option>
                                <#if prodProduct?? && prodProduct.bizCategory?? && prodProduct.bizCategory.categoryId == 15 && prodProduct.productType=="FOREIGNLINE">
                                <option value="COMMISSIONED_SERVICE_AGREEMENT" <#if econtract != null && econtract.econtractTemplate == 'COMMISSIONED_SERVICE_AGREEMENT'>selected</#if>>委托服务协议</option>
                                </#if>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>组团方式：</td>
                        <td>
                            <input type="radio" name="prodEcontract.groupType" value="SELF_TOUR" value="SELF_TOUR" <#if econtract != null && econtract.groupType == 'SELF_TOUR'>checked</#if> />自行组团&nbsp;
                            <input type="radio" name="prodEcontract.groupType" value="COMMISSIONED_TOUR" <#if econtract != null && econtract.groupType == 'COMMISSIONED_TOUR'>checked</#if> />委托组团&nbsp;
                            <label id="label_groupSupplierName" <#if econtract != null && (econtract.groupType == 'SELF_TOUR' || econtract.groupType == null)>style="display:none;"</#if> >被委托组团方:</div>
                            <input id="input_groupSupplierName" type="text" name="prodEcontract.groupSupplierName" value="${econtract.groupSupplierName!''}" <#if econtract != null && (econtract.groupType == 'SELF_TOUR' || econtract.groupType == null)>style="display:none;"</#if>/>
                            <input type="hidden" id="input_groupSupplierNameHidden"  value="${groupSupplierName!''}"/>
                        </td>
                    </tr>
                <#if prodProduct?? && prodProduct.bizCategory?? && prodProduct.bizCategory.categoryId == 15 && prodProduct.productType=="FOREIGNLINE">
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>出团模式：</td>
                        <td>
                            <input type="radio" name="prodEcontract.groupMode" value="COMMON_GROUP" data-validate="true" required <#if econtract != null && econtract.groupMode == 'COMMON_GROUP'>checked</#if> />常规跟团游&nbsp;
                            <input type="radio" name="prodEcontract.groupMode" value="NOLEADER_GROUP" data-validate="true" required <#if econtract != null && econtract.groupMode == 'NOLEADER_GROUP'>checked</#if> />无领队小团&nbsp;
                            <input type="radio" name="prodEcontract.groupMode" value="PARENTAGE_GROUP" data-validate="true" required <#if econtract != null && econtract.groupMode == 'PARENTAGE_GROUP'>checked</#if> />亲子游学&nbsp;
                        </td>
                    </tr>
                </#if>
                    </tbody>
                </table>
            </div>

            <div class="box_content info_line">
                <p class="info_title">基础信息</p>
                <table class="e_table form-inline">
                    <tbody>
                   <#if prodProduct.packageType=='SUPPLIER'  && prodProduct.bizCategory.categoryId == 15 && (prodProduct.productType == 'INNERLINE' || prodProduct.productType == 'INNERSHORTLINE' || prodProduct.productType == 'INNERLONGLINE' || prodProduct.productType == 'INNER_BORDER_LINE')>  
                       <tr  class="operation_category" >
                           <td class="e_label" width="150"><i class="cc1">*</i>运营类别：</td>
                           <td>
                           <input type="radio"    name="operationCategory" id="operationCategory"   <#if prodProduct.operationCategory == 'LONGGROUP'>checked</#if> value="LONGGROUP"  class="pack_type error" data-validate="true" required="">长线跟团游
                           <input type="radio"    name="operationCategory" id="operationCategory"   <#if prodProduct.operationCategory == 'SHORTGROUP'>checked</#if> value="SHORTGROUP"  class="pack_type error" data-validate="true" required="">短线跟团游
                           </td>
                      </tr>      		
                   </#if> 
                    <tr>
                    	<input type="hidden" name="prodProductPropList[0].prodPropId" <#if prodProductProp?? >value="${prodProductProp.prodPropId}"</#if> />
						<input type="hidden" name="prodProductPropList[0].propId" <#if bizCategoryProp?? >value="${bizCategoryProp.propId}"</#if> />
						<input type="hidden" name="prodProductPropList[0].bizCategoryProp.propCode" <#if bizCategoryProp?? >value="${bizCategoryProp.propCode!''}"</#if> />
						
                        <td class="e_label" width="150">类型：</td>
                        <td>
                        	<#list bizDictList as bizDict>
                            <input type="checkbox" name="prodProductPropList[0].propValue" errorele="errorEle0" value="${bizDict.dictId!''}" onclick="showAddFlagCheckBox(this,'${bizDict.addFlag!''}',0);" data="propId_leixing" data2="${bizDict.dictName!''}" 
                            <#if prodProductProp?? && prodProductProp.propValue>
                            <#list prodProductProp.propValue?split(",") as dictId>
							  <#if dictId == bizDict.dictId>checked</#if></#list> </#if>><span>${bizDict.dictName!''}</span>
                        	</#list>
                        	
                        	<div id="errorEle0Error" style="display:inline"></div>
							<span style="color:grey"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>跟团类型：</td>
                        <td>
                            <#list groupTypes as groupType>
                                <input type="radio" name="prodLineBasicInfo.groupType" value="${groupType.code!''}" class="pack_type" <#if groupType.code == prodLineBasicInfo.groupType>checked</#if> data-validate="true" required/><span>${groupType.cnName!''}</span>
                            </#list>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>是否有大交通：</td>
                        <td>
                            <input type="radio" name="prodLineBasicInfo.trafficFlag" value="Y" class="pack_type" onclick="return false;" <#if prodLineBasicInfo.trafficFlag == "Y">checked</#if> readonly data-validate="true" required/><span>是</span>
                            <input type="radio" name="prodLineBasicInfo.trafficFlag" value="N" class="pack_type" onclick="return false;" <#if prodLineBasicInfo.trafficFlag == "N">checked</#if> readonly data-validate="true" required/><span>否</span>
                        </td>
                    </tr>
                    <#if prodProduct.productType=="FOREIGNLINE">
                    <tr  id="groupSettle">
                        <td class="e_label" width="150" >是否是团结算：</td>
                        <td>
                            <input type="radio" name="prodLineBasicInfo.groupSettleFlag" value="Y" class="pack_type"  <#if prodLineBasicInfo.groupSettleFlag=="Y">checked</#if>   data-validate="true"/><span>是</span>
                            <input type="radio" name="prodLineBasicInfo.groupSettleFlag" value="N" class="pack_type"  <#if prodLineBasicInfo.groupSettleFlag=="N">checked</#if>   data-validate="true"/><span>否</span>
                        </td>
                    </tr>
                    </#if>
                    <tr>
                        <td class="e_label" width="150"><i class="cc1">*</i>最少成团人数：</td>
                        <td>
                            <input type="text" name="prodLineBasicInfo.leastClusterPerson" value="${prodLineBasicInfo.leastClusterPerson!''}" data-validate="true" digits="true" max="1000" required/>人
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label" width="150">儿童价标准描述：</td>
                        <td>
                            <textarea name="prodLineBasicInfo.childPriceDesc" class="lt-child-price-text" maxlength="200">${prodLineBasicInfo.childPriceDesc!''}</textarea>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="box_content info_line">
                <p class="info_title">描述信息</p>
                <!--/产品经理推荐-->
                <div>
                    <table class="e_table form-inline addOne_tj">
                        <tbody>
                            <#if productRecommends?? && productRecommends?size &gt; 0>
                                <#list productRecommends as productRecommend>
                                    <tr class='lt-tj'>
                                        <td class="e_label" width="150"><#if productRecommend_index == 0><i class="cc1">*</i>产品经理推荐：</#if>
                                           </td>
                                        <td>
                                            <input type="text" name="productRecommends" value="${productRecommend!''}" class="wl_300" style="width:400px;"  placeholder="输入产品推荐语，每句话最多输入30个汉字" data-validate="true" required maxlength="30"/>
                                             <#if productRecommend_index == 0><a id="editOldData"  class="btn btn_cc1">编辑产品经理推荐</a></#if>
                                            <#if productRecommend_index &gt; 1><a class="lt-tj-delete-btn" href="javascript:;">删除</a></#if>
                                        </td>
                                    </tr>
                                    <#if productRecommends?size==1>
                                     <tr class='lt-tj'>
                                        <td class="e_label" width="150"></td>
                                        <td>
                                            <input type="text" name="productRecommends" value="" class="wl_300"  style="width:400px;"  placeholder="输入产品推荐语，每句话最多输入30个汉字" data-validate="true" required maxlength="30"/>
                                        </td>
                                    </tr>
                                    </#if>
                                </#list>
                            <#else>
                                <#list 1..2 as num>
                                    <tr class='lt-tj'>
                                        <td class="e_label" width="150"><#if num_index == 0><i class="cc1">*</i>产品经理推荐：</#if></td>
                                        <td>
                                            <input type="text" name="productRecommends" class="wl_300"  style="width:400px;" placeholder="输入产品推荐语，每句话最多输入30个汉字" data-validate="true" required maxlength="30"/>
                                        </td>
                                    </tr>
                                </#list>
                            </#if>

                        </tbody>
                        <input id="editOldDataHidden" value="true"  type="hidden" />
                    </table>
                    <p class="add_one_word"><a class="lt-add-tj-btn" href="javascript:;">增加一条</a></p>
                    <p  style="color:grey;margin-left:150px;">注：最少2到3条，最多4条</p>
                </div>
                <!--/产品经理推荐END-->
                <#--
				<input type="hidden" name="productDetail" value='${productDetail!''}' />-->

                <#--
				<input type="hidden" id="productDetail" name="productDetail" value='' />
				<div id	="productDetailText" style="display:none;">${productDetail}</div>-->
            </div>

            <div class="box_content info_line ">
                  <div class="box_content">
                    <table class="e_table form-inline">
                        <tbody>
                        <tr id="districtTr">
                            <td class="e_label"><i id="districtFlag" class="cc1">*</i>出发地：</td>
                            <td>
                                <input type="hidden" name="multiToStartPointIds" id="multiToStartPointIds" value=""/>
                                <input type="text" id="district" name="district" value="<#if prodProduct.bizDistrict??>${prodProduct.bizDistrict.districtName!''}</#if>" readonly="readonly" class="w35" required>
                                <input type="hidden" id="districtId" name="bizDistrictId" value="<#if prodProduct.bizDistrict??>${prodProduct.bizDistrict.districtId}</#if>">
                                <div id="districtError"></div>
                            </td>
                        </tr>
                        <#if prodProduct.prodDestReList?? && prodProduct.prodDestReList?size gt 0>
                        <#list prodProduct.prodDestReList as prodDestRe>
                            <tr <#if prodDestRe_index=0>name='no1'</#if>>
                                <#if prodDestRe_index=0>
                                       <td name="addspan" rowspan='${prodProduct.prodDestReList?size}' class="e_label"><i class="cc1">*</i>目的地：</td>
                                   </#if>
                                <td>
                                    <input type="text" name="dest" class="w35" id="dest${prodDestRe_index}" value="${prodDestRe.destName}[${prodDestRe.destTypeCnName }]" readonly = "readonly" required>
                                    <input type="hidden" name="prodDestReList[${prodDestRe_index}].destId" id="destId${prodDestRe_index}" value="${prodDestRe.destId}"> <#if prodDestRe_index gt 0 >  <a class='btn btn_cc1' name='del_button'>删除</a></#if>
                                    <input type="hidden" name="prodDestReList[${prodDestRe_index}].reId" id="reId" value="${prodDestRe.reId}">
                                    <input type="hidden" name="prodDestReList[${prodDestRe_index}].productId" value="${prodProduct.productId}">
                                    <#if prodDestRe_index=0><a class="btn btn_cc1" id="new_button">添加目的地</a></#if> 
                                    <#if prodDestRe.parentDestName!=null><span type="text" id="spanId_${prodDestRe_index}">上级目的地：${prodDestRe.parentDestName}</span>
                                    <#else><span type="text" id="spanId_${prodDestRe_index}" ></span>
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
                                <input type="hidden" name="prodDestReList[0].reId" id="reId" value="${prodDestRe.reId}">
                                <input type="hidden" name="prodDestReList[0].productId" value="${prodProduct.productId}">
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

            <!-- 销售渠道 -->
            <div class="box_content info_line">
                <#include "/prod/packageTour/product/showDistributorProd.ftl"/>
            </div>

        </form>

            <div class="p_box box_info info_line" id="reservationLimit">
                <div class="title">
                    <h2 class="f16">预订限制</h2>
                </div>
                <#include "/common/reservationLimit.ftl"/>
            </div>

            <a class="gi-button JS_button_save" href="javascript:;">保存</a>
            <a class="gi-button JS_button_save_and_next" href="javascript:;">保存并维护下一步</a>
            <#-- 当页面为查看页面时显示（showProductMaintain.ftl页面中isView=Y时） -->
            <a class="showLogDialog btn btn_cc1" style="margin-left:100px;" param='objectId=${prodProduct.productId}&objectType=PROD_PRODUCT_PRODUCT&sysName=VST' href="javascript:;">查看操作日志</a>

    </div>
    <#else>
        <div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div>
    </#if>

</div>

<!--/弹出层-->
<div class="baseInfo_bg"></div>
<!--/弹出层END-->

<!-- 引入产品名称模板 -->
<#include "/dujia/group/prod/productNameTemplate.ftl"/>

<!-- 引入基本的js -->
<#include "/base/foot.ftl"/>

<!-- 页面跳转逻辑JS-->
<script src="/vst_admin/js/dujia/group/vst-product-info.js"></script>
<script src="/vst_admin/js/dujia/dujia-common.js"></script>

<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/kindeditor.js"></script>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/plugins/image/image.js"></script>
<script type="text/javascript" src="/vst_admin/js/contentManage/kindEditorConf.js?v1"></script>

<script>

	$(function(){
		var packageType ='${prodProduct.packageType}';	
		if("SUPPLIER"==packageType){
			$("#input_groupSupplierName").attr("readonly","readonly");
		}
		if($("input[name='productType']").val() == "FOREIGNLINE"){
	       $("select[name='productGrade']").val("");
	       $("select[name='productGrade']").attr('disabled','disabled');
	    }
	});
	
	
    //刷新产品主框架
    refreshProductMainFrame();

    //当用户以查看权限进入页面时，初始化页面中的按钮
    initPageForView();

    //刷新 敏感词校验（产品名称、供应商产品名称、产品经理推荐、产品详情）
    var $elements = $("input[name='productName'],input[name='suppProductName'],input[name='productRecommends'],textarea");
    validateSensitiveWord($elements, true);

    var $document = $(document);

    //内容不能是特殊符号（备注：将notSymbolTest值方法要验证的input输入框的class中即可验证）
    jQuery.validator.addMethod("notSymbolTest", function (value, element) {
        var $ele = $(element);
        var val = $ele.val();
        var illegalReg = /[<>%#*&^@!~/\\'||"]/;
        return !illegalReg.test(val);
    }, "禁止输入特殊符号");
    jQuery.validator.addClassRules("notSymbolTest", {
        notSymbolTest: true
    });

  //类型添加addFlag
    function showAddFlagCheckBox(params,addFlag,index){
     	if($(params).attr('checked')=='checked' && addFlag=='Y'){
     		$(params).next().after("<input type='text' style='width:120px' data='"+$(params).val()+"' alias='prodProductPropList["+index+"].addValue' remark='remark' >");
     	}else if(addFlag=='Y'){
     		$(params).next().next().remove();
     	}
    }
    
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
			$.confirm("你好，将产品勾选为“"+$(this).attr("data2")+"”系列，需与产品运营部沟通，确认本产品符合“"+$(this).attr("data2")+"”的八项标准，若未经批准擅自勾选，所引起的一切顾客投诉纠纷或赔偿责任由产品经理承担，我们也会定期拉取“"+$(this).attr("data2")+"”产品清单和查询后台操作日志予以监控。",function(){
				$that.checked = true;
			});
		}		
	});

    $document.on("click", ".JS_button_save,.JS_button_save_and_next", function () {

        //验证产品经理推荐
        if(!valiateOldData(true,false)){
            return false;
        };

        var $this = $(this);
        var $giForm = $this.parents(".p_box");

        //大表单
        var $forms = $giForm.find("form");

        //去除placeholder
        var $placeholder = $forms.find('[data-validate="true"][data-placeholder]:not([disabled])');
        $placeholder.each(function (index, element) {

            var $ele = $(element);
            
            
            var value = $ele.val();
            var placeHolderText = $ele.data("placeholder");

            if (placeHolderText === value) {
                $ele.val("");
            }

        });

        //是否验证通过
        var isValidate = true;

        //行程 表单
        $forms.each(function() {
            var $form = $(this);
            if(validateForm($form) == false) {
                isValidate = false;
            }
        });

        function validateForm($form) {

            var isValidate = true;
            var validate = $form.validate();
            var $input = $form.find('[data-validate="true"]:not([disabled])');

            $input.each(function (index) {
                var $required = $input[index];
                var ret = validate.element($required);
                if (!ret) {
                    isValidate = false;
                }
            });

            //整体控制字数
            var $validateExtend = $form.find('[data-validate-extend="true"]');
            $validateExtend.each(function () {
                var $this = $(this);
                if (validateExtend($this) == false) {
                    isValidate = false;
                }
                $this.off("input propertychange", "input[type=text]", watchExtend);
                $this.on("input propertychange", "input[type=text]", watchExtend);
                function watchExtend() {
                    var $this = $(this);
                    var $extend = $this.parents('[data-validate-extend="true"]');
                    validateExtend($extend);
                }
            })

            return isValidate;
        }
		var filialeName = $("select.filialeCombobox").combobox("getValue");
		if(!filialeName) {
			var $combo = $("select.filialeCombobox").next();
			$("i[for=\"FILIALE\"]").remove();
			$combo.css('border-color', "red");
			$("<i for=\"FILIALE\" class=\"error\">该字段不能为空</i>").insertAfter($combo);
		}

		isValidate = isValidate && !!filialeName;
        //验证通过
        var alertObj;
        if (isValidate) {
            addProduct($(this));
        } else {
            alertObj = $.saveAlert({
                "width": 250,
                "type": "danger",
                "text": "请完成必填填写项并确认填写正确"
            });
        }

    });

    /*           kindEditor（产品特色） JS start                 */
    var dataObj=[],markList=[];

    $(".sensitiveVad").each(function(){
        var mark=$(this).attr('mark');
        var t = lvmamaEditor.editorCreate('mark',mark);
        dataObj.push(t);
        markList.push(mark);
    });

    function validateSensitiveVad(){
        var ret = true;

        $("textarea.sensitiveVad").each(function(index,element){
            var required = $(element).attr("required");
            var str = $(element).text();
            if(required==="required"&&str.replace("<br />","")===""){
                $.alert("请填写完必填项再保存");
                ret= false;
            }

            var len = str.match(/[^ -~]/g) == null ? str.length : str.length + str.match(/[^ -~]/g).length ;
            var maxLength = $(element).attr("maxLength");
            if(len>maxLength){
                $.alert("超过最大长度"+maxLength);
                ret= false;
            }
        });
        return ret;
    }
    /*            kindEditor JS end                 */

    /*            全局常量 JS start                        */
    //出发地窗口（出发地弹出、产品特色editor相关代码在findProductInputType.ftl文件中）
    var districtSelectDialog,contactAddDialog,coordinateSelectDialog;
    /*            全局常量  JS end                        */

    /*            目的地选择 JS start                     */
    var destSelectDialog;
    var dests = [];//子页面选择项对象数组
    var count = $("input[name=dest]").size();
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
    $document.on("click", "#new_button", function() {
        count++;
        var size = $("input[name=dest]").size()+count;
        $("td[name=addspan]").attr("rowspan",size);
        var $tbody = $(this).parents("tbody");
            $tbody.append("<tr><td><input type='text' class='w35' name='dest' id='dest"+count+"' readonly = 'readonly' required/>" + 
                        "<input type='hidden' name='prodDestReList["+count+"].destId' id='destId"+count+"'/>" + 
                        "<input type='hidden' name='prodDestReList["+count+"].reId'	 id='reId"+count+"'/>" +
                        "<input type='hidden' name='prodDestReList["+count+"].productId' id='productId"+count+"'/>"+
                        "<a class='btn btn_cc1' name='del_button'>删除</a>"+"<span type='text' id='spanId_"+count+"'></span></td></tr>");
    });

    //删除目的地
    $document.on("click", "a[name=del_button]", function() {
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
        spanId = $(this).next().next().next().next().next().attr("id");
        var url = "/vst_admin/biz/dest/selectDestList.do?type=main";
        destSelectDialog = new xDialog(url,{},{title:"选择目的地",iframe:true,width:"1000",height:"600"});

    });
    /*             目的地选择 JS end                        */

    /*          产品保存 JS start                 */
    function addProduct($this) {

        //检验是否选中分销商
        var distributorChecked = document.getElementById("distributorIds_4").checked;
        if(distributorChecked){
            var distributorUserIds = $("input:checkbox[name='distributorUserIds']:checked").val();
            if(isEmpty(distributorUserIds)){
                $.alert("请选择super系统分销商.");
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

        //校验当前form表单
        var flag1;
        var flag2;
        if(!$("#productFrom").validate().form()){
            $(this).removeAttr("disabled");
            flag1 = false;
        }

        if(!validateSensitiveVad()){
            return false;
        }

        if(!$("#reservationLimitForm").validate().form()){
            flag2 = false;
        }

        if(flag1 == false || flag2 == false){
            return false;
        }

        //判断是否含有敏感字（产品名称、供应商产品名称、产品经理推荐、产品详情）
        if(validateSensitiveWord($elements, false)){
            $("input[name=senisitiveFlag]").val("Y");
            $.confirm("内容含有敏感词，是否继续？", function() {
                sendAjaxToSaveProduct($this);
            });
        } else {
            $("input[name=senisitiveFlag]").val("N");
            sendAjaxToSaveProduct($this);
        }

    }

    //发送ajax请求保存产品信息
    function sendAjaxToSaveProduct($this) {
        //判断当前按钮的状态
        if($this.data("saving")) {
            return;
        }
        //改变保存按钮状态
        changeSaveButtonStatus(true);

        $.ajax({
            url : "/vst_admin/dujia/group/product/updateProduct.do",
            type : "post",
            dataType : 'json',
            data : $("#productFrom").serialize()+"&"+$("#reservationLimitForm").serialize()+"&comOrderRequiredFlag="+($("#reservationLimitForm").is(":hidden") ? "N" : "Y"),
            success : function(result) {
                if(result.code == "success"){
                    $.saveAlert({"width": 150,"type": "success","text": "保存成功"});

                    parent.checkAndJump();
                    if ($this.is(".JS_button_save_and_next")) {
                        $("#route",parent.document).parent("li").trigger("click");
                    }

                } else {
                    $.saveAlert({"width": 250,"type": "danger","text": result.message});
                }

                changeSaveButtonStatus(false);
            },
            error : function() {
                console.log("Call sendAjaxToSaveProduct method occurs error");
                $.alert('网络服务异常, 请稍后重试');
                changeSaveButtonStatus(false);
            }
        });
    }

    //改变 保存、保存并下一步 按钮的状态（isLoading：true 保存前 false 保存结束后）
    function changeSaveButtonStatus(isLoading) {
        var $saveButton =$(".JS_button_save");
        var $saveButtonNext = $(".JS_button_save_and_next");

        if (isLoading) {
            $saveButton.html("保存中");
            $saveButtonNext.html("保存中");
            $saveButton.attr("data-saving", true);
            $saveButtonNext.attr("data-saving", true);
            $saveButton.addClass("disabled");
            $saveButtonNext.addClass("disabled");
        } else {
            $saveButton.html("保存");
            $saveButtonNext.html("保存并维护下一步");
            $saveButton.attr("data-saving", false);
            $saveButtonNext.attr("data-saving", false);
            $saveButton.removeClass("disabled");
            $saveButtonNext.removeClass("disabled");
        }
    }
    /*           产品保存 JS end                 */

    //模糊查找 产品经理名称及电话
    vst_pet_util.superUserSuggest("#managerName", "input[name=managerId]");

    //控制 预定限制 中的内容
    showRequire($("input[name='bizCategoryId']").val(),$("input[name=productType]").val(),"");

    //控制组团方式为委托组团的被委托组团方是否显示
    $document.on("click", "input:radio[name='prodEcontract.groupType']", function() {
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

    //刷新产品维护主框架
    function refreshProductMainFrame() {
        //判断打包类型，然后更新父页面菜单
        var packageType = $("input[name=packageType]:checked").val();
        $("#packageType", parent.document).val(packageType);
        if("SUPPLIER"==packageType){
            $("#lvmama", parent.document).remove();
            $("#supplier", parent.document).show();
            $("#reservationLimit").show();
        }else if("LVMAMA"==packageType){
            $("#supplier", parent.document).remove();
            $("#lvmama", parent.document).show();
            $("#reservationLimit").hide();
        }else {
            $.alert("打包类型没有!");
        }

        //判断是否有大交通
        var transportType = $("input[name='prodLineBasicInfo.trafficFlag']:checked").val();
        $("#transportType", parent.document).val(transportType);
        if($("input[name='prodLineBasicInfo.trafficFlag']:checked").size() > 0 && "SUPPLIER"==packageType){
            if(transportType == 'Y'){
                $("#transportLi",parent.document).show();
            }else {
                $("#transportLi",parent.document).hide();
            }
        }
    }

    //当用户以查看权限进入页面时，初始化页面中的按钮
    function initPageForView() {
        if($("#isView",parent.document).val()=='Y' || $("#isView",parent.top.document).val()=='Y'){
            //将页面中所有 select、input都设置为无效
            $("select,input,textarea").attr("disabled", "disabled");
            $("a").addClass("lt-link-disabled").click("return false;");
            //移除页面中的保存按钮
            $(".JS_button_save,.JS_button_save_and_next").remove();
            //显示查看日志按钮
            $(".showLogDialog").css("display", "inline");
        }
    }

    //判断参数为空
    function isEmpty(value) {
        if (typeof(value) == 'undefined' || value == null || value == "") {
            return true;
        } else {
            return false;
        }
    }

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

    $("#editOldData").css("display", "none");
    valiateOldData(false, true);
    $("input[name='productRecommends']").keyup(function() {
        valiateOldData(false, false);
    });

    $("#editOldData").click(function() {
        var $proRecommend = $(".addOne_tj").find("input[name='productRecommends']");
        $("#editOldData").css("display", "none");
        $("#editOldDataHidden").attr("value","true");
        $(".lt-tj-delete-btn").css("display","");
         $(".lt-add-tj-btn").css("display", "");
        $proRecommend.each(function() {
            var $this = $(this);
            $this.removeAttr("readonly");
            $this.attr("data-validate", true);
        });

    });
});

function valiateOldData(errorFlag, readFlag) {
    //自定义验证老产品经理推荐数据
    var $addOneTJ = $(".addOne_tj");
    var $error = $addOneTJ.find('tr.errorTr');
    var flag = true;
    var $proRecommend = $addOneTJ.find("input[name='productRecommends']");
    if ($proRecommend.length > 4 && $("#editOldDataHidden").val() == "true") {
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
        $("<tr class=\"lt-tj errorTr\"><td></td><td class=\"error\">不满足录入规范(每条最多30个汉字，最多4条)</td><tr>").appendTo($addOneTJ);

    }
}
    //供应商打包总产子销
    $(function () {
        showSupplierPackageMuiltStartPintInput();
        //初始化供应商多出发地
        initSupplierPackageMuiltStartPintInput();
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
        var packageType = $('input[name="packageType"]:checked').val();
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
    function initSupplierPackageMuiltStartPintInput() {
        var productType = $("input[name='productType']").val();
        var packageType = $('input[name="packageType"]:checked').val();
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


</script>

</body>
</html>