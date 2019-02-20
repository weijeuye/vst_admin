<#if costIncludeInnerVO.larTrans??>
<#list costIncludeInnerVO.larTrans as node>
    <#if node =="air_ticket">
       <#assign air_ticket = 'Y' />
    </#if>
    <#if node =="train">
       <#assign train = 'Y' />
    </#if>
    <#if node =="bus">
       <#assign bus = 'Y' />
    </#if>
     <#if node =="trans_other">
       <#assign trans_other = 'Y' />
    </#if>
     <#if node =="freeTrans">
       <#assign freeTrans = 'Y' />
    </#if>
     <#if node =="multDest">
       <#assign multDest = 'Y' />
    </#if>
</#list>
</#if>

<#if costIncludeInnerVO.localCar??>
<#list costIncludeInnerVO.localCar as lc>
    <#if lc =="air_tour_car">
       <#assign air_tour_car = 'Y' />
    </#if>
    <#if lc =="car_other">
       <#assign car_other = 'Y' />
    </#if>
</#list>
</#if>

<#if costIncludeInnerVO.dinnerSec??>
<#list costIncludeInnerVO.dinnerSec as dise>
    <#if dise =="dinner_price">
       <#assign dinner_price = 'Y' />
    </#if>
    <#if dise =="dinner_tab">
       <#assign dinner_tab = 'Y' />
    </#if>
    <#if dise =="dinner_food">
       <#assign dinner_food = 'Y' />
    </#if>
</#list>
</#if>

<#if costIncludeInnerVO.chilPriStanSec??>
<#list costIncludeInnerVO.chilPriStanSec as psec>
    <#if psec =="chil_age">
       <#assign chil_age = 'Y' />
    </#if>
    <#if psec =="chil_hei">
       <#assign chil_hei = 'Y' />
    </#if>
</#list>
</#if>

<#if costIncludeInnerVO.chilCostInclCheck??>
<#list costIncludeInnerVO.chilCostInclCheck as incheck>
    <#if incheck =="CHILD_ONE_TRAIN">
       <#assign CHILD_ONE_TRAIN = 'Y' />
    </#if>
    <#if incheck =="CHILD_ROUND_TRAIN">
       <#assign CHILD_ROUND_TRAIN = 'Y' />
    </#if>
    <#if incheck =="CHILD_PARK">
       <#assign CHILD_PARK = 'Y' />
    </#if>
    <#if incheck =="CHILD_GUIDE">
       <#assign CHILD_GUIDE = 'Y' />
    </#if>
    <#if incheck =="CHILD_HALF_PRICE">
       <#assign CHILD_HALF_PRICE = 'Y' />
    </#if>
    <#if incheck =="CHIL_TRA_SELF">
       <#assign CHIL_TRA_SELF = 'Y' />
    </#if>
    <#if incheck =="CHILD_SELF">
       <#assign CHILD_SELF = 'Y' />
    </#if>
</#list>
</#if>
<#if costExcludeInnerVO.costExclude??>
<#list costExcludeInnerVO.costExclude as excludeIn>
    <#if excludeIn =="001">
       <#assign CNI001 = 'Y' />
    </#if>
    <#if excludeIn =="002">
       <#assign CNI002 = 'Y' />
    </#if>
    <#if excludeIn =="003">
       <#assign CNI003 = 'Y' />
    </#if>
    <#if excludeIn =="004">
       <#assign CNI004 = 'Y' />
    </#if>
    <#if excludeIn =="005">
       <#assign CNI005 = 'Y' />
    </#if>
</#list>
</#if>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>费用说明国内</title>
    <link href="/vst_admin/css/ui-common.css" rel="stylesheet"/>
    <link href="/vst_admin/css/ui-components.css" rel="stylesheet"/>
    <link href="/vst_admin/css/iframe.css" rel="stylesheet"/>
    <link href="/vst_admin/css/dialog.css" rel="stylesheet"/>

    <!--新增样式表-->
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/group-input.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/vst-group-input.css"/>
</head>
<body>
<input type="hidden" id="noEditFlag" name="noEditFlag" value="${noEditFlag}">
<input type="hidden" id="modelVersion" neme = "modelVersion" value="${modelVersion}">
<div id="dest_go_hidden" style="display:none;">
                	 <label style="margin-left:117px;">
                     </label>
                     <select  class="gi-w75 JS_checkbox_disabled"  name="otherMultDestGoDis" >
                        <#if prodDestReList ?? &&  prodDestReList?size gt 0>
					        <#list prodDestReList as prodDestRe>
					            <option   value="${prodDestRe.destName}" >${prodDestRe.destName}</option>
					    	</#list>
						</#if>
                        <option  value="<#if bizDistrict??>${bizDistrict.districtName}</#if>" ><#if bizDistrict??>${bizDistrict.districtName!''}</#if></option>
                    </select>
                    <label>
                        至：
                    </label>
                   
                    <select class="gi-w75 JS_checkbox_disabled"  name="otherMultDestGoRe" >
                    	<#if prodDestReList ?? &&  prodDestReList?size gt 0>
					        <#list prodDestReList as prodDestRe>
					            <option   value="${prodDestRe.destName}" >${prodDestRe.destName}</option>
					    	</#list>
						</#if>
                    	<option  value="<#if bizDistrict??>${bizDistrict.districtName}</#if>" ><#if bizDistrict??>${bizDistrict.districtName!''}</#if></option>
                    </select>
                    <select class="gi-w75 JS_checkbox_disabled"  name="otherMultDestGoSel"  onchange="trafficChange1(this,1)">
                        <option   value="AIR_TICKET" >机票</option>
                        <option   value="TRAIN">火车</option>
                        <option   value="BUS">巴士</option>
                    </select>
                     <select id="traiSelT1" style="display:none;" class="gi-w100 JS_checkbox_disabled"   name="otherMultDestGoSelT">
                        <option   value="G_TRAIN" >G-高铁</option>
                        <option   value="D_TRAIN" >D-动车</option>
                        <option   value="Z_TRAIN" >Z-直达</option>
                        <option   value="T_TRAIN" >T-特快</option>
                        <option   value="K_TRAIN" >K-快速</option>
                        <option   value="Y_TRAIN" >Y-旅游专列</option>
                    </select>

                    <select id="traiSelS1" style="display:none;" class="gi-w100 JS_checkbox_disabled"  name="otherMultDestGoSelS" >
                        <option  value="BUS_BLOCK" >商务座</option>
                        <option  value="SUPERSEAT" >特等座</option>
                        <option  value="FIRST_SEAT" >一等座</option>
                        <option  value="TWO_SEAT" >二等座</option>
                        <option  value="ADV_SOFT_SLE" >高级软卧</option>
                        <option  value="SOFT_SLE" >软卧</option>
                        <option  value="HARD_SLE" >硬卧</option>
                        <option  value="SOFT_SEAT" >软座</option>
                        <option  value="HARD_SEAT" >硬座</option>
                        <option  value="NO_SEAT" >无座</option>
                    </select>
                    <br id="traiSelSB1" style="display:none;"/>
                     <label class="gi-ml20" id="traiSelSL1" style="margin-right:40px;display:none;">
	                    <label style="margin-left:99px;">
	                    </label>
	                    <input type="hidden" name="otherMultDestGoTOR" value="N" />
                        <input class="JS_checkbox_disabled" type="checkbox" name=""  value="Y" onclick="triffCheck(this)"/>
                            注：火车票随机出票，不能保证上下铺/同一车厢/连座 ;
                    </label>
                    <a href="javascript:" class="gi-del JS_del_stay" onclick="deleteDest(this)">删除</a>
                    <br>
                </div>
                
                
                <div id="dest_back_hidden" style="display:none;">
                	 <label style="margin-left:117px;">
                     </label>
                     <select  class="gi-w75 JS_checkbox_disabled"  name="otherMultDestBackDis" >
                        <#if prodDestReList ?? &&  prodDestReList?size gt 0>
					        <#list prodDestReList as prodDestRe>
					            <option   value="${prodDestRe.destName}" >${prodDestRe.destName}</option>
					    	</#list>
						</#if>
                        <option  value="<#if bizDistrict??>${bizDistrict.districtName}</#if>" ><#if bizDistrict??>${bizDistrict.districtName!''}</#if></option>
                    </select>
                    <label>
                        至：
                    </label>
                   
                    <select class="gi-w75 JS_checkbox_disabled"  name="otherMultDestBackRe" >
                    	<#if prodDestReList ?? &&  prodDestReList?size gt 0>
					        <#list prodDestReList as prodDestRe>
					            <option   value="${prodDestRe.destName}" >${prodDestRe.destName}</option>
					    	</#list>
						</#if>
                    	<option  value="<#if bizDistrict??>${bizDistrict.districtName}</#if>" ><#if bizDistrict??>${bizDistrict.districtName!''}</#if></option>
                    </select>
                    <select class="gi-w75 JS_checkbox_disabled"  name="otherMultDestBackSel" onchange="trafficChange1(this,2)">
                        <option   value="AIR_TICKET" >机票</option>
                        <option   value="TRAIN">火车</option>
                        <option   value="BUS">巴士</option>
                    </select>
                     <select id="traiSelT2" style="display:none;" class="gi-w100 JS_checkbox_disabled"   name="otherMultDestBackSelT">
                        <option   value="G_TRAIN" >G-高铁</option>
                        <option   value="D_TRAIN" >D-动车</option>
                        <option   value="Z_TRAIN" >Z-直达</option>
                        <option   value="T_TRAIN" >T-特快</option>
                        <option   value="K_TRAIN" >K-快速</option>
                        <option   value="Y_TRAIN" >Y-旅游专列</option>
                    </select>

                    <select id="traiSelS2" style="display:none;" class="gi-w100 JS_checkbox_disabled"  name="otherMultDestBackSelS" >
                        <option  value="BUS_BLOCK" >商务座</option>
                        <option  value="SUPERSEAT" >特等座</option>
                        <option  value="FIRST_SEAT" >一等座</option>
                        <option  value="TWO_SEAT" >二等座</option>
                        <option  value="ADV_SOFT_SLE" >高级软卧</option>
                        <option  value="SOFT_SLE" >软卧</option>
                        <option  value="HARD_SLE" >硬卧</option>
                        <option  value="SOFT_SEAT" >软座</option>
                        <option  value="HARD_SEAT" >硬座</option>
                        <option  value="NO_SEAT" >无座</option>
                    </select>
                    <br id="traiSelSB2" style="display:none;"/>
                     <label class="gi-ml20" id="traiSelSL2" style="margin-right:40px;display:none;">
	                    <label style="margin-left:99px;">
	                    </label>
	                    <input type="hidden" name="otherMultDestBackTOR" value="N" />
                        <input class="JS_checkbox_disabled" type="checkbox" name=""  value="Y" onclick="triffCheck(this)"/>
                            注：火车票随机出票，不能保证上下铺/同一车厢/连座 ;
                    </label>
                    <a href="javascript:" class="gi-del JS_del_stay" onclick="deleteDest(this)">删除</a>
                    <br>
                </div>
     <div id="free_hidden1" style="display:none;">
                     <select id="traiSelT1" class="gi-w100 JS_checkbox_disabled"  name="freeGoSelT">
                        <option  value="G_TRAIN" >G-高铁</option>
                        <option  value="D_TRAIN" >D-动车</option>
                        <option  value="Z_TRAIN" >Z-直达</option>
                        <option  value="T_TRAIN" >T-特快</option>
                        <option  value="K_TRAIN" >K-快速</option>
                        <option  value="Y_TRAIN" >Y-旅游专列</option>
                    </select>
                    <select id="traiSelS1" class="gi-w100 JS_checkbox_disabled"  name="freeGoSelS" >
                        <option  value="BUS_BLOCK" >商务座</option>
                        <option  value="SUPERSEAT" >特等座</option>
                        <option  value="FIRST_SEAT" >一等座</option>
                        <option  value="TWO_SEAT" >二等座</option>
                        <option  value="ADV_SOFT_SLE" >高级软卧</option>
                        <option  value="SOFT_SLE" >软卧</option>
                        <option  value="HARD_SLE" >硬卧</option>
                        <option  value="SOFT_SEAT" >软座</option>
                        <option  value="HARD_SEAT" >硬座</option>
                        <option  value="NO_SEAT" >无座</option>
                    </select>
                   <br id="traiSelS1">
                     <label class="gi-ml20" id="traiSelS1">
	                    <label style="margin-left:113px;">
	                    </label>
                            <input class="JS_checkbox_disabled" type="checkbox" name="freeTraiOtherGo"  value="Y" />
                            注：火车票随机出票，不能保证上下铺/同一车厢/连座 ;
                        </label>
     </div>
     <div id="free_hidden2" style="display:none;">
     <select id="traiSelT2" class="gi-w100 JS_checkbox_disabled"  name="freeBackSelT">
                        <option  value="G_TRAIN" >G-高铁</option>
                        <option  value="D_TRAIN" >D-动车</option>
                        <option  value="Z_TRAIN" >Z-直达</option>
                        <option  value="T_TRAIN" >T-特快</option>
                        <option  value="K_TRAIN" >K-快速</option>
                        <option  value="Y_TRAIN" >Y-旅游专列</option>
                    </select>
 	<select id="traiSelS2" class="gi-w100 JS_checkbox_disabled"  name="freeBackSelS" >
                        <option  value="BUS_BLOCK" >商务座</option>
                        <option  value="SUPERSEAT" >特等座</option>
                        <option  value="FIRST_SEAT" >一等座</option>
                        <option  value="TWO_SEAT" >二等座</option>
                        <option  value="ADV_SOFT_SLE" >高级软卧</option>
                        <option  value="SOFT_SLE" >软卧</option>
                        <option  value="HARD_SLE" >硬卧</option>
                        <option  value="SOFT_SEAT" >软座</option>
                        <option  value="HARD_SEAT" >硬座</option>
                        <option  value="NO_SEAT" >无座</option>
                    </select>
                    <br id="traiSelS2">
                     <label class="gi-ml20" id="traiSelS2">
	                    <label style="margin-left:113px;">
	                    </label>
                            <input class="JS_checkbox_disabled" type="checkbox" name="freeTraiOtherBack"  value="Y" />
                            注：火车票随机出票，不能保证上下铺/同一车厢/连座 ;
                        </label>
     </div>
<div class="iframe_header">
    <ul class="iframe_nav">
        <li><a href="#">${prodProduct.bizCategory.categoryName!''}</a> &gt;</li>
        <li><a href="#">${packageType!''}</a> &gt;</li>
        <li><a href="#">产品维护</a> &gt;</li>
        <li class="active">行程</li>
    </ul>
</div>
<div class="iframe_content mt10">
    <div class="p_box box_info p_line">
        <div class="box_content">

            <div class="gi-header">
                <h1>行程展示：${prodLineRoute.routeName}</h1>
                <a href="/vst_admin/prod/prodLineRoute/showUpdateRoute.do?productId=${prodProduct.productId}&oldProductId=${oldProductId}">返回行程</a>
                <#if noEditFlag == "true"><a href="javascript:void(0);" id="toEdit">编辑费用</a>
                </#if>
                
            </div>
            <!--线路行程 开始-->
            <div class="gi-form">

            <div class="tiptext tip-warning" <#if isAddPage?? && isAddPage>style="display:block;"<#else>style="display:none;"</#if>>
                <span class="tip-icon tip-icon-warning"></span>温馨提示：默认勾选项请点击保存才会生效
            </div>

            <form class="costInnerForm" action="#" method="post">
                    <p>
                        费用包含说明：
                    </p>
                    <!--费用包含 国内 开始-->
                    <div class="gi-form JS_inner_include_internal">
                <#-- 隐藏域存放DIV -->
                <div class="costInnerHiddenDiv" style="display:none;">
                    <input type="hidden" name="categoryId" value="${prodProduct.bizCategoryId}"/>
                    <input type="hidden" name="productId" value="${productId}"/>
                    <input type="hidden" name="productType" value="${productType}" />
                    <input type="hidden" name="lineRouteId" value="${lineRouteId}"/>
                </div>

        <dl class="clearfix">
            <dt>
                大交通：
            </dt>
            <dd>

                <p>
                    <span class="JS_checkbox_switch_box">

                    <label>
                        <input type="checkbox" class="JS_checkbox_switch" name="larTrans" value="air_ticket" <#if air_ticket=='Y'>checked</#if>/>
                        机票：
                    </label>
                   
                    <select class="gi-w75 JS_checkbox_disabled" <#if air_ticket!='Y'>disabled="disabled"</#if> name="airSel" >
                        <option  <#if costIncludeInnerVO.airSel=="COME_AND_GO">selected </#if> value="COME_AND_GO" >往返</option>
                        <option  <#if costIncludeInnerVO.airSel=="ONE_WAY">selected </#if> value="ONE_WAY">单程</option>
                    </select>
                    （经济舱，含税费）
                    </span>
                </p>
                <div class="JS_checkbox_switch_box">
                    <p>
                        <span>
                            <label>
                                <input class="JS_checkbox_switch" type="checkbox" name="larTrans" <#if train=='Y'>checked</#if> value="train" />
                                火车：
                            </label>
                            <select class="gi-w75 JS_checkbox_disabled"  <#if train!='Y'>disabled</#if> name="trainSel" >
                                <option <#if costIncludeInnerVO.trainSel=="COME_AND_GO" >selected </#if>  value="COME_AND_GO">往返</option>
                                <option <#if costIncludeInnerVO.trainSel=="ONE_WAY" >selected </#if> value="ONE_WAY">单程</option>
                            </select>
                            火车票
                            <select class="gi-w100 JS_checkbox_disabled"  <#if train!='Y'>disabled</#if> name="traiSelT">
                                <option <#if costIncludeInnerVO.traiSelT=="G_TRAIN" >selected </#if>  value="G_TRAIN" >G-高铁</option>
                                <option <#if costIncludeInnerVO.traiSelT=="D_TRAIN" >selected </#if>  value="D_TRAIN" >D-动车</option>
                                <option <#if costIncludeInnerVO.traiSelT=="Z_TRAIN" >selected </#if>  value="Z_TRAIN" >Z-直达</option>
                                <option <#if costIncludeInnerVO.traiSelT=="T_TRAIN" >selected </#if>  value="T_TRAIN" >T-特快</option>
                                <option <#if costIncludeInnerVO.traiSelT=="K_TRAIN" >selected </#if>  value="K_TRAIN" >K-快速</option>
                                <option <#if costIncludeInnerVO.traiSelT=="Y_TRAIN" >selected </#if>  value="Y_TRAIN" >Y-旅游专列</option>
                            </select>

                            <select class="gi-w100 JS_checkbox_disabled"  <#if train!='Y'>disabled</#if> name="traiSelS" >
                                <option <#if costIncludeInnerVO.traiSelS=="BUS_BLOCK" >selected </#if> value="BUS_BLOCK" >商务座</option>
                                <option <#if costIncludeInnerVO.traiSelS=="SUPERSEAT" >selected </#if> value="SUPERSEAT" >特等座</option>
                                <option <#if costIncludeInnerVO.traiSelS=="FIRST_SEAT" >selected </#if> value="FIRST_SEAT" >一等座</option>
                                <option <#if costIncludeInnerVO.traiSelS=="TWO_SEAT" >selected </#if> value="TWO_SEAT" >二等座</option>
                                <option <#if costIncludeInnerVO.traiSelS=="ADV_SOFT_SLE" >selected </#if> value="ADV_SOFT_SLE" >高级软卧</option>
                                <option <#if costIncludeInnerVO.traiSelS=="SOFT_SLE" >selected </#if> value="SOFT_SLE" >软卧</option>
                                <option <#if costIncludeInnerVO.traiSelS=="HARD_SLE" >selected </#if> value="HARD_SLE" >硬卧</option>
                                <option <#if costIncludeInnerVO.traiSelS=="SOFT_SEAT" >selected </#if> value="SOFT_SEAT" >软座</option>
                                <option <#if costIncludeInnerVO.traiSelS=="HARD_SEAT" >selected </#if> value="HARD_SEAT" >硬座</option>
                                <option <#if costIncludeInnerVO.traiSelS=="NO_SEAT" >selected </#if> value="NO_SEAT" >无座</option>
                            </select>
                        </span>
                    </p>
                    <p>
                        <label class="gi-ml20">
                            <input class="JS_checkbox_disabled" type="checkbox" name="busOther" <#if train!='Y'>disabled</#if>  <#if costIncludeInnerVO.busOther=="Y">checked </#if> value="Y" />
                            注：火车票随机出票，不能保证上下铺/同一车厢/连座 ;
                        </label>
                    </p>
                </div>
                <p>
                    <span class="JS_checkbox_switch_box">
                    <label>
                        <input type="checkbox" class="JS_checkbox_switch" name="larTrans" <#if bus=='Y'>checked</#if> value="bus" />
                        巴士：
                    </label>

                    <select class="gi-w75 JS_checkbox_disabled"  <#if bus!='Y'>disabled</#if>  name="busSel" >
                        <option <#if costIncludeInnerVO.busSel=="COME_AND_GO">selected </#if>  value="COME_AND_GO">往返</option>
                        <option <#if costIncludeInnerVO.busSel=="GO_WAY">selected </#if>  value="GO_WAY" >去程</option>
                        <option <#if costIncludeInnerVO.busSel=="BACK_WAY">selected </#if>  value="BACK_WAY" >返程</option>
                    </select>
                    </span>
                </p>
                                
                <p>
                <span class="JS_checkbox_switch_box">
                    <label>
                        <input type="checkbox" class="JS_checkbox_switch" name="larTrans" <#if freeTrans=='Y'>checked</#if> value="freeTrans" />
                        往返组合：
                    </label>
                    
                    <label>
                        去程：
                    </label>
                   
                    <select id="freeSel1" class="gi-w75 JS_checkbox_disabled" <#if freeTrans!='Y'>disabled="disabled"</#if> name="freeSelGo" onchange="trafficChange(this.value,1)">
                        <option  <#if costIncludeInnerVO.freeSelGo=="AIR_TICKET">selected </#if> value="AIR_TICKET" >机票</option>
                        <option  <#if costIncludeInnerVO.freeSelGo=="TRAIN">selected </#if> value="TRAIN">火车</option>
                        <option  <#if costIncludeInnerVO.freeSelGo=="BUS">selected </#if> value="BUS">巴士</option>
                    </select>
                    <#if costIncludeInnerVO.freeSelGo=="TRAIN">
                    <select id="traiSelT1" class="gi-w100 JS_checkbox_disabled"  <#if freeTrans!='Y'>disabled</#if> name="freeGoSelT">
                        <option <#if costIncludeInnerVO.freeGoSelT=="G_TRAIN" >selected </#if>  value="G_TRAIN" >G-高铁</option>
                        <option <#if costIncludeInnerVO.freeGoSelT=="D_TRAIN" >selected </#if>  value="D_TRAIN" >D-动车</option>
                        <option <#if costIncludeInnerVO.freeGoSelT=="Z_TRAIN" >selected </#if>  value="Z_TRAIN" >Z-直达</option>
                        <option <#if costIncludeInnerVO.freeGoSelT=="T_TRAIN" >selected </#if>  value="T_TRAIN" >T-特快</option>
                        <option <#if costIncludeInnerVO.freeGoSelT=="K_TRAIN" >selected </#if>  value="K_TRAIN" >K-快速</option>
                        <option <#if costIncludeInnerVO.freeGoSelT=="Y_TRAIN" >selected </#if>  value="Y_TRAIN" >Y-旅游专列</option>
                    </select>

                    <select id="traiSelS1" class="gi-w100 JS_checkbox_disabled"  <#if freeTrans!='Y'>disabled</#if> name="freeGoSelS" >
                        <option <#if costIncludeInnerVO.freeGoSelS=="BUS_BLOCK" >selected </#if> value="BUS_BLOCK" >商务座</option>
                        <option <#if costIncludeInnerVO.freeGoSelS=="SUPERSEAT" >selected </#if> value="SUPERSEAT" >特等座</option>
                        <option <#if costIncludeInnerVO.freeGoSelS=="FIRST_SEAT" >selected </#if> value="FIRST_SEAT" >一等座</option>
                        <option <#if costIncludeInnerVO.freeGoSelS=="TWO_SEAT" >selected </#if> value="TWO_SEAT" >二等座</option>
                        <option <#if costIncludeInnerVO.freeGoSelS=="ADV_SOFT_SLE" >selected </#if> value="ADV_SOFT_SLE" >高级软卧</option>
                        <option <#if costIncludeInnerVO.freeGoSelS=="SOFT_SLE" >selected </#if> value="SOFT_SLE" >软卧</option>
                        <option <#if costIncludeInnerVO.freeGoSelS=="HARD_SLE" >selected </#if> value="HARD_SLE" >硬卧</option>
                        <option <#if costIncludeInnerVO.freeGoSelS=="SOFT_SEAT" >selected </#if> value="SOFT_SEAT" >软座</option>
                        <option <#if costIncludeInnerVO.freeGoSelS=="HARD_SEAT" >selected </#if> value="HARD_SEAT" >硬座</option>
                        <option <#if costIncludeInnerVO.freeGoSelS=="NO_SEAT" >selected </#if> value="NO_SEAT" >无座</option>
                    </select>
                    <br id="traiSelS1">
                     <label class="gi-ml20" id="traiSelS1">
	                    <label style="margin-left:113px;">
	                    </label>
                            <input class="JS_checkbox_disabled" type="checkbox" name="freeTraiOtherGo" <#if freeTrans!='Y'>disabled</#if>  <#if costIncludeInnerVO.freeTraiOtherGo=="Y">checked </#if> value="Y" />
                            注：火车票随机出票，不能保证上下铺/同一车厢/连座 ;
                    </label>
                    </#if>
                    <br>
                    <label style="margin-left:87px;">
                    </label>
                    <label>
                        返程：
                    </label>
                   
                    <select id="freeSel2" class="gi-w75 JS_checkbox_disabled" <#if freeTrans!='Y'>disabled="disabled"</#if> name="freeSelBack" onchange="trafficChange(this.value,2)">
                        <option  <#if costIncludeInnerVO.freeSelBack=="AIR_TICKET">selected </#if> value="AIR_TICKET" >机票</option>
                        <option  <#if costIncludeInnerVO.freeSelBack=="TRAIN">selected </#if> value="TRAIN">火车</option>
                        <option  <#if costIncludeInnerVO.freeSelBack=="BUS">selected </#if> value="BUS">巴士</option>
                    </select>
                    <#if costIncludeInnerVO.freeSelBack=="TRAIN">
                    <select id="traiSelT2" class="gi-w100 JS_checkbox_disabled" s <#if freeTrans!='Y'>disabled</#if> name="freeBackSelT">
                        <option <#if costIncludeInnerVO.freeBackSelT=="G_TRAIN" >selected </#if>  value="G_TRAIN" >G-高铁</option>
                        <option <#if costIncludeInnerVO.freeBackSelT=="D_TRAIN" >selected </#if>  value="D_TRAIN" >D-动车</option>
                        <option <#if costIncludeInnerVO.freeBackSelT=="Z_TRAIN" >selected </#if>  value="Z_TRAIN" >Z-直达</option>
                        <option <#if costIncludeInnerVO.freeBackSelT=="T_TRAIN" >selected </#if>  value="T_TRAIN" >T-特快</option>
                        <option <#if costIncludeInnerVO.freeBackSelT=="K_TRAIN" >selected </#if>  value="K_TRAIN" >K-快速</option>
                        <option <#if costIncludeInnerVO.freeBackSelT=="Y_TRAIN" >selected </#if>  value="Y_TRAIN" >Y-旅游专列</option>
                    </select>

                    <select id="traiSelS2" class="gi-w100 JS_checkbox_disabled"  <#if freeTrans!='Y'>disabled</#if> name="freeBackSelS" >
                        <option <#if costIncludeInnerVO.freeBackSelS=="BUS_BLOCK" >selected </#if> value="BUS_BLOCK" >商务座</option>
                        <option <#if costIncludeInnerVO.freeBackSelS=="SUPERSEAT" >selected </#if> value="SUPERSEAT" >特等座</option>
                        <option <#if costIncludeInnerVO.freeBackSelS=="FIRST_SEAT" >selected </#if> value="FIRST_SEAT" >一等座</option>
                        <option <#if costIncludeInnerVO.freeBackSelS=="TWO_SEAT" >selected </#if> value="TWO_SEAT" >二等座</option>
                        <option <#if costIncludeInnerVO.freeBackSelS=="ADV_SOFT_SLE" >selected </#if> value="ADV_SOFT_SLE" >高级软卧</option>
                        <option <#if costIncludeInnerVO.freeBackSelS=="SOFT_SLE" >selected </#if> value="SOFT_SLE" >软卧</option>
                        <option <#if costIncludeInnerVO.freeBackSelS=="HARD_SLE" >selected </#if> value="HARD_SLE" >硬卧</option>
                        <option <#if costIncludeInnerVO.freeBackSelS=="SOFT_SEAT" >selected </#if> value="SOFT_SEAT" >软座</option>
                        <option <#if costIncludeInnerVO.freeBackSelS=="HARD_SEAT" >selected </#if> value="HARD_SEAT" >硬座</option>
                        <option <#if costIncludeInnerVO.freeBackSelS=="NO_SEAT" >selected </#if> value="NO_SEAT" >无座</option>
                    </select>
                    <br id="traiSelS2"/>
                     <label class="gi-ml20" id="traiSelS2">
	                    <label style="margin-left:113px;">
	                    </label>
                        <input class="JS_checkbox_disabled" type="checkbox" name="freeTraiOtherBack" <#if freeTrans!='Y'>disabled</#if>  <#if costIncludeInnerVO.freeTraiOtherBack=="Y">checked </#if> value="Y" />
                            注：火车票随机出票，不能保证上下铺/同一车厢/连座 ;
                    </label>
                    </#if>
                </span>
                </p>
                
                <p style="margin-top:10px;">
                
                <span class="JS_checkbox_switch_box" >
                    <label>
                        <input type="checkbox" class="JS_checkbox_switch" name="larTrans" id="destCheck" <#if multDest=='Y'>checked</#if> value="multDest" />
                        多目的地：
                    </label>
                    
                    <label>
                        去程
                    </label>
                   
                    <select  class="gi-w75 JS_checkbox_disabled" <#if multDest!='Y'>disabled="disabled"</#if> name="firstMultDestGoDis" >
                        <option  <#if bizDistrict?? && costIncludeInnerVO.firstMultDestGoDis==bizDistrict.districtName>selected</#if> value="<#if bizDistrict??>${bizDistrict.districtName}</#if>" ><#if bizDistrict??>${bizDistrict.districtName!''}</#if></option>
                        <#if prodDestReList ?? &&  prodDestReList?size gt 0>
					        <#list prodDestReList as prodDestRe>
					            <option  <#if costIncludeInnerVO.firstMultDestGoDis==prodDestRe.destName>selected </#if> value="${prodDestRe.destName}" >${prodDestRe.destName}</option>
					    	</#list>
						</#if>
                    </select>
                    <label>
                        至：
                    </label>
                   
                    <select class="gi-w75 JS_checkbox_disabled" <#if multDest!='Y'>disabled="disabled"</#if> name="firstMultDestGoRe" >
                    	<#if prodDestReList ?? &&  prodDestReList?size gt 0>
					        <#list prodDestReList as prodDestRe>
					             <option  <#if costIncludeInnerVO.firstMultDestGoRe==prodDestRe.destName>selected </#if> value="${prodDestRe.destName}" >${prodDestRe.destName}</option>
					    	</#list>
						</#if>
                    	<option  <#if bizDistrict?? && costIncludeInnerVO.firstMultDestGoRe==bizDistrict.districtName>selected</#if> value="<#if bizDistrict??>${bizDistrict.districtName}</#if>" ><#if bizDistrict??>${bizDistrict.districtName!''}</#if></option>
                    </select>
                    <select class="gi-w75 JS_checkbox_disabled" <#if multDest!='Y'>disabled="disabled"</#if> name="firstMultDestGoSel" onchange="trafficChange1(this,1)">
                        <option  <#if costIncludeInnerVO.firstMultDestGoSel=="AIR_TICKET">selected </#if> value="AIR_TICKET" >机票</option>
                        <option  <#if costIncludeInnerVO.firstMultDestGoSel=="TRAIN">selected </#if> value="TRAIN">火车</option>
                        <option  <#if costIncludeInnerVO.firstMultDestGoSel=="BUS">selected </#if> value="BUS">巴士</option>
                    </select>
                    <select id="traiSelT1" class="gi-w100 JS_checkbox_disabled" style="display:<#if costIncludeInnerVO.firstMultDestGoSel!="TRAIN">none </#if>;"  <#if multDest!='Y'>disabled</#if> name="firstMultDestGoSelT">
                        <option <#if costIncludeInnerVO.firstMultDestGoSelT=="G_TRAIN" >selected </#if>  value="G_TRAIN" >G-高铁</option>
                        <option <#if costIncludeInnerVO.firstMultDestGoSelT=="D_TRAIN" >selected </#if>  value="D_TRAIN" >D-动车</option>
                        <option <#if costIncludeInnerVO.firstMultDestGoSelT=="Z_TRAIN" >selected </#if>  value="Z_TRAIN" >Z-直达</option>
                        <option <#if costIncludeInnerVO.firstMultDestGoSelT=="T_TRAIN" >selected </#if>  value="T_TRAIN" >T-特快</option>
                        <option <#if costIncludeInnerVO.firstMultDestGoSelT=="K_TRAIN" >selected </#if>  value="K_TRAIN" >K-快速</option>
                        <option <#if costIncludeInnerVO.firstMultDestGoSelT=="Y_TRAIN" >selected </#if>  value="Y_TRAIN" >Y-旅游专列</option>
                    </select>

                    <select id="traiSelS1" class="gi-w100 JS_checkbox_disabled" style="display:<#if costIncludeInnerVO.firstMultDestGoSel!="TRAIN">none </#if>;"  <#if multDest!='Y'>disabled</#if> name="firstMultDestGoSelS" >
                        <option <#if costIncludeInnerVO.firstMultDestGoSelS=="BUS_BLOCK" >selected </#if> value="BUS_BLOCK" >商务座</option>
                        <option <#if costIncludeInnerVO.firstMultDestGoSelS=="SUPERSEAT" >selected </#if> value="SUPERSEAT" >特等座</option>
                        <option <#if costIncludeInnerVO.firstMultDestGoSelS=="FIRST_SEAT" >selected </#if> value="FIRST_SEAT" >一等座</option>
                        <option <#if costIncludeInnerVO.firstMultDestGoSelS=="TWO_SEAT" >selected </#if> value="TWO_SEAT" >二等座</option>
                        <option <#if costIncludeInnerVO.firstMultDestGoSelS=="ADV_SOFT_SLE" >selected </#if> value="ADV_SOFT_SLE" >高级软卧</option>
                        <option <#if costIncludeInnerVO.firstMultDestGoSelS=="SOFT_SLE" >selected </#if> value="SOFT_SLE" >软卧</option>
                        <option <#if costIncludeInnerVO.firstMultDestGoSelS=="HARD_SLE" >selected </#if> value="HARD_SLE" >硬卧</option>
                        <option <#if costIncludeInnerVO.firstMultDestGoSelS=="SOFT_SEAT" >selected </#if> value="SOFT_SEAT" >软座</option>
                        <option <#if costIncludeInnerVO.firstMultDestGoSelS=="HARD_SEAT" >selected </#if> value="HARD_SEAT" >硬座</option>
                        <option <#if costIncludeInnerVO.firstMultDestGoSelS=="NO_SEAT" >selected </#if> value="NO_SEAT" >无座</option>
                    </select>
                    <br id="traiSelSB1" style="display:<#if costIncludeInnerVO.firstMultDestGoSel!="TRAIN">none </#if>;"/>
                     <label class="gi-ml20" id="traiSelSL1" style="display:<#if costIncludeInnerVO.firstMultDestGoSel!="TRAIN">none </#if>; margin-right:40px;">
	                    <label style="margin-left:99px;">
	                    </label>
	                    <input type="hidden" name="firstMultDestGoTOR" value="${costIncludeInnerVO.firstMultDestGoTOR}" />
                        <input class="JS_checkbox_disabled" type="checkbox" name="" <#if multDest!='Y'>disabled</#if>  <#if costIncludeInnerVO.firstMultDestGoTOR=="Y">checked </#if> value="Y" onclick="triffCheck(this)"/>
                            注：火车票随机出票，不能保证上下铺/同一车厢/连座 ;
                    </label>
                    
                    <a href="javascript:" class="JS_add_stay" onclick="addGoDest()">添加</a>
                    <br>
                    
                    <#if costIncludeInnerVO.otherMultDestGoDis ?? &&  costIncludeInnerVO.otherMultDestGoDis?size gt 0>
                    <#assign go_size = 0 />
                    <#list costIncludeInnerVO.otherMultDestGoDis as otherMultDestGoDis>
                    	<label style="margin-left:117px;">
                     </label>
                     <select  class="gi-w75 JS_checkbox_disabled" <#if multDest!='Y'>disabled="disabled"</#if> name="otherMultDestGoDis" >
                        <option  <#if bizDistrict?? && otherMultDestGoDis==bizDistrict.districtName>selected</#if> value="<#if bizDistrict??>${bizDistrict.districtName}</#if>" ><#if bizDistrict??>${bizDistrict.districtName!''}</#if></option>
                        <#if prodDestReList ?? &&  prodDestReList?size gt 0>
					        <#list prodDestReList as prodDestRe>
					            <option  <#if otherMultDestGoDis==prodDestRe.destName>selected </#if> value="${prodDestRe.destName}" >${prodDestRe.destName}</option>
					    	</#list>
						</#if>
                    </select>
                    <label>
                        至：
                    </label>
                   
                    <select class="gi-w75 JS_checkbox_disabled" <#if multDest!='Y'>disabled="disabled"</#if> name="otherMultDestGoRe" >
                    	<#if prodDestReList ?? &&  prodDestReList?size gt 0>
					        <#list prodDestReList as prodDestRe>
					             <option  <#if costIncludeInnerVO.otherMultDestGoRe[go_size]==prodDestRe.destName>selected </#if> value="${prodDestRe.destName}" >${prodDestRe.destName}</option>
					    	</#list>
						</#if>
                    	<option  <#if bizDistrict?? && costIncludeInnerVO.otherMultDestGoRe[go_size]==bizDistrict.districtName>selected</#if> value="<#if bizDistrict??>${bizDistrict.districtName}</#if>" ><#if bizDistrict??>${bizDistrict.districtName!''}</#if></option>
                    </select>
                    <select class="gi-w75 JS_checkbox_disabled" <#if multDest!='Y'>disabled="disabled"</#if> name="otherMultDestGoSel" onchange="trafficChange1(this,1)">
                        <option  <#if costIncludeInnerVO.otherMultDestGoSel[go_size]=="AIR_TICKET">selected </#if> value="AIR_TICKET" >机票</option>
                        <option  <#if costIncludeInnerVO.otherMultDestGoSel[go_size]=="TRAIN">selected </#if> value="TRAIN">火车</option>
                        <option  <#if costIncludeInnerVO.otherMultDestGoSel[go_size]=="BUS">selected </#if> value="BUS">巴士</option>
                    </select>
                    <select id="traiSelT1" class="gi-w100 JS_checkbox_disabled" style="display:<#if costIncludeInnerVO.otherMultDestGoSel[go_size]!="TRAIN">none </#if>;"  <#if multDest!='Y'>disabled</#if> name="otherMultDestGoSelT">
                        <option <#if costIncludeInnerVO.otherMultDestGoSelT[go_size]=="G_TRAIN" >selected </#if>  value="G_TRAIN" >G-高铁</option>
                        <option <#if costIncludeInnerVO.otherMultDestGoSelT[go_size]=="D_TRAIN" >selected </#if>  value="D_TRAIN" >D-动车</option>
                        <option <#if costIncludeInnerVO.otherMultDestGoSelT[go_size]=="Z_TRAIN" >selected </#if>  value="Z_TRAIN" >Z-直达</option>
                        <option <#if costIncludeInnerVO.otherMultDestGoSelT[go_size]=="T_TRAIN" >selected </#if>  value="T_TRAIN" >T-特快</option>
                        <option <#if costIncludeInnerVO.otherMultDestGoSelT[go_size]=="K_TRAIN" >selected </#if>  value="K_TRAIN" >K-快速</option>
                        <option <#if costIncludeInnerVO.otherMultDestGoSelT[go_size]=="Y_TRAIN" >selected </#if>  value="Y_TRAIN" >Y-旅游专列</option>
                    </select>

                    <select id="traiSelS1" class="gi-w100 JS_checkbox_disabled" style="display:<#if costIncludeInnerVO.otherMultDestGoSel[go_size]!="TRAIN">none </#if>;"  <#if multDest!='Y'>disabled</#if> name="otherMultDestGoSelS" >
                        <option <#if costIncludeInnerVO.otherMultDestGoSelS[go_size]=="BUS_BLOCK" >selected </#if> value="BUS_BLOCK" >商务座</option>
                        <option <#if costIncludeInnerVO.otherMultDestGoSelS[go_size]=="SUPERSEAT" >selected </#if> value="SUPERSEAT" >特等座</option>
                        <option <#if costIncludeInnerVO.otherMultDestGoSelS[go_size]=="FIRST_SEAT" >selected </#if> value="FIRST_SEAT" >一等座</option>
                        <option <#if costIncludeInnerVO.otherMultDestGoSelS[go_size]=="TWO_SEAT" >selected </#if> value="TWO_SEAT" >二等座</option>
                        <option <#if costIncludeInnerVO.otherMultDestGoSelS[go_size]=="ADV_SOFT_SLE" >selected </#if> value="ADV_SOFT_SLE" >高级软卧</option>
                        <option <#if costIncludeInnerVO.otherMultDestGoSelS[go_size]=="SOFT_SLE" >selected </#if> value="SOFT_SLE" >软卧</option>
                        <option <#if costIncludeInnerVO.otherMultDestGoSelS[go_size]=="HARD_SLE" >selected </#if> value="HARD_SLE" >硬卧</option>
                        <option <#if costIncludeInnerVO.otherMultDestGoSelS[go_size]=="SOFT_SEAT" >selected </#if> value="SOFT_SEAT" >软座</option>
                        <option <#if costIncludeInnerVO.otherMultDestGoSelS[go_size]=="HARD_SEAT" >selected </#if> value="HARD_SEAT" >硬座</option>
                        <option <#if costIncludeInnerVO.otherMultDestGoSelS[go_size]=="NO_SEAT" >selected </#if> value="NO_SEAT" >无座</option>
                    </select>
                    <br id="traiSelSB1" style="display:<#if costIncludeInnerVO.otherMultDestGoSel[go_size]!="TRAIN">none </#if>;margin-right:40px;"/>
                     <label class="gi-ml20" id="traiSelSL1" style="display:<#if costIncludeInnerVO.otherMultDestGoSel[go_size]!="TRAIN">none </#if>;">
	                    <label style="margin-left:97px;">
	                    </label>
	                    <input type="hidden" name="otherMultDestGoTOR" value="${costIncludeInnerVO.otherMultDestGoTOR[go_size]}" />
                        <input class="JS_checkbox_disabled" type="checkbox" name="" <#if multDest!='Y'>disabled</#if>  <#if costIncludeInnerVO.otherMultDestGoTOR[go_size]=="Y">checked </#if> value="Y" onclick="triffCheck(this)"/>
                            注：火车票随机出票，不能保证上下铺/同一车厢/连座 ;
                    </label>
                    
                    <a href="javascript:" class="gi-del JS_del_stay" onclick="deleteDest(this)">删除</a>
                    <br>
                    <#assign go_size = go_size+1 />
                    </#list>
                    </#if>

                    <label id="dest_go" style="display:none;">
                	</label>
                    <label style="margin-left:87px;">
                    </label>
                    <label>
                        返程
                    </label>
                   
                    <select class="gi-w75 JS_checkbox_disabled" <#if multDest!='Y'>disabled="disabled"</#if> name="firstMultDestBackDis" >
                    	 <option  <#if bizDistrict?? && costIncludeInnerVO.firstMultDestBackDis==bizDistrict.districtName>selected</#if> value="<#if bizDistrict??>${bizDistrict.districtName}</#if>" ><#if bizDistrict??>${bizDistrict.districtName!''}</#if></option>
                        <#if prodDestReList ?? &&  prodDestReList?size gt 0>
					        <#list prodDestReList as prodDestRe>
					            <option  <#if costIncludeInnerVO.firstMultDestBackDis==prodDestRe.destName>selected </#if> value="${prodDestRe.destName}" >${prodDestRe.destName}</option>
					    	</#list>
						</#if>
                    </select>
                    <label>
                        至：
                    </label>
                   
                    <select class="gi-w75 JS_checkbox_disabled" <#if multDest!='Y'>disabled="disabled"</#if> name="firstMultDestBackRe" >
                    	<#if prodDestReList ?? &&  prodDestReList?size gt 0>
					        <#list prodDestReList as prodDestRe>
					             <option  <#if costIncludeInnerVO.firstMultDestBackRe==prodDestRe.destName>selected </#if> value="${prodDestRe.destName}" >${prodDestRe.destName}</option>
					    	</#list>
						</#if>
                    	<option  <#if bizDistrict?? && costIncludeInnerVO.firstMultDestBackRe==bizDistrict.districtName>selected</#if> value="<#if bizDistrict??>${bizDistrict.districtName}</#if>" ><#if bizDistrict??>${bizDistrict.districtName!''}</#if></option>
                    </select>
                    <select class="gi-w75 JS_checkbox_disabled" <#if multDest!='Y'>disabled="disabled"</#if> name="firstMultDestBackSel" onchange="trafficChange1(this,2)">
                        <option  <#if costIncludeInnerVO.firstMultDestBackSel=="AIR_TICKET">selected </#if> value="AIR_TICKET" >机票</option>
                        <option  <#if costIncludeInnerVO.firstMultDestBackSel=="TRAIN">selected </#if> value="TRAIN">火车</option>
                        <option  <#if costIncludeInnerVO.firstMultDestBackSel=="BUS">selected </#if> value="BUS">巴士</option>
                    </select>
                    <select id="traiSelT2" class="gi-w100 JS_checkbox_disabled" style="display:<#if costIncludeInnerVO.firstMultDestBackSel!="TRAIN">none </#if>;" <#if multDest!='Y'>disabled</#if> name="firstMultDestBackSelT">
                        <option <#if costIncludeInnerVO.firstMultDestBackSelT=="G_TRAIN" >selected </#if>  value="G_TRAIN" >G-高铁</option>
                        <option <#if costIncludeInnerVO.firstMultDestBackSelT=="D_TRAIN" >selected </#if>  value="D_TRAIN" >D-动车</option>
                        <option <#if costIncludeInnerVO.firstMultDestBackSelT=="Z_TRAIN" >selected </#if>  value="Z_TRAIN" >Z-直达</option>
                        <option <#if costIncludeInnerVO.firstMultDestBackSelT=="T_TRAIN" >selected </#if>  value="T_TRAIN" >T-特快</option>
                        <option <#if costIncludeInnerVO.firstMultDestBackSelT=="K_TRAIN" >selected </#if>  value="K_TRAIN" >K-快速</option>
                        <option <#if costIncludeInnerVO.firstMultDestBackSelT=="Y_TRAIN" >selected </#if>  value="Y_TRAIN" >Y-旅游专列</option>
                    </select>

                    <select id="traiSelS2" class="gi-w100 JS_checkbox_disabled" style="display:<#if costIncludeInnerVO.firstMultDestBackSel!="TRAIN">none </#if>;" <#if multDest!='Y'>disabled</#if> name="firstMultDestBackSelS" >
                        <option <#if costIncludeInnerVO.firstMultDestBackSelS=="BUS_BLOCK" >selected </#if> value="BUS_BLOCK" >商务座</option>
                        <option <#if costIncludeInnerVO.firstMultDestBackSelS=="SUPERSEAT" >selected </#if> value="SUPERSEAT" >特等座</option>
                        <option <#if costIncludeInnerVO.firstMultDestBackSelS=="FIRST_SEAT" >selected </#if> value="FIRST_SEAT" >一等座</option>
                        <option <#if costIncludeInnerVO.firstMultDestBackSelS=="TWO_SEAT" >selected </#if> value="TWO_SEAT" >二等座</option>
                        <option <#if costIncludeInnerVO.firstMultDestBackSelS=="ADV_SOFT_SLE" >selected </#if> value="ADV_SOFT_SLE" >高级软卧</option>
                        <option <#if costIncludeInnerVO.firstMultDestBackSelS=="SOFT_SLE" >selected </#if> value="SOFT_SLE" >软卧</option>
                        <option <#if costIncludeInnerVO.firstMultDestBackSelS=="HARD_SLE" >selected </#if> value="HARD_SLE" >硬卧</option>
                        <option <#if costIncludeInnerVO.firstMultDestBackSelS=="SOFT_SEAT" >selected </#if> value="SOFT_SEAT" >软座</option>
                        <option <#if costIncludeInnerVO.firstMultDestBackSelS=="HARD_SEAT" >selected </#if> value="HARD_SEAT" >硬座</option>
                        <option <#if costIncludeInnerVO.firstMultDestBackSelS=="NO_SEAT" >selected </#if> value="NO_SEAT" >无座</option>
                    </select>
                    <br id="traiSelSB2" style="display:<#if costIncludeInnerVO.firstMultDestBackSel!="TRAIN">none </#if>;"/>
                     <label class="gi-ml20" id="traiSelSL2" style="display:<#if costIncludeInnerVO.firstMultDestBackSel!="TRAIN">none </#if>;margin-right:40px;">
	                    <label style="margin-left:99px;">
	                    </label>
	                    <input type="hidden" name="firstMultDestBackTOR" value="${costIncludeInnerVO.firstMultDestBackTOR}" />
                        <input class="JS_checkbox_disabled" type="checkbox" name="" <#if multDest!='Y'>disabled</#if>  <#if costIncludeInnerVO.firstMultDestBackTOR=="Y">checked </#if> value="Y" onclick="triffCheck(this)"/>
                            注：火车票随机出票，不能保证上下铺/同一车厢/连座 ;
                    </label>
                    <a href="javascript:" class="JS_add_stay" onclick="addBackDest()">添加</a>
                    <br>
                    
                    <#if costIncludeInnerVO.otherMultDestBackDis ?? &&  costIncludeInnerVO.otherMultDestBackDis?size gt 0>
                    <#assign back_size = 0 />
                    <#list costIncludeInnerVO.otherMultDestBackDis as otherMultDestBackDis>
                    	<label style="margin-left:117px;">
                     </label>
                     <select  class="gi-w75 JS_checkbox_disabled" <#if multDest!='Y'>disabled="disabled"</#if> name="otherMultDestBackDis" >
                        <option  <#if bizDistrict?? && otherMultDestBackDis==bizDistrict.districtName>selected</#if> value="<#if bizDistrict??>${bizDistrict.districtName}</#if>" ><#if bizDistrict??>${bizDistrict.districtName!''}</#if></option>
                        <#if prodDestReList ?? &&  prodDestReList?size gt 0>
					        <#list prodDestReList as prodDestRe>
					            <option  <#if otherMultDestBackDis==prodDestRe.destName>selected </#if> value="${prodDestRe.destName}" >${prodDestRe.destName}</option>
					    	</#list>
						</#if>
                    </select>
                    <label>
                        至：
                    </label>
                   
                    <select class="gi-w75 JS_checkbox_disabled" <#if multDest!='Y'>disabled="disabled"</#if> name="otherMultDestBackRe" >
                    	<#if prodDestReList ?? &&  prodDestReList?size gt 0>
					        <#list prodDestReList as prodDestRe>
					             <option  <#if costIncludeInnerVO.otherMultDestBackRe[back_size]==prodDestRe.destName>selected </#if> value="${prodDestRe.destName}" >${prodDestRe.destName}</option>
					    	</#list>
						</#if>
                    	<option  <#if bizDistrict?? && costIncludeInnerVO.otherMultDestBackRe[back_size]==bizDistrict.districtName>selected</#if> value="<#if bizDistrict??>${bizDistrict.districtName}</#if>" ><#if bizDistrict??>${bizDistrict.districtName!''}</#if></option>
                    </select>
                    <select class="gi-w75 JS_checkbox_disabled" <#if multDest!='Y'>disabled="disabled"</#if> name="otherMultDestBackSel" onchange="trafficChange1(this,2)">
                        <option  <#if costIncludeInnerVO.otherMultDestBackSel[back_size]=="AIR_TICKET">selected </#if> value="AIR_TICKET" >机票</option>
                        <option  <#if costIncludeInnerVO.otherMultDestBackSel[back_size]=="TRAIN">selected </#if> value="TRAIN">火车</option>
                        <option  <#if costIncludeInnerVO.otherMultDestBackSel[back_size]=="BUS">selected </#if> value="BUS">巴士</option>
                    </select>
                     <select id="traiSelT2" class="gi-w100 JS_checkbox_disabled" style="display:<#if costIncludeInnerVO.otherMultDestBackSel[back_size]!="TRAIN">none </#if>;"  <#if multDest!='Y'>disabled</#if> name="otherMultDestBackSelT">
                        <option <#if costIncludeInnerVO.otherMultDestBackSelT[back_size]=="G_TRAIN" >selected </#if>  value="G_TRAIN" >G-高铁</option>
                        <option <#if costIncludeInnerVO.otherMultDestBackSelT[back_size]=="D_TRAIN" >selected </#if>  value="D_TRAIN" >D-动车</option>
                        <option <#if costIncludeInnerVO.otherMultDestBackSelT[back_size]=="Z_TRAIN" >selected </#if>  value="Z_TRAIN" >Z-直达</option>
                        <option <#if costIncludeInnerVO.otherMultDestBackSelT[back_size]=="T_TRAIN" >selected </#if>  value="T_TRAIN" >T-特快</option>
                        <option <#if costIncludeInnerVO.otherMultDestBackSelT[back_size]=="K_TRAIN" >selected </#if>  value="K_TRAIN" >K-快速</option>
                        <option <#if costIncludeInnerVO.otherMultDestBackSelT[back_size]=="Y_TRAIN" >selected </#if>  value="Y_TRAIN" >Y-旅游专列</option>
                    </select>

                    <select id="traiSelS2" class="gi-w100 JS_checkbox_disabled" style="display:<#if costIncludeInnerVO.otherMultDestBackSel[back_size]!="TRAIN">none </#if>;"  <#if multDest!='Y'>disabled</#if> name="otherMultDestBackSelS" >
                        <option <#if costIncludeInnerVO.otherMultDestBackSelS[back_size]=="BUS_BLOCK" >selected </#if> value="BUS_BLOCK" >商务座</option>
                        <option <#if costIncludeInnerVO.otherMultDestBackSelS[back_size]=="SUPERSEAT" >selected </#if> value="SUPERSEAT" >特等座</option>
                        <option <#if costIncludeInnerVO.otherMultDestBackSelS[back_size]=="FIRST_SEAT" >selected </#if> value="FIRST_SEAT" >一等座</option>
                        <option <#if costIncludeInnerVO.otherMultDestBackSelS[back_size]=="TWO_SEAT" >selected </#if> value="TWO_SEAT" >二等座</option>
                        <option <#if costIncludeInnerVO.otherMultDestBackSelS[back_size]=="ADV_SOFT_SLE" >selected </#if> value="ADV_SOFT_SLE" >高级软卧</option>
                        <option <#if costIncludeInnerVO.otherMultDestBackSelS[back_size]=="SOFT_SLE" >selected </#if> value="SOFT_SLE" >软卧</option>
                        <option <#if costIncludeInnerVO.otherMultDestBackSelS[back_size]=="HARD_SLE" >selected </#if> value="HARD_SLE" >硬卧</option>
                        <option <#if costIncludeInnerVO.otherMultDestBackSelS[back_size]=="SOFT_SEAT" >selected </#if> value="SOFT_SEAT" >软座</option>
                        <option <#if costIncludeInnerVO.otherMultDestBackSelS[back_size]=="HARD_SEAT" >selected </#if> value="HARD_SEAT" >硬座</option>
                        <option <#if costIncludeInnerVO.otherMultDestBackSelS[back_size]=="NO_SEAT" >selected </#if> value="NO_SEAT" >无座</option>
                    </select>
                    <br id="traiSelSB2" style="display:<#if costIncludeInnerVO.otherMultDestBackSel[back_size]!="TRAIN">none </#if>;"/>
                     <label class="gi-ml20" id="traiSelSL2" style="display:<#if costIncludeInnerVO.otherMultDestBackSel[back_size]!="TRAIN">none </#if>;margin-right:40px;">
	                    <label style="margin-left:99px;">
	                    </label>
	                    <input type="hidden" name="otherMultDestBackTOR" value="${costIncludeInnerVO.otherMultDestBackTOR[back_size]}" />
                        <input class="JS_checkbox_disabled" type="checkbox" name="" <#if multDest!='Y'>disabled</#if>  <#if costIncludeInnerVO.otherMultDestBackTOR[back_size]=="Y">checked </#if> value="Y" onclick="triffCheck(this)"/>
                            注：火车票随机出票，不能保证上下铺/同一车厢/连座 ;
                    </label>
                    
                    <a href="javascript:" class="gi-del JS_del_stay" onclick="deleteDest(this)">删除</a>
                    <br>
                    <#assign back_size = back_size+1 />
                    </#list>
                    </#if>

                <label id="dest_back" style="display:none;">
                </label>
                </span>
                </p>
                <p>
                    <span class="JS_checkbox_switch_box">
                    <input type="checkbox"  class="JS_checkbox_switch" name="larTrans" <#if trans_other=='Y'>checked</#if> value="trans_other" />
                    <input class="input-text gi-w250 JS_checkbox_disabled placeholder" <#if trans_other!='Y'>disabled="disabled"</#if>
                           type="text"  name="tranOther"  value='${costIncludeInnerVO.tranOther!'输入其他交通信息'}'
                           data-placeholder="输入其他交通信息"  maxlength="100" required data-validate="true"/>
                    </span>
                </p>

            </dd>
        </dl>

        <div class="gi-hr"></div>


        <dl class="clearfix">
            <dt>

                当地用车 ：
            </dt>
            <dd>
                <p>
                    <label>
                        <input type="checkbox" name="localCar" <#if air_tour_car=='Y'>checked</#if> value="air_tour_car" />
                        空调旅游车（保证一人一正座位，车型大小根据游客实际人数安排）
                    </label>
                </p>

                <p>
                    <span class="JS_checkbox_switch_box">
                    <input type="checkbox" name="localCar"  <#if car_other=='Y'>checked</#if> value="car_other" class="JS_checkbox_switch"/>
                    <input class="input-text gi-w250 JS_checkbox_disabled placeholder" type="text"
                           data-placeholder="输入其他用车"    <#if car_other!='Y'>disabled="disabled"</#if> required maxlength="100"
                           data-validate="true" name="lcOther" value='${costIncludeInnerVO.lcOther!'输入其他用车'}' />
                    </span>
                </p>
            </dd>
        </dl>

        <div class="gi-hr"></div>

        <dl class="clearfix">
            <dt>

                住宿 <a class="JS_none" href="javascript:;">无</a>：
            </dt>
            <dd class="JS_radio_box">

                <div class="JS_radio_switch_box gi-other-box">
                    <div class="clearfix">
                        <input name="stay" value="stay_hotel"  <#if costIncludeInnerVO.stay=='stay_hotel'>checked</#if>  type="radio"  class="JS_radio_switch gi-stay-checkbox JS_other_judge_ctrl"/>
                        <div class="gi-stays" data-validate-extend="true" data-maxlength="500" data-tiplength="450">
                         <#if costIncludeInnerVO.staHotelN??& costIncludeInnerVO.staHotelN?size &gt; 0>
                          <#list costIncludeInnerVO.staHotelN as name>
                            <div class="gi-stay">
                                <input class="input-text JS_radio_disabled" type="text"<#if costIncludeInnerVO.stay!='stay_hotel'>disabled="disabled"</#if>  data-placeholder="输入酒店名称" 
                                       maxlength="100" data-validate="true" required  name="staHotelN" value=${name} />

                                 <select class="JS_radio_disabled" name="staSel" <#if costIncludeInnerVO.stay!='stay_hotel'>disabled="disabled"</#if>>
                                    <option data-placeholder="双人标准间"  <#if costIncludeInnerVO.staSel[name_index]=="DOU_STA_ROOM">selected </#if>   value="DOU_STA_ROOM">双人标准间</option>
                                    <option data-placeholder="双人间或三人间"<#if costIncludeInnerVO.staSel[name_index]=="TWO_OR_THREE_PEOPLE">selected </#if>   value="TWO_OR_THREE_PEOPLE">双人间或三人间</option>
                                </select>
                                <#if name_index gt 0>
                                     <a href="javascript:" class="gi-del JS_del_stay">删除</a>
                                </#if>
                            </div>
                         </#list>
                         <#else>
                           <div class="gi-stay">
                               <input class="input-text JS_radio_disabled" type="text"  data-placeholder="输入酒店名称" 
                                       maxlength="100" data-validate="true" required  name="staHotelN"  <#if costIncludeInnerVO.stay==null|costIncludeInnerVO.stay!='stay_hotel'>disabled</#if>  value='输入酒店名称' />         

                                 <select class="JS_radio_disabled" name="staSel"  <#if costIncludeInnerVO.stay==null|costIncludeInnerVO.stay!='stay_hotel'>disabled</#if>>
                                    <option data-placeholder="双人标准间"  selected    value="DOU_STA_ROOM">双人标准间</option>
                                    <option data-placeholder="双人间或三人间"  value="TWO_OR_THREE_PEOPLE">双人间或三人间</option>
                                </select>
                           </div>
                         </#if>
                            <div class="gi-stay-add">
                                <a href="javascript:" class="JS_add_stay">
                                    增加一条
                                </a>
                            </div>
                        </div>
                    </div>

                    <p>
                        <label>
                            <span class="gi-ml20 gi-block clearfix">
                            <input class="fl gi-inner-checkbox JS_radio_disabled" type="checkbox"  value="Y" <#if costIncludeInnerVO.stay==null|costIncludeInnerVO.stay!='stay_hotel'>disabled="disabled"</#if> <#if costIncludeInnerVO.stayCheck1=='Y'>checked</#if> name="stayCheck1"/>

                            <span class="fl gi-inner-text">住宿只含每人每天一床位。若出现单男单女，客人需补房差；<br>
                            若一大带一小报名，必须补房差，使用一间房；
                            </span>
                            </span>
                        </label>
                    </p>

                    <p>
                        <label>
                            <span class="gi-ml20">
                            <input class="JS_radio_disabled" type="checkbox" value="Y" <#if costIncludeInnerVO.stay==null|costIncludeInnerVO.stay!='stay_hotel'>disabled="disabled"</#if>   <#if costIncludeInnerVO.stayCheck2=='Y'>checked</#if>  name="stayCheck2"/>
                            如选择当地现补单房差价格则以当地实际发生为准，不保证与页面显示金额一致；
                            </span>
                        </label>
                    </p>
                </div>

                <p>
                    <span class="JS_radio_switch_box">
                    <input type="radio" name="stay" class="JS_radio_switch"  <#if costIncludeInnerVO.stay=='stay_other'>checked</#if>  value="stay_other"/>
                    <input class="input-text gi-w250 JS_radio_disabled placeholder" <#if costIncludeInnerVO.stay!='stay_other'>disabled="disabled"</#if> type="text"
                           data-placeholder="输入其他住宿信息" value="${costIncludeInnerVO.staOther!'输入其他住宿信息'}" data-validate="true" required
                           maxlength="500" name="staOther" />
                    </span>
                </p>
            </dd>
        </dl>

        <div class="gi-hr"></div>

        <dl class="clearfix">
            <dt>

                门票 ：
            </dt>
            <dd>
            	<p class="JS_checkbox_switch_box">
                <label>
                    <input type="checkbox" name="ticket" value="Y" <#if costIncludeInnerVO.ticket=='Y'>checked</#if> class="JS_checkbox_switch"/>
                  包含
                            <input type="text" class="input-text gi-w350 JS_checkbox_disabled placeholder" <#if costIncludeInnerVO.ticket==null|costIncludeInnerVO.ticket!='Y'>disabled="disabled"</#if> 
                                   data-placeholder="输入景点" name="ticketInfo" value="${costIncludeInnerVO.ticketInfo!'输入景点'}"
                                   maxlength="100"  data-validate="true" required />
                            首道大门票
                </label>               
                </p>
    			<p class="JS_checkbox_switch_box">
                <label>
                
                    <input type="checkbox" name="ticketTriff" value="Y" <#if costIncludeInnerVO.ticketTriff=='Y'>checked</#if> class="JS_checkbox_switch"/>
                       包含景区小交通
                            <input type="text"  class="input-text gi-w350 JS_checkbox_disabled placeholder" <#if costIncludeInnerVO.ticketTriff==null|costIncludeInnerVO.ticketTriff!='Y'>disabled="disabled"</#if> 
                                   data-placeholder="输入景点" name="ticketTriffInfo" value="${costIncludeInnerVO.ticketTriffInfo!''}"
                                   maxlength="100" data-validate="true" required />
                </label>
             	</p>
            </dd>
        </dl>


        <div class="gi-hr"></div>

        <dl class="clearfix">
            <dt>

                用餐 <a class="JS_none" href="javascript:;">无</a>：
            </dt>
            <dd class="JS_radio_box">
                <div class="JS_radio_switch_box">
                    <p>

                        <input name="dinner"  value="dinner_all" <#if costIncludeInnerVO.dinner=='dinner_all'>checked</#if>  class="input-text gi-w25 JS_radio_switch" type="radio"/>
                        含
                        <label>
                            <em class="gi-plr5">
                            <input class="input-text gi-w25 JS_checkbox_disabled" type="text" readonly="true" 
                                maxlength="10" name="breackfaskCount" value='${costIncludeInnerVO.breackfaskCount}' />
                            </em>
                            早
                        </label>
                        <label>
                            <em class="gi-plr5">
                            <input class="input-text gi-w25 JS_checkbox_disabled" type="text" readonly="true" 
                                 maxlength="10" name="lunchCount" value='${costIncludeInnerVO.lunchCount}' />
                            </em>
                            正（根据该行程明细中是否包含早餐中餐晚餐自动计算）
                        </label>

                    </p>

                    <p>
                    <span class="gi-ml20 JS_checkbox_switch_box">

                    <label>
                        <input type="checkbox" class="JS_radio_disabled JS_checkbox_switch"  name="dinnerSec" <#if dinner_price=='Y'>checked</#if>  <#if costIncludeInnerVO.dinner==null|costIncludeInnerVO.dinner!='dinner_all'>disabled</#if>   value="dinner_price" />
                        一顿正餐每人每餐
                    </label>

                    <input class="input-text gi-w100 placeholder JS_checkbox_disabled" <#if dinner_price!='Y'>disabled</#if> data-validate="true"
                           required type="text" data-placeholder="输入价格和币种" maxlength="10" name="dinnerPri" value='${costIncludeInnerVO.dinnerPri!'输入价格和币种'}' />

                    </span>
                    </p>

                    <p>
                    <span class="gi-ml20 JS_checkbox_switch_box">
                    <input type="checkbox" class="JS_radio_disabled JS_checkbox_switch" name="dinnerSec" <#if dinner_tab=='Y'>checked</#if>  value="dinner_tab" <#if costIncludeInnerVO.dinner==null|costIncludeInnerVO.dinner!='dinner_all'>disabled</#if> />
                    正餐
                    <label>
                        <input class="input-text gi-w25 JS_checkbox_disabled" type="text"  <#if dinner_tab!='Y'>disabled</#if>
                               data-validate="true" required maxlength="10" name="dinnerPeo" value='${costIncludeInnerVO.dinnerPeo}' />
                        人
                    </label>

                    <label>
                        <input class="input-text gi-w25 JS_checkbox_disabled" type="text"  <#if dinner_tab!='Y'>disabled</#if>
                               data-validate="true" required maxlength="10" name="dinnerTab" value='${costIncludeInnerVO.dinnerTab}' />
                        桌
                    </label>
                    </span>
                    </p>

                    <p>
                    <span class="gi-ml20 JS_checkbox_switch_box">
                    <input type="checkbox" class="JS_radio_disabled JS_checkbox_switch" name="dinnerSec" <#if dinner_food=='Y'>checked</#if>  value="dinner_food"  <#if costIncludeInnerVO.dinner==null|costIncludeInnerVO.dinner!='dinner_all'>disabled</#if> />
                    <label>
                        <input class="input-text gi-w25 JS_checkbox_disabled" type="text"   <#if dinner_food!='Y'>disabled</#if>
                               data-validate="true" required maxlength="10" name="dinnerFood" value='${costIncludeInnerVO.dinnerFood}' />
                        菜
                    </label>

                    <label>
                        <input class="input-text gi-w25 JS_checkbox_disabled" type="text"  <#if dinner_food!='Y'>disabled</#if>
                               data-validate="true" required maxlength="10"  name="dinnerSoup" value='${costIncludeInnerVO.dinnerSoup}'/>
                        汤
                    </label>
                    </span>
                    </p>
                </div>
                <p>
                    <label>
                        <input name="dinner" value="dinner_self_care" type="radio" <#if costIncludeInnerVO.dinner=='dinner_self_care'>checked</#if>  class="JS_radio_switch"/>
                        酒店含早，正餐自理
                    </label>
                </p>

                <p>
                    <label>
                        <input name="dinner" value="dinner_all_self_care" type="radio"  <#if costIncludeInnerVO.dinner=='dinner_all_self_care'>checked</#if>  class="JS_radio_switch"/>
                        全程用餐自理
                    </label>
                </p>

                <p>
                    <span class="JS_radio_switch_box">
                    <input name="dinner" value="dinner_other" type="radio" class="JS_radio_switch"  <#if costIncludeInnerVO.dinner=='dinner_other'>checked</#if> />
                    <input class="input-text gi-w250 JS_radio_disabled placeholder" data-placeholder="自定义"
                           type="text" <#if costIncludeInnerVO.dinner!='dinner_other'>disabled="disabled"</#if> data-validate="true" required
                           maxlength="100" name="dinnerOther" value='${costIncludeInnerVO.dinnerOther!'自定义'}' />
                    </span>
                </p>
            </dd>
        </dl>
        <div class="gi-hr"></div>

        <dl class="clearfix">
            <dt>

                导游服务 ：
            </dt>
            <dd>
                <input type="text" class="input-text gi-w250" maxlength="250"  name="tourGuiSer" value="${costIncludeInnerVO.tourGuiSer}" />
            </dd>
        </dl>
        <div class="gi-hr"></div>

        <dl class="clearfix">
            <dt>

                儿童价标准 ：
            </dt>
            <dd class="JS_radio_box">
                <div class="JS_radio_switch_box">
                    <p>
                        <input type="radio" class="JS_radio_switch JS_child_include_switch" name="chilPriStan" <#if costIncludeInnerVO.chilPriStan=='children_price'>checked</#if>  value="children_price"  />
                        创建儿童价标准
                        <span class="JS_child_error hide " style="color:red">至少选择一项</span>
                    </p>

                    <p>
                    <span class="gi-ml20 JS_checkbox_switch_box">
                    <input type="checkbox" name="chilPriStanSec" value="chil_age"  <#if chil_age=='Y'>checked</#if>   <#if costIncludeInnerVO.chilPriStan==null|costIncludeInnerVO.chilPriStan!='children_price'>disabled</#if>   class="JS_radio_disabled JS_checkbox_switch JS_child_checkbox"/>
                    年龄；适用于
                    <input class="input-text gi-w75 JS_checkbox_disabled" <#if chil_age!='Y'>disabled</#if>  data-validate="true" required
                           digits="true" maxlength="6" type="text" name="chilAge1" value='${costIncludeInnerVO.chilAge1}' />
                    至
                    <input class="input-text gi-w75 JS_checkbox_disabled" <#if chil_age!='Y'>disabled</#if> data-validate="true" required
                           digits="true" maxlength="6" type="text"  name="chilAge2"  value='${costIncludeInnerVO.chilAge2}'  />
                    周岁（不含）的儿童
                    </span>
                    </p>

                    <p>
                    <span class="gi-ml20 JS_checkbox_switch_box">
                    <input type="checkbox" class="JS_radio_disabled JS_checkbox_switch JS_child_checkbox" <#if chil_hei=='Y'>checked</#if>  <#if costIncludeInnerVO.chilPriStan==null|costIncludeInnerVO.chilPriStan!='children_price'>disabled</#if>   name="chilPriStanSec" value="chil_hei"/>
                    身高；适用于
                    <input class="input-text gi-w75 JS_checkbox_disabled" <#if chil_hei!='Y'>disabled</#if> data-validate="true" required
                           digits="true" maxlength="6" type="text" name="chilHei1" value='${costIncludeInnerVO.chilHei1}' />
                        至
                    <input class="input-text gi-w75 JS_checkbox_disabled"  <#if chil_hei!='Y'>disabled</#if>  data-validate="true" required
                           digits="true" maxlength="6" type="text" name="chilHei2" value='${costIncludeInnerVO.chilHei2}' />
                    cm（不含）以下的儿童。
                    </span>
                    </p>
                </div>

                <div class="JS_radio_switch_box">
                    <p>
                        <input type="radio" class="JS_radio_switch JS_child_include_switch JS_child_include_switch_ctrl " name="chilPriStan"  <#if costIncludeInnerVO.chilPriStan=='equal_people'>checked</#if>  value="equal_people" />
                        此产品儿童与成人同价。
                    </p>
                </div>

                <div class="JS_radio_switch_box">
                    <p>
                        <input type="radio" class="JS_radio_switch JS_child_include_switch JS_child_include_switch_ctrl " name="chilPriStan"  <#if costIncludeInnerVO.chilPriStan=='not_sell_child'>checked</#if>  value="not_sell_child" />
                        此产品不支持儿童购买。
                    </p>
                </div>

            </dd>
        </dl>

        <div class="JS_child_include_content" <#if costIncludeInnerVO.chilPriStan=='equal_people' || costIncludeInnerVO.chilPriStan=='not_sell_child'>style="display: none;"</#if>>
            <dl class="clearfix">
                <dt>

                    儿童价费用包含 ：
                </dt>
                <dd class="JS_radio_box">
                    <p>

                        <span class="clearfix gi-block JS_radio_switch_box">

                            <span class="fl gi-block">
                            <input name="chilCostIncl"  value="children_include" type="radio" class="JS_radio_switch"   <#if costIncludeInnerVO.chilCostIncl=='children_include'>checked</#if>   />
                            儿童价包含：
                            </span>

                            <span class="fl gi-block">
                            <label>
                                <span class="gi-mr15">
                                <input type="checkbox" class="JS_radio_disabled" name="chilCostInclCheck"   <#if CHILD_ONE_TRAIN=='Y'>checked</#if> value="CHILD_ONE_TRAIN"  <#if costIncludeInnerVO.chilCostIncl==null|costIncludeInnerVO.chilCostIncl!='children_include'>disabled</#if> />
                                单程机票
                                </span>
                            </label>

                            <label>
                                <span class="gi-mr15">
                                <input type="checkbox" class="JS_radio_disabled" name="chilCostInclCheck" value="CHILD_ROUND_TRAIN" <#if CHILD_ROUND_TRAIN=='Y'>checked</#if> value="CHILD_ONE_TRAIN" <#if costIncludeInnerVO.chilCostIncl==null|costIncludeInnerVO.chilCostIncl!='children_include'>disabled</#if> />
                                往返飞机票
                                </span>
                            </label>

                            <label>
                                <span class="gi-mr15">
                                <input type="checkbox" class="JS_radio_disabled" name="chilCostInclCheck" value="CHILD_PARK"  <#if CHILD_PARK=='Y'>checked</#if> value="CHILD_ONE_TRAIN" <#if costIncludeInnerVO.chilCostIncl==null|costIncludeInnerVO.chilCostIncl!='children_include'>disabled</#if> />
                                当地旅游车位
                                </span>
                            </label>
                            <label>
                                <span class="gi-mr15">
                                <input type="checkbox" class="JS_radio_disabled" name="chilCostInclCheck" value="CHILD_GUIDE"  <#if CHILD_GUIDE=='Y'>checked</#if> value="CHILD_ONE_TRAIN" <#if costIncludeInnerVO.chilCostIncl==null|costIncludeInnerVO.chilCostIncl!='children_include'>disabled</#if> />
                                导游服务
                                </span>
                            </label>
                            <label>
                                <span class="gi-mr15">
                                <input type="checkbox" class="JS_radio_disabled" name="chilCostInclCheck"  <#if CHILD_HALF_PRICE=='Y'>checked</#if>  value="CHILD_HALF_PRICE" <#if costIncludeInnerVO.chilCostIncl==null|costIncludeInnerVO.chilCostIncl!='children_include'>disabled</#if> />
                                半价正餐
                                </span>
                            </label>
                            <br/>
                            <label>
                                <span class="gi-mr15">
                                <input type="checkbox" class="JS_radio_disabled" name="chilCostInclCheck"  <#if CHILD_SELF=='Y'>checked</#if>  value="CHILD_SELF" <#if costIncludeInnerVO.chilCostIncl==null|costIncludeInnerVO.chilCostIncl!='children_include'>disabled</#if> />
                                不含床位不含早餐
                                </span>
                            </label>
                            <label>
                                <span class="gi-mr15">
                                <input type="checkbox" class="JS_radio_disabled" name="chilCostInclCheck"  <#if CHIL_TRA_SELF=='Y'>checked</#if>   value="CHIL_TRA_SELF" <#if costIncludeInnerVO.chilCostIncl==null|costIncludeInnerVO.chilCostIncl!='children_include'>disabled</#if> />
                                如产生火车票，门票等费用请自理
                                </span>
                            </label>
                            </span>
                        </span>

                    </p>

                    <div class="JS_radio_switch_box clearfix">
                        <p class="gi-block">
                            <input name="chilCostIncl" value="children_self" type="radio" class="JS_radio_switch" <#if costIncludeInnerVO.chilCostIncl=='children_self'>checked</#if> />
                            自定义儿童价包含
                        </p>
                        <textarea class="input-text gi-w500 gi-h150 JS_radio_disabled gi-ml15"  <#if costIncludeInnerVO.chilCostIncl!='children_self'>disabled="disabled"</#if>
                            name="chilOther" data-validate="true" maxlength="250" required>${costIncludeInnerVO.chilOther}</textarea>
                    </div>
                </dd>
            </dl>
        </div>

        <div class="gi-hr"></div>

        <dl class="clearfix">
            <dt>
                其他 ：
            </dt>
            <dd class="clearfix">

                <div class="JS_checkbox_switch_box gi-other-box">
                    <div class="gi-other-checkbox">
                        <input type="checkbox" class="JS_checkbox_switch JS_other_judge_ctrl" name="costOther" value="Y"  <#if costIncludeInnerVO.costOther=='Y'>checked</#if> />
                    </div>

                    <div class="gi-others" data-validate-extend="true" data-maxlength="200" data-tiplength="150">                           
                        <#if costIncludeInnerVO.costOtherInp??& costIncludeInnerVO.costOtherInp?size &gt; 0>
                         <#list costIncludeInnerVO.costOtherInp as oinp>
                          <div class="gi-other">
                             <input type="text" class="input-text gi-w500 JS_checkbox_disabled" data-validate="true"  value="${oinp}"
                                   required maxlength="500" name="costOtherInp" <#if costIncludeInnerVO.costOther!='Y'>disabled</#if> />
                             <#if oinp_index gt 0>
                                <a href="javascript:" class="gi-del gi-other-del">删除</a>
                             </#if>
                          </div>
                         </#list>
                        <#else>
                          <div class="gi-other">
                             <input type="text" class="input-text gi-w500 JS_checkbox_disabled" data-validate="true" 
                                   required maxlength="500" name="costOtherInp" <#if costIncludeInnerVO.costOther!='Y'>disabled</#if> />
                          </div>
                        </#if>
                        <div class="clearfix gi-w500 gi-other-add">
                            <a href="javascript:" class="fr JS_other_add_btn">增加一条</a>
                        </div>
                        
                    </div>
                </div>
            </dd>
        </dl>
                    </div>
                    <!--费用包含 国内 结束-->

                    <p>
                        费用不包含说明：
                    </p>
                    <!--费用不包含 国内 开始-->
                    <div class="gi-form JS_inner_not_include_internal">
  

        <dl class="clearfix">
            <dt>
                单房差 ：
            </dt>
            <dd>

                <label>
                    <input type="checkbox" name="costExclude" value="001" <#if CNI001=='Y'>checked <#elseif costExcludeInnerVO.costExclude==null>checked</#if> /><em>
                    产生单人出行需补房差，游客可在填写订单时勾选附加产品中的相关房差购买；</em>
                </label>
            </dd>
        </dl>
        <dl class="clearfix">
            <dt>
                自理项目 ：
            </dt>
            <dd>
                <label>
                    <input type="checkbox" name="costExclude" value="002" <#if CNI002=='Y'>checked <#elseif costExcludeInnerVO.costExclude==null>checked</#if> /><em>
                    行程所列自理项目</em>
                </label>
            </dd>
        </dl>
        <dl class="clearfix">
            <dt>
                赠送项目 ：
            </dt>
            <dd>
                <label>
                    <input type="checkbox" name="costExclude" value="003" <#if CNI003=='Y'>checked <#elseif costExcludeInnerVO.costExclude==null>checked</#if> /><em>
                    所有行程内标明赠送项目，如不参加，视为自动放弃，不做退费处理</em>
                </label>
            </dd>
        </dl>
        <dl class="clearfix">
            <dt>
                保险 ：
            </dt>
            <dd>
                <label>
                    <input type="checkbox" name="costExclude" value="004" <#if CNI004=='Y'>checked <#elseif costExcludeInnerVO.costExclude==null>checked</#if> /><em>
                    本产品不含旅游人身意外险,我们强烈建议游客购买。游客可在填写订单时勾选附加产品中的相关保险购买</em>
                </label>
            </dd>
        </dl>
        <dl class="clearfix">
            <dt>
                其他 ：
            </dt>
            <dd class="JS_checkbox_switch_box gi-other-box clearfix">
                <div class="gi-ni-other-checkbox fl">
                    <input type="checkbox" name="costExclude" value="005" <#if CNI005=='Y'>checked</#if> class="JS_checkbox_switch JS_other_judge_ctrl"/>
                </div>
                <div class="gi-ni-others fl" data-validate-extend="true" data-maxlength="500" data-tiplength="450">

                  <#if costExcludeInnerVO.costExcludeInput??& costExcludeInnerVO.costExcludeInput?size &gt; 0>
                         <#list costExcludeInnerVO.costExcludeInput as excludeIn>
                     <div class="gi-ni-other">
                        <input type="text" name="costExcludeInput" value=${excludeIn} class="input-text JS_checkbox_disabled placeholder gi-w500" 
                               <#if CNI005!='Y'>disabled="disabled"</#if> data-placeholder="其他" data-validate="true" required maxlength="500" />
                          <#if excludeIn_index gt 0>
                                <a href="javascript:" class="gi-del gi-ni-other-del">删除</a>
                          </#if>
                     </div>
                        </#list>
                   <#else>
                    <div class="gi-ni-other">
                        <input type="text" name="costExcludeInput" value="其他" class="input-text JS_checkbox_disabled placeholder gi-w500" 
                               data-placeholder="其他" disabled="disabled" data-validate="true" required maxlength="500"/>
                    </div>
                   </#if>
                    <div class="gi-ni-other-add">
                        <a href="javascript:" class="gi-ni-other-add-btn">增加一条</a>
                    </div>
                </div>
            </dd>
        </dl>

            </div>
                    <!--费用不包含 国内 结束-->

                    <div class="gi-ctrl clearfix">
                        <div class="fr">
                            <a class="gi-button gi-mr15 JS_button_save" href="javascript:;">保存</a>
                        </div>
                    </div>
                </form>
            </div>
            <!--线路行程 结束-->

        </div>
    </div>
</div>

<!--脚本模板使用 开始-->
<div class="JS_template">

</div>
<!--脚本模板使用 结束-->

<!--内层模板 开始-->
<div class="JS_template_inner">

     <!--其他 开始-->
    <div class="gi-other">
        <input type="text" class="input-text gi-w500 JS_checkbox_disabled" value="" data-validate="true" required
               maxlength="500" name="costOtherInp" />
        <a href="javascript:" class="gi-del gi-other-del">删除</a>
    </div>
    <!--其他 结束--> 

     <!--住宿 开始-->
    <div class="gi-stay">
        <input class="input-text JS_radio_disabled" type="text" data-placeholder="输入酒店名称" value="" required data-validate="true"
               maxlength="100"  name="staHotelN"/>

        <select class="JS_radio_disabled"  name="staSel">
            <option data-placeholder="双人标准间" selected="selected"  value="DOU_STA_ROOM" >双人标准间</option>
            <option data-placeholder="双人间或三人间"  value="TWO_OR_THREE_PEOPLE" >双人间或三人间</option>
        </select>

        <a href="javascript:" class="gi-del JS_del_stay">删除</a>
    </div>
    <!--住宿 结束-->

    <!--不包含 其他 开始-->
    <div class="gi-ni-other">
        <input type="text" class="input-text JS_checkbox_disabled gi-w500" value="" name="costExcludeInput"
               data-validate="true" maxlength="500" required/>
        <a href="javascript:" class="gi-del gi-ni-other-del">删除</a>
    </div>
    <!--不包含 其他 结束-->

</div>
<!--内层模板 结束-->

<script src="http://pic.lvmama.com/min/index.php?f=/js/new_v/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>

<!--新增脚本文件-->
<script src="http://pic.lvmama.com/js/backstage/vst-group-input.js"></script>
<!--<script src="http://pic.lvmama.com/js/backstage/vst-validate.js"></script>-->
<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>
<script  type="text/javascript" >
function deleteDest(va){
	if(!$("#destCheck").is(':checked')){
		return;
	}
	$(va).prev().remove();
	$(va).prev().remove();
	$(va).prev().remove();
	$(va).prev().remove();
	$(va).prev().remove();
	$(va).prev().remove();
	$(va).prev().remove();
	$(va).prev().remove();
	$(va).prev().remove();
	$(va).next().remove();
	$(va).remove();
}
function addGoDest(){
	if($("select[name='otherMultDestGoDis']").size()>=10){
		return;
	}
	if(!$("#destCheck").is(':checked')){
		return;
	}
	$("#dest_go").before($("#dest_go_hidden").html());
}
function addBackDest(){
	if($("select[name='otherMultDestBackDis']").size()>=10){
		return;
	}
	if(!$("#destCheck").is(':checked')){
		return;
	}
	$("#dest_back").before($("#dest_back_hidden").html());
}
function trafficChange(val,no){
  if(val == 'TRAIN'){
  	$("#freeSel"+no).after($("#free_hidden"+no).html());
  }else{
  	$("#freeSel"+no).next("#traiSelT"+no).remove();
  	$("#freeSel"+no).next("#traiSelS"+no).remove();
  	$("#freeSel"+no).next("#traiSelS"+no).remove();
  	$("#freeSel"+no).next("#traiSelS"+no).remove();
  }
}
function trafficChange1(val,no){
  if($(val).val() == 'TRAIN'){
  	$(val).next("#traiSelT"+no).show();
  	$(val).next("#traiSelT"+no).next("#traiSelS"+no).show();
  	$(val).next("#traiSelT"+no).next("#traiSelS"+no).next("#traiSelSB"+no).show();
  	$(val).next("#traiSelT"+no).next("#traiSelS"+no).next("#traiSelSB"+no).next("#traiSelSL"+no).show();
  }else{
  	$(val).next("#traiSelT"+no).hide();
  	$(val).next("#traiSelT"+no).next("#traiSelS"+no).hide();
  	$(val).next("#traiSelT"+no).next("#traiSelS"+no).next("#traiSelSB"+no).hide();
  	$(val).next("#traiSelT"+no).next("#traiSelS"+no).next("#traiSelSB"+no).next("#traiSelSL"+no).hide();
  }
}
function triffCheck(val){
	if($(val).prop("checked")){
		$(val).prev().val("Y");
	}else{
		$(val).prev().val("N");
	}
}

/**
 * jQuery validator 验证
 * name 不能重复
 */
$(function () {
	//页面关联则不可修改
	var $document = $(document);
	var editDialog;
	     if($("#noEditFlag").val() == "true"){
	     	$document.unbind("click");
	       	$("input[type='radio']").attr("disabled",true);
	       	$("input[type='checkbox']").attr("disabled",true);
	       	$("input").attr("readonly",true);
	       	$("select").prop("disabled", true);
	//       	$("div.gi-header a").removeAttr("href");
       	}

       	$("#toEdit").click(function () {
       	if($("#modelVersion").val() == "true"){
       		var url = "/vst_admin/dujia/group/route/cost/editProdRouteCost.do?lineRouteId=${lineRouteId}&productId=${productId}&productType=${productType}";
       	}else{
       		var url = "/vst_admin/prod/prodLineRoute/editprodroutecost.do?lineRouteId=${lineRouteId}&productId=${productId}";
       	}
      		editDialog = new xDialog(url,{},{title:"编辑费用说明",iframe:true, width:1000, height:450});
  		  });
    });	
 (function () {
    //内容不能是占位内容
    jQuery.validator.addMethod("placeHolderTest", function (value, element) {
        var $ele = $(element);
        var placeHolderText = $ele.data("placeholder");
        return placeHolderText !== value;

    }, "必须输入内容");

    jQuery.validator.addClassRules("placeholderTest", {
        placeHolderTest: true
    });

    var $document = $(document);
    $document.on("click", ".JS_button_save,.JS_button_save_and_next", function () {

        var $this = $(this);
        var $giForm = $this.parents(".gi-form");

        //大表单
        var $form = $giForm.find("form").eq(0);

        //去除placeholder
        var $placeholder = $giForm.find('[data-validate="true"][data-placeholder]:not([disabled])');
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
        (function () {
            var validate = $form.validate();
            var $input = $form.find('[data-validate="true"]:not([disabled])');
            var $childError = $(".JS_child_error");

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
            });
            
            if($('input[name="chilPriStan"]:checked').val()=="children_price"){
                // 复选必须选一个
                var $validateChildCheckbox =$form.find('.JS_child_checkbox');
                var thisValidate = validateChildCheckbox($validateChildCheckbox);
               
                if(isValidate){
                	 isValidate=thisValidate;
                }
                if(!thisValidate){
                    $childError.show();
                }else {
                    $childError.hide();
                } 
            }else{
                $childError.hide();
            }

            $document.on("change",".JS_child_include_switch",function(){
                var chilPriStan = $('input[name="chilPriStan"]:checked').val();
                if(chilPriStan=="equal_people" || chilPriStan=="not_sell_child"){
                    $childError.hide();
                }
            });

            $document.on("change",".JS_child_checkbox",function(){
                $childError.hide();
            });

        })();

        (function () {
            //行程线路 表单
            var $day = $giForm.find(".JS_day");
            $day.each(function (index) {

                //var $smallForm = $day.eq(i).find("form");

                var $smallForm = $day.eq(index).find("form");

                var validate = $smallForm.validate();
                var $input = $smallForm.find('[data-validate="true"]:not([disabled])');

                $input.each(function (index) {
                    var $required = $input[index];
                    var ret = validate.element($required);
                    if (!ret) {
                        isValidate = false;
                    }
                });

            });

        })();

        //验证通过
        var alertObj;
        if (isValidate) {
           addRouteCostInner($this);
        }else {
            alertObj = $.saveAlert({
                "width": 250,
                "type": "danger",
                "text": "请完成必填填写项并确认填写正确"
            });
        }
    });

    function addRouteCostInner($this){
        //判断当前保存状态
        if ($this.data("saving")) {
            return;
        }
        //改变保存按钮状态
        changeSaveButtonStatus(true);

        $.ajax({
            url: "/vst_admin/dujia/group/route/cost/saveCostInner.do",
            data: $(".costInnerForm").serialize(),
            type: "POST",
            dataType: "JSON",
            success: function(result) {
                if (result.code=="success") {
                    window.location.reload();
                    $.saveAlert({"width": 150,"type": "success","text": result.message});
                } else {
                    $.saveAlert({"width": 250,"type": "danger","text": result.message});
                }

                //改变保存按钮状态
                changeSaveButtonStatus(false);
            },
            error: function() {
                //改变保存按钮状态
                changeSaveButtonStatus(false);
                console.log("Call addRouteCostInner method occurs error");
                $.alert('网络服务异常, 请稍后重试');
            }
        });
    }

    //改变 保存按钮的状态（isLoading：true 保存前 false 保存结束后）
    function changeSaveButtonStatus(isLoading) {
        var $form = $(".costInnerForm");
        var $saveButton = $form.find(".JS_button_save");

        if (isLoading) {
            $saveButton.html("保存中");
            $saveButton.attr("data-saving", true);
            $saveButton.addClass("disabled");
        } else {
            $saveButton.html("保存");
            $saveButton.attr("data-saving", false);
            $saveButton.removeClass("disabled");
        }
    }
})();

$(function () {

    window.validateExtend = validateExtend;

    function validateExtend($extend) {

        var isValidate = false;
        var $this = $extend;
        var maxLength = parseInt($this.data("maxlength"));
        var tipLength = parseInt($this.data("tiplength"));

        var $input = $this.find("input[type=text]");
        var length = 0;
        $input.each(function () {
            var $this = $(this);
            if($this.val() == $this.attr("data-placeholder")) {
                //Do nothing
            } else {
                length += $this.val().length;
            }
        });

        var $error;

        if (length > maxLength) {

            $error = $this.find(".gi-extend-error-tips");
            $error.remove();

            $this.addClass("gi-extend-error");
            $error = $("<i class='gi-extend-error-tips'>范围内字数超过" + maxLength + "个</i>");
            $this.append($error);
            isValidate = false;
        } else if (length > tipLength) {

            $error = $this.find(".gi-extend-error-tips");
            $error.remove();

            $error = $("<i class='gi-extend-error-tips'>您还可以输入字数：" + (maxLength - length) + "</i>");

            $this.removeClass("gi-extend-error");

            $this.append($error);
            isValidate = true;
        } else {
            $error = $this.find(".gi-extend-error-tips");
            $error.remove();
            $this.removeClass("gi-extend-error");

            isValidate = true;
        }

        return isValidate;

    }
    
    window.validateChildCheckbox = validateChildCheckbox;

    function validateChildCheckbox($checkboxes){
        var isValidate = false;
        $checkboxes.each(function(){
            var $this = $(this);
            if($this.prop("checked")){
                isValidate = true;
            }
        });
        return isValidate;
    }

});

	//移除保存按钮
	isRemoveSaveButton();
	
	function isRemoveSaveButton(){
		if($("#isView",parent.document).val()=='Y' || $("#isView",parent.top.document).val()=='Y'){
			//移除保存,增加一条，删除按钮
			$("a[class*=JS_button_save],a[class*=JS_add_stay],a[class*=JS_del_stay],a[class*=JS_other_add_btn],a[class*=gi-other-del],a[class*=gi-ni-other-add-btn],a[class*=gi-ni-other-del]").remove();
		}
	}
</script>
</body>
</html>
