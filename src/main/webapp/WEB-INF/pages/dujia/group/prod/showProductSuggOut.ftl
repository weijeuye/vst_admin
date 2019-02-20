<#-- 是否加床：标间或大床房不可指定-->
<#if travelAlertOutsideVO.addBedCheck??>
<#list travelAlertOutsideVO.addBedCheck as node>
    <#if node == "not_specified">
       <#assign not_specified = 'Y' />
    </#if>
</#list>
</#if>

<#-- 出签说明 -->
<#if travelAlertOutsideVO.sign??>
<#list travelAlertOutsideVO.sign as node>
    <#if node == "sign">
       <#assign sign = 'Y' />
    </#if>
</#list>
</#if>

<#-- 出签说明 -->
<#if travelAlertOutsideVO.pinToSign??>
<#list travelAlertOutsideVO.pinToSign as node>
    <#if node == "pin_to_sign">
       <#assign pin_to_sign = 'Y' />
    </#if>
</#list>
</#if>

<#-- 蜜月优惠 -->
<#if travelAlertOutsideVO.honeymoon??>
<#list travelAlertOutsideVO.honeymoon as node>
    <#if node == "honey_noon">
       <#assign honey_noon = 'Y' />
    </#if>
</#list>
</#if>

<#-- 其他-->
<#if travelAlertOutsideVO.other??>
<#list travelAlertOutsideVO.other as node>
    <#if node == "000">
       <#assign other_000 = 'Y' />
    </#if>
    <#if node == "001">
       <#assign other_001 = 'Y' />
    </#if>
    <#if node == "002">
       <#assign other_002 = 'Y' />
    </#if>
    <#if node == "003">
       <#assign other_003 = 'Y' />
    </#if>
    <#if node == "004">
       <#assign other_004 = 'Y' />
    </#if>
    <#if node == "005">
       <#assign other_005 = 'Y' />
    </#if>
    <#if node == "006">
       <#assign other_006 = 'Y' />
    </#if>
    <#if node == "007">
       <#assign other_007 = 'Y' />
    </#if>
    <#if node == "008">
       <#assign other_008 = 'Y' />
    </#if>
    <#if node == "009">
       <#assign other_009 = 'Y' />
    </#if>
    <#if node == "010">
       <#assign other_010 = 'Y' />
    </#if>
    <#if node == "011">
       <#assign other_011 = 'Y' />
    </#if>
    <#if node == "012">
       <#assign other_012 = 'Y' />
    </#if>
    
</#list>
</#if>

<#-- 特殊接待限制-->
<#if travelAlertOutsideVO.reception??>
<#list travelAlertOutsideVO.reception as node>
    <#if node == "000">
       <#assign special_reception_limit_000 = 'Y' />
    </#if>
    <#if node == "001">
       <#assign special_reception_limit_001 = 'Y' />
    </#if>
    <#if node == "002">
       <#assign special_reception_limit_002 = 'Y' />
    </#if>
    <#if node == "003">
       <#assign special_reception_limit_003 = 'Y' />
    </#if>
    <#if node == "004">
       <#assign special_reception_limit_004 = 'Y' />
    </#if>
    <#if node == "005">
       <#assign special_reception_limit_005 = 'Y' />
    </#if>
    <#if node == "006">
       <#assign special_reception_limit_006 = 'Y' />
    </#if>
    <#if node == "007">
       <#assign special_reception_limit_007 = 'Y' />
    </#if>
    <#if node == "008">
       <#assign special_reception_limit_008 = 'Y' />
    </#if>
</#list>
</#if>

<#-- 团队酒店描述-->
<#if travelAlertOutsideVO.hotelBewrite??>
<#list travelAlertOutsideVO.hotelBewrite?keys as key>
	<#if key == "HB1">
	       <#assign line_hotelBewrite_001 = 'Y' />
	       <#assign line_hotelBewrite_001_value = travelAlertOutsideVO.hotelBewrite["HB1"] />
	       <#assign is_line_hotelBewrite_001_all_selected = (line_hotelBewrite_001_value == "001,002,003,004,005")?string('Y','N') />
	</#if>
	<#if key == "HB2">
	       <#assign line_hotelBewrite_002 = 'Y' />
	       <#assign line_hotelBewrite_002_value = travelAlertOutsideVO.hotelBewrite["HB2"] />
	       <#assign is_line_hotelBewrite_002_all_selected = (line_hotelBewrite_002_value == "001,002,003")?string('Y','N') />
	</#if>
	<#if key == "HB3">
	       <#assign line_hotelBewrite_003 = 'Y' />
	       <#assign line_hotelBewrite_003_value = travelAlertOutsideVO.hotelBewrite["HB3"] />
	       <#assign is_line_hotelBewrite_003_all_selected = (line_hotelBewrite_003_value == "001,002,003,004,005,006")?string('Y','N') />
	</#if>
	<#if key == "HB4">
	       <#assign line_hotelBewrite_004 = 'Y' />
	       <#assign line_hotelBewrite_004_value = travelAlertOutsideVO.hotelBewrite["HB4"] />
	       <#assign is_line_hotelBewrite_004_all_selected = (line_hotelBewrite_004_value == "001,002,003,004")?string('Y','N') />
	</#if>
	<#if key == "HB5">
	       <#assign line_hotelBewrite_005 = 'Y' />
	       <#assign line_hotelBewrite_005_value = travelAlertOutsideVO.hotelBewrite["HB5"] />
	       <#assign is_line_hotelBewrite_005_all_selected = (line_hotelBewrite_005_value == "001,002,003,004")?string('Y','N') />
	</#if>
	<#if key == "HB6">
	       <#assign line_hotelBewrite_006 = 'Y' />
	       <#assign line_hotelBewrite_006_value = travelAlertOutsideVO.hotelBewrite["HB6"] />
	       <#assign is_line_hotelBewrite_006_all_selected = (line_hotelBewrite_006_value == "001,002,003,004")?string('Y','N') />
	</#if>
	<#if key == "HB7">
	       <#assign line_hotelBewrite_007 = 'Y' />
	       <#assign line_hotelBewrite_007_value = travelAlertOutsideVO.hotelBewrite["HB7"] />
	       <#assign is_line_hotelBewrite_007_all_selected = (line_hotelBewrite_007_value == "001,002,003,004")?string('Y','N') />
	</#if>
	<#if key == "HB8">
	       <#assign line_hotelBewrite_008 = 'Y' />
	       <#assign line_hotelBewrite_008_value = travelAlertOutsideVO.hotelBewrite["HB8"] />
	       <#assign is_line_hotelBewrite_008_all_selected = (line_hotelBewrite_008_value == "001,002,003,004")?string('Y','N') />
	</#if>
	<#if key == "HB9">
	       <#assign line_hotelBewrite_009 = 'Y' />
	       <#assign line_hotelBewrite_009_value = travelAlertOutsideVO.hotelBewrite["HB9"] />
	       <#assign is_line_hotelBewrite_009_all_selected = (line_hotelBewrite_009_value == "001,002,003,004,005,006")?string('Y','N') />
	</#if>
	<#if key == "HB10">
	       <#assign line_hotelBewrite_010 = 'Y' />
	       <#assign line_hotelBewrite_010_value = travelAlertOutsideVO.hotelBewrite["HB10"] />
	       <#assign is_line_hotelBewrite_010_all_selected = (line_hotelBewrite_010_value == "001,002,003")?string('Y','N') />
	</#if>
	<#if key == "HB11">
	       <#assign line_hotelBewrite_011 = 'Y' />
	       <#assign line_hotelBewrite_011_value = travelAlertOutsideVO.hotelBewrite["HB11"] />
	       <#assign is_line_hotelBewrite_011_all_selected = (line_hotelBewrite_011_value == "001,002,003,004,005")?string('Y','N') />
	</#if>
	<#if key == "HB12">
	       <#assign line_hotelBewrite_012 = 'Y' />
	       <#assign line_hotelBewrite_012_value = travelAlertOutsideVO.hotelBewrite["HB12"] />
	       <#assign is_line_hotelBewrite_012_all_selected = (line_hotelBewrite_012_value == "001,002,003,004,005,006")?string('Y','N') />
	</#if>
	<#if key == "HB13">
	       <#assign line_hotelBewrite_013 = 'Y' />
	       <#assign line_hotelBewrite_013_value = travelAlertOutsideVO.hotelBewrite["HB13"] />
	       <#assign is_line_hotelBewrite_013_all_selected = (line_hotelBewrite_013_value == "001,002,003")?string('Y','N') />
	</#if>
	<#if key == "HB14">
	       <#assign line_hotelBewrite_014 = 'Y' />
	       <#assign line_hotelBewrite_014_value = travelAlertOutsideVO.hotelBewrite["HB14"] />
	       <#assign is_line_hotelBewrite_014_all_selected = (line_hotelBewrite_014_value == "001,002,003,004,005")?string('Y','N') />
	</#if>
	<#--宿雾 港澳 新加坡马来西亚 台湾 酒店团队start-->
	<#if key == "HB15">
	       <#assign line_hotelBewrite_015 = 'Y' />
	       <#assign line_hotelBewrite_015_value = travelAlertOutsideVO.hotelBewrite["HB15"] />
	       <#assign is_line_hotelBewrite_015_all_selected = (line_hotelBewrite_015_value == "001,002,003,004,005,006,007,008,009")?string('Y','N') />
	</#if>
	<#if key == "HB16">
	       <#assign line_hotelBewrite_016 = 'Y' />
	       <#assign line_hotelBewrite_016_value = travelAlertOutsideVO.hotelBewrite["HB16"] />
	       <#assign is_line_hotelBewrite_016_all_selected = (line_hotelBewrite_016_value == "001,002,003,004,005")?string('Y','N') />
	</#if>
	<#if key == "HB17">
	       <#assign line_hotelBewrite_017 = 'Y' />
	       <#assign line_hotelBewrite_017_value = travelAlertOutsideVO.hotelBewrite["HB17"] />
	       <#assign is_line_hotelBewrite_017_all_selected = (line_hotelBewrite_017_value == "001,002,003,004")?string('Y','N') />
	</#if>
	<#if key == "HB18">
	       <#assign line_hotelBewrite_018 = 'Y' />
	       <#assign line_hotelBewrite_018_value = travelAlertOutsideVO.hotelBewrite["HB18"] />
	       <#assign is_line_hotelBewrite_018_all_selected = (line_hotelBewrite_018_value == "001")?string('Y','N') />
	</#if>
	<#--宿雾 港澳 新加坡马来西亚 台湾 酒店团队 end-->
    <#--沙巴 文莱 兰卡威 酒店团队 start-->
    <#if key == "HB19">
        <#assign line_hotelBewrite_019 = 'Y' />
        <#assign line_hotelBewrite_019_value = travelAlertOutsideVO.hotelBewrite["HB19"] />
        <#assign is_line_hotelBewrite_019_all_selected = (line_hotelBewrite_019_value == "001,002,003,004,005,006,007,008")?string('Y','N') />
    </#if>
    <#if key == "HB20">
        <#assign line_hotelBewrite_020 = 'Y' />
        <#assign line_hotelBewrite_020_value = travelAlertOutsideVO.hotelBewrite["HB20"] />
        <#assign is_line_hotelBewrite_020_all_selected = (line_hotelBewrite_020_value == "001,002,003,004,005,006")?string('Y','N') />
    </#if>
    <#--沙巴 文莱 兰卡威 酒店团队 end-->
</#list>
</#if>

<#-- 线路条款map字段分解 -->
<#if travelAlertOutsideVO.clause??>
<#list travelAlertOutsideVO.clause?keys as key>
    <#if key == "LC1">
       <#assign line_clause_001 = 'Y' />
       <#assign line_clause_001_value = travelAlertOutsideVO.clause["LC1"] />
       <#assign is_line_clause_001_all_selected = (line_clause_001_value == "001,002,003,004,005,006")?string('Y','N') />
    </#if>
    <#if key == "LC2">
       <#assign line_clause_002 = 'Y' />
       <#assign line_clause_002_value = travelAlertOutsideVO.clause["LC2"] />
       <#assign is_line_clause_002_all_selected = (line_clause_002_value == "001,002,003,005,006,007")?string('Y','N') />
    </#if>
    <#if key == "LC3">
       <#assign line_clause_003 = 'Y' />
       <#assign line_clause_003_value = travelAlertOutsideVO.clause["LC3"] />
       <#assign is_line_clause_003_all_selected = (line_clause_003_value == "001,002,003,004,005,006")?string('Y','N') />
    </#if>
    <#if key == "LC4">
       <#assign line_clause_004 = 'Y' />
       <#assign line_clause_004_value = travelAlertOutsideVO.clause["LC4"] />
       <#assign is_line_clause_004_all_selected = (line_clause_004_value == "001,002")?string('Y','N') />
    </#if>
    <#if key == "LC5">
       <#assign line_clause_005 = 'Y' />
       <#assign line_clause_005_value = travelAlertOutsideVO.clause["LC5"] />
       <#assign is_line_clause_005_all_selected = (line_clause_005_value == "001,002,003")?string('Y','N') />
    </#if>
    <#if key == "LC6">
       <#assign line_clause_006 = 'Y' />
       <#assign line_clause_006_value = travelAlertOutsideVO.clause["LC6"] />
       <#assign is_line_clause_006_all_selected = (line_clause_006_value == "001,002")?string('Y','N') />
    </#if>
    <#if key == "LC7">
       <#assign line_clause_007 = 'Y' />
       <#assign line_clause_007_value = travelAlertOutsideVO.clause["LC7"] />
       <#assign is_line_clause_007_all_selected = (line_clause_007_value == "001,002")?string('Y','N') />
    </#if>
    <#if key == "LC8">
       <#assign line_clause_008 = 'Y' />
       <#assign line_clause_008_value = travelAlertOutsideVO.clause["LC8"] />
       <#assign is_line_clause_008_all_selected = (line_clause_008_value == "001,002,003,004,005,006")?string('Y','N') />
    </#if>
    <#if key == "LC9">
       <#assign line_clause_009 = 'Y' />
       <#assign line_clause_009_value = travelAlertOutsideVO.clause["LC9"] />
       <#assign is_line_clause_009_all_selected = (line_clause_009_value == "001")?string('Y','N') />
    </#if>
    <#if key == "LC10">
       <#assign line_clause_010 = 'Y' />
       <#assign line_clause_010_value = travelAlertOutsideVO.clause["LC10"] />
       <#assign is_line_clause_010_all_selected = (line_clause_010_value == "001")?string('Y','N') />
    </#if>
    <#if key == "LC11">
       <#assign line_clause_011 = 'Y' />
       <#assign line_clause_011_value = travelAlertOutsideVO.clause["LC11"] />
       <#assign is_line_clause_011_all_selected = (line_clause_011_value == "001,003,004")?string('Y','N') />
    </#if>
    <#if key == "LC12">
        <#assign line_clause_012 = 'Y' />
        <#assign line_clause_012_value = travelAlertOutsideVO.clause["LC12"] />
        <#assign is_line_clause_012_all_selected = (line_clause_012_value == "001")?string('Y','N') />
    </#if>
</#list>
</#if>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>产品条款出境</title>
    <link href="/vst_admin/css/ui-common.css" rel="stylesheet"/>
    <link href="/vst_admin/css/ui-components.css" rel="stylesheet"/>
    <link href="/vst_admin/css/iframe.css" rel="stylesheet"/>
    <link href="/vst_admin/css/dialog.css" rel="stylesheet"/>

    <!--新增样式表-->
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/vst-line-travel.css"/>
</head>
<body>
<div class="iframe_header">
     <ul class="iframe_nav">
         <li><a href="#">${prodProduct.bizCategory.categoryName}</a> &gt;</li>
         <li><a href="#">产品维护</a> &gt;</li>
         <li class="active">修改产品条款</li>
     </ul>
</div>
<div class="iframe_content mt10">
    <div class="p_box box_info">
        <div class="box_content">

             <div class="tiptext tip-warning" <#if travleProductDescription.prodDescId??>style="display:none;"</#if>>
                <span class="tip-icon tip-icon-warning"></span>温馨提示：默认勾选项请点击保存才会生效
            </div>

            <form class="productSuggOutForm" action="#" method="post">
                <!--出行警示 开始-->
                <p class="pdi-title">出行警示及说明：</p>
                <div class="group-input gi-cxjs">
                    <div class="gi-form gi-cxjs-form">
                        <#-- 隐藏域存放DIV -->
                        <div class="travelAlertOutsideHiddenDiv" style="display:none;">
                            <input type="hidden" name="travelAlertOutProdDescId" value="${travleProductDescription.prodDescId}"/>
                            <input type="hidden" name="categoryId" value="${categoryId}"/>
                            <input type="hidden" name="productId" value="${prodProduct.productId}"/>
                            <input type="hidden" name="productType" value="${prodProduct.productType}"/>
                            <input type="hidden" name="packageType" value="${(prodProduct.packageType)!''}"/>
                        </div>
                            <#if travelAlertTemplateList??>
                            <dl class="clearfix">
                                <dt style="width:155px;"><i class="cc1">*</i>选择适用出行警示及说明：</dt>
                                <dd>
                                    <p>
                                        <select name="travelAlertTemplate" data-validate="true"  required>
                                            <option value="">请选择</option>
                                        <#list travelAlertTemplateList as  teamplate>
                                            <option value="${teamplate.code}" <#if teamplate.code==travelAlertOutsideVO.travelAlertTemplate>selected="selected"</#if>>${teamplate.cnName}</option>
                                        </#list>
                                        </select>
                                    </p>
                                </dd>
                            </dl>
                            <dl class="clearfix">
                                <dt>
                                    <i class="cc1">*</i>最晚收材料日 ：
                                </dt>
                                <dd class="gi-last-radio-group">
                                    <p>
                                        <input type="radio" name="latestMater" value="user_sele" checked="checked"  class="gi-last-radio" />
                                        提前
                                        <select name="latestMaterDay" class="gi-w50 JS_checkbox_disabled" data-validate="true" required>
                                        <#list 1..30 as num>
                                            <option value="${num}" <#if travelAlertOutsideVO.latestMaterDay == num>selected="selected"</#if>>${num}</option>
                                        </#list>
                                        </select>
                                        个工作日
                                    </p>
                                </dd>
                            </dl>
                            <dl class="clearfix">
                                <dt>
                                    司导服务费 ：
                                </dt>
                                <dd>
                                    <div class="clearfix JS_checkbox_switch_box">
                                        <label style="width:900px;">
                                            <input style="float:left;" class="JS_checkbox_switch" type="checkbox" name="other" value="012" <#if other_012 == 'Y'>checked="checked"</#if>/>
                                            <em style="float:left;">
                                                根据当地的风土人情，您可以给予为您提供服务的司机导游等人员约<input type="text" name="otherTip" value="${travelAlertOutsideVO.otherTip}" class="gi-w30 js-input JS_checkbox_disabled"
                                                                                     data-validate="true" required digits="true" <#if other_012 != 'Y'>disabled="disabled"</#if>/>/人的小费，以示感谢，谢谢您的理解
                                            </em>
                                        </label>
                                    </div>
                                </dd>
                            </dl>
                            <dl class="clearfix">
                              <dt>其他说明：</dt>
                              <dd>
                              	  <p class="JS_ta_limit_other_area JS_checkbox_switch_box clearfix">
                                    <input type="checkbox" name="other" value="000" class="JS_checkbox_switch JS_ta_limit_judge_ctrl" <#if travelAlertOutsideVO.other?? && travelAlertOutsideVO.other?seq_contains("000")>checked="checked"</#if>/>
                                    <span class="JS_ta_limit_other_group">
                                        <#if travelAlertOutsideVO.otherIn?? && travelAlertOutsideVO.otherIn?size &gt; 0>
                                            <#list travelAlertOutsideVO.otherIn as item>
                                                <span class="JS_ta_limit_other">
                                                    <input type="text" name="otherIn" value="${item}" class="JS_checkbox_disabled input-text gi-w600"
                                                       data-validate="true" maxlength="2000" required/>
                                                   <#break>
                                                </span>
                                            </#list>
                                        <#else>
                                            <span class="JS_ta_limit_other">
                                                <input disabled type="text" name="otherIn"  class="JS_checkbox_disabled input-text gi-w600"
                                                      data-validate="true" maxlength="500" required disabled/>
                                            </span>
                                        </#if>
                 
                                    </span>
                                </p>
                              </dd>
                            </dl>
                            <#else>
			            <dl class="clearfix">
			                <dt>是否加床 ：</dt>
			                <dd class="JS_radio_box">
			                    <p class="JS_radio_switch_box">
			                        <input type="radio" name="addBed" value="001" class="JS_radio_switch" <#if travelAlertOutsideVO.addBed == '001'>checked="checked"</#if>/>
			                        	可以补房差或加床
			                    </p>
			
			                    <p class="JS_radio_switch_box">
			                        <input type="radio" name="addBed" value="002" class="JS_radio_switch" <#if travelAlertOutsideVO.addBed == '002'>checked="checked"</#if>/>
			                        	无三人间且不能加床
			                    </p>
			
			                    <p>
			                    <label class="clearfix">
			                        <input type="checkbox" name="addBedCheck" value="not_specified" <#if not_specified == 'Y'>checked="checked"</#if>/>
			                        <em>
			                            	标间或大床房不可指定
			                        </em>
			                    </label>
			                    </p>
			
			                </dd>
			            </dl>
                        <dl class="clearfix">
                            <dt>
                                最晚收材料日 ：
                            </dt>
                            <dd class="gi-last-radio-group">
                                <p>
                                    <input type="radio" name="latestMater" value="user_sele" <#if travelAlertOutsideVO.latestMater == 'user_sele'>checked="checked"</#if> class="gi-last-radio" />
                                    提前
                                    <select name="latestMaterDay" class="gi-w50 JS_checkbox_disabled" <#if travelAlertOutsideVO.latestMater != 'user_sele'>disabled="disabled"</#if>>
                                        <#list 1..30 as num>
                                            <option value="${num}" <#if travelAlertOutsideVO.latestMaterDay == num>selected="selected"</#if>>${num}</option>
                                        </#list>
                                    </select>
                                    个工作日
                                </p>

                                <p>
                                    <input type="radio" name="latestMater" value="false" <#if travelAlertOutsideVO.latestMater == 'false'>checked="checked"</#if> class="gi-last-radio"/>
                                    <input type="text" data-placeholder="自定义" name="latestMaterIn" value="${travelAlertOutsideVO.latestMaterIn!'自定义'}" 
                                    	class="gi-w250 placeholder" maxlength="100" 
                                    	<#if travelAlertOutsideVO.latestMater != 'false'>disabled="disabled"</#if> data-validate="true" required/>
                                </p>


                            </dd>
                        </dl>

                        <dl class="clearfix JS_checkbox_switch_box">
                            <dt>
                                出签说明 ：
                            </dt>
                            <dd>
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="sign" value="sign" class="JS_checkbox_switch" <#if sign == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        最晚拒签告知时间,出发前
                                        <select name="signDay" class="gi-w50 JS_checkbox_disabled" <#if sign != 'Y'>disabled="disabled"</#if>>
                                            <#list 1..5 as num>
                                                <option value="${num}" <#if travelAlertOutsideVO.signDay == num>selected="selected"</#if>>${num}</option>
                                            </#list>
                                        </select>
                                        个工作日
                                    </em>
                                </label>
                                </div>
                            </dd>
                        </dl>

                        <dl class="clearfix">
                            <dt>
                                销签说明 ：
                            </dt>
                            <dd>
                            
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="pinToSign" value="pin_to_sign" <#if pin_to_sign == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        销签
                                    </em>
                                </label>
                                </div>
                            </dd>
                        </dl>

                        <dl class="clearfix">
                            <dt>
                                蜜月优惠 ：
                            </dt>
                            <dd>
                                <div class="clearfix JS_checkbox_switch_box gi-checkbox-combination">
                                <label class="gi-cc-outer-group">
                                    <input type="checkbox" name="honeymoon" value="honey_noon" class="JS_honey_moon_checkbox JS_checkbox_switch" <#if honey_noon == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        蜜月优惠
                                    </em>
                                </label>
                                 <span class="gi-ml20 JS_honey_moon gi-cc-inner-group hide" style="<#if honey_noon == 'Y'>display: inline;</#if>">
                                    有效期为
                                    <input type="text" name="honeymoonNum" value="${travelAlertOutsideVO.honeymoonNum!''}" class="gi-w50 JS_checkbox_disabled" data-validate="true" required
                                           maxlength="4" <#if honey_noon != 'Y'>disabled="disabled"</#if>>
                                    个月
                                </span>
                                </div>
                            </dd>
                        </dl>

                        <dl class="clearfix">
                            <dt>
                                其他 ：
                            </dt>
                            <dd>
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="other" value="001" <#if other_001 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        酒店不提供一次性用品
                                    </em>
                                </label>
                                </div>

								<div class="clearfix">
                                <label>
                                    <input type="checkbox" name="other" value="002" <#if other_002 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        酒店二次确认
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="other" value="003" <#if other_003 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        拼车
                                    </em>
                                </label>
                                </div>


                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="other" value="004" <#if other_004 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        车况较差
                                    </em>
                                </label>
                                </div>


                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="other" value="005" <#if other_005 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        拼导
                                    </em>
                                </label>
                                </div>


                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="other" value="006" <#if other_006 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        路况较差，路程长
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="other" value="007" <#if other_007 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        道路拥堵
                                    </em>
                                </label>
                                </div>


                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="other" value="008" <#if other_008 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        山上酒店潮湿
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label>
                                     <input type="checkbox" name="other" value="009" <#if other_009 == 'Y'>checked="checked"</#if>/>
                                     <em>
                                        火车票不能提前预售
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="other" value="010" <#if other_010 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        伊斯兰教国家
                                    </em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
				                    <label>
				                        <input type="checkbox" name="other" value="011" <#if other_011 == 'Y'>checked="checked"</#if>/>
				                        <em>
				           持各地签发的中国大陆因私护照免签证                
				                        </em>
				                    </label>
                    			</div>
                                
                                <div class="clearfix JS_checkbox_switch_box">
                                    <label style="width:900px;">
                                        <input style="float:left;" class="JS_checkbox_switch" type="checkbox" name="other" value="012" <#if other_012 == 'Y'>checked="checked"</#if>/>
                                        <em style="float:left;">
                           根据当地的风土人情，您可以给予为您提供服务的司机导游等人员约<input type="text" name="otherTip" value="${travelAlertOutsideVO.otherTip}" class="gi-w30 js-input JS_checkbox_disabled"
                                                                data-validate="true" required digits="true" <#if other_012 != 'Y'>disabled="disabled"</#if>/>/人的小费，以示感谢，谢谢您的理解
                                        </em>
                                    </label>
                                </div>

                                <p class="JS_ta_limit_other_area JS_checkbox_switch_box clearfix">
                                    <input type="checkbox" name="other" value="000" class="JS_checkbox_switch JS_ta_limit_judge_ctrl" <#if travelAlertOutsideVO.other?? && travelAlertOutsideVO.other?seq_contains("000")>checked="checked"</#if>/>


                                    <span class="JS_ta_limit_other_group">
                                        <#if travelAlertOutsideVO.otherIn?? && travelAlertOutsideVO.otherIn?size &gt; 0>
                                            <#list travelAlertOutsideVO.otherIn as item>
                                                <span class="JS_ta_limit_other">
                                                    <input type="text" name="otherIn" value="${item}" class="JS_checkbox_disabled input-text gi-w400 placeholder"
                                                           data-placeholder="其他限制" data-validate="true" required/>
                                                    <#if item_index &gt; 0>
                                                       <a href="javascript:;" class="JS_ta_limit_other_del">删除</a>
                                                    </#if>
                                                </span>
                                            </#list>
                                        <#else>
                                            <span class="JS_ta_limit_other">
                                                <input disabled type="text" name="otherIn" value="其他限制" class="JS_checkbox_disabled input-text gi-w400 placeholder"
                                                       data-placeholder="其他限制" data-validate="true" required
                                                       value="其他限制"/>
                                            </span>
                                        </#if>
                                        <span class="JS_ta_limit_other_add_box">
                                            <a href="javascript:;" class="JS_ta_limit_other_add">增加一条</a>
                                        </span>

                                    </span>

                                </p>
                            </dd>
                        </dl>

                        <dl class="clearfix">
                            <dt>
                                线路条款：
                            </dt>
                            <dd>
                            
                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="clause['LC1']" value="<#if line_clause_001_value??>${line_clause_001_value}</#if>" class="JS_checkbox_switch gi-hd-checkbox" <#if line_clause_001 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        海岛游条款
                                        <span class="gi-hd-status">
                                            <span class="gi-color-green" style="<#if is_line_clause_001_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_clause_001_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <#-- data-class值存放了对应模态窗口的主DIV的class值 -->
                                        <a href="javascript:" class="gi-hd-show-modal-btn JS_checkbox_hidden <#if line_clause_001 != 'Y'>hide</#if>" data-class="gi-modal-hd">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>


                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="clause['LC2']" value="<#if line_clause_002_value??>${line_clause_002_value}</#if>" class="JS_checkbox_switch gi-oz-checkbox" <#if line_clause_002 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        欧洲游条款
                                        <span class="gi-oz-status">
                                            <span class="gi-color-green" style="<#if is_line_clause_002_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_clause_002_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-oz-show-modal-btn JS_checkbox_hidden <#if line_clause_002 != 'Y'>hide</#if>" data-class="gi-modal-oz">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="clause['LC3']" value="<#if line_clause_003_value??>${line_clause_003_value}</#if>" class="JS_checkbox_switch gi-rb-checkbox" <#if line_clause_003 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        日本跟团游条款
                                        <span class="gi-rb-status">
                                            <span class="gi-color-green" style="<#if is_line_clause_003_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_clause_003_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-rb-show-modal-btn JS_checkbox_hidden <#if line_clause_003 != 'Y'>hide</#if>" data-class="gi-modal-rb">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>


                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="clause['LC4']" value="<#if line_clause_004_value??>${line_clause_004_value}</#if>" class="JS_checkbox_switch gi-tg-checkbox" <#if line_clause_004 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        泰国游条款
                                        <span class="gi-tg-status">
                                           <span class="gi-color-green" style="<#if is_line_clause_004_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_clause_004_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-tg-show-modal-btn JS_checkbox_hidden <#if line_clause_004 != 'Y'>hide</#if>" data-class="gi-modal-tg">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="clause['LC5']" value="<#if line_clause_005_value??>${line_clause_005_value}</#if>" class="JS_checkbox_switch gi-mg-checkbox" <#if line_clause_005 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        美国塞班游条款
                                        <span class="gi-mg-status">
                                            <span class="gi-color-green" style="<#if is_line_clause_005_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_clause_005_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-mg-show-modal-btn JS_checkbox_hidden <#if line_clause_005 != 'Y'>hide</#if>" data-class="gi-modal-mg">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>


                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="clause['LC6']" value="<#if line_clause_006_value??>${line_clause_006_value}</#if>" class="JS_checkbox_switch gi-zdf-checkbox" <#if line_clause_006 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        中东非游条款
                                        <span class="gi-zdf-status">
                                           <span class="gi-color-green" style="<#if is_line_clause_006_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_clause_006_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-zdf-show-modal-btn JS_checkbox_hidden <#if line_clause_006 != 'Y'>hide</#if>" data-class="gi-modal-zdf">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="clause['LC7']" value="<#if line_clause_007_value??>${line_clause_007_value}</#if>" class="JS_checkbox_switch gi-db-checkbox" <#if line_clause_007 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        迪拜游条款
                                        <span class="gi-db-status">
                                           <span class="gi-color-green" style="<#if is_line_clause_007_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_clause_007_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-db-show-modal-btn JS_checkbox_hidden <#if line_clause_007 != 'Y'>hide</#if>" data-class="gi-modal-db">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="clause['LC8']" value="<#if line_clause_008_value??>${line_clause_008_value}</#if>" class="JS_checkbox_switch gi-ny-checkbox" <#if line_clause_008 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        南亚游条款
                                        <span class="gi-ny-status">
                                           <span class="gi-color-green" style="<#if is_line_clause_008_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_clause_008_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-ny-show-modal-btn JS_checkbox_hidden <#if line_clause_008 != 'Y'>hide</#if>" data-class="gi-modal-ny">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="clause['LC9']" value="<#if line_clause_009_value??>${line_clause_009_value}</#if>" class="JS_checkbox_switch gi-gd-checkbox" <#if line_clause_009 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        关岛游条款
                                        <span class="gi-gd-status">
                                            <span class="gi-color-green" style="<#if is_line_clause_009_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_clause_009_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-gd-show-modal-btn JS_checkbox_hidden <#if line_clause_009 != 'Y'>hide</#if>" data-class="gi-modal-gd">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="clause['LC10']" value="<#if line_clause_010_value??>${line_clause_010_value}</#if>" class="JS_checkbox_switch gi-medf-checkbox" <#if line_clause_010 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        马尔代夫游条款
                                        <span class="gi-medf-status">
                                            <span class="gi-color-green" style="<#if is_line_clause_010_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_clause_010_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-medf-show-modal-btn JS_checkbox_hidden <#if line_clause_010 != 'Y'>hide</#if>" data-class="gi-modal-medf">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>
                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="hidden" name="is_line_clause_011_all_selected"/>
                                    <input type="checkbox" name="clause['LC11']" value="<#if line_clause_011_value??>${line_clause_011_value}</#if>" class="JS_checkbox_switch gi-ax-checkbox" <#if line_clause_011 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        澳新条款
                                        <span class="gi-ax-status">
                                            <span class="gi-color-green" style="<#if is_line_clause_011_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_clause_011_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-ax-show-modal-btn JS_checkbox_hidden <#if line_clause_011 != 'Y'>hide</#if>" data-class="gi-modal-ax">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>
                                <div class="clearfix">
                                    <label class="JS_checkbox_switch_box">
                                        <input type="hidden" name="is_line_clause_012_all_selected"/>
                                        <input type="checkbox" name="clause['LC12']" value="<#if line_clause_012_value??>${line_clause_012_value}</#if>" class="JS_checkbox_switch gi-mz-checkbox" <#if line_clause_012 == 'Y'>checked="checked"</#if>/>
                                        <em>
                                            美洲条款
                                            <span class="gi-mz-status">
                                            <span class="gi-color-green" style="<#if is_line_clause_012_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_clause_012_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                            <a href="javascript:" class="gi-mz-show-modal-btn JS_checkbox_hidden <#if line_clause_012 != 'Y'>hide</#if>" data-class="gi-modal-mz">查看编辑条款</a>
                                        </em>
                                    </label>
                                </div>
                            </dd>
                        </dl>

	<!--团队酒店描述  begin-->
				<dl class="clearfix">
                            <dt>
                                团队酒店描述：
                            </dt>
                            <dd>
                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="hotelBewrite['HB1']" value="<#if line_hotelBewrite_001_value??>${line_hotelBewrite_001_value}</#if>" class="JS_checkbox_switch gi-hgms-checkbox" <#if line_hotelBewrite_001 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        韩国团队酒店描述
                                        <span class="gi-hgms-status">
                                            <span class="gi-color-green" style="<#if is_line_hotelBewrite_001_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_001_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <#-- data-class值存放了对应模态窗口的主DIV的class值 -->
                                        <a href="javascript:" class="gi-hgms-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_001 != 'Y'>hide</#if>" data-class="gi-modal-hgms">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>
						<div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="hotelBewrite['HB2']" value="<#if line_hotelBewrite_002_value??>${line_hotelBewrite_002_value}</#if>" class="JS_checkbox_switch gi-rbms-checkbox" <#if line_hotelBewrite_002 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        日本团队酒店描述
                                        <span class="gi-rbms-status">
                                            <span class="gi-color-green" style="<#if is_line_hotelBewrite_002_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_002_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-rbms-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_002 != 'Y'>hide</#if>" data-class="gi-modal-rbms">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="hotelBewrite['HB3']" value="<#if line_hotelBewrite_003_value??>${line_hotelBewrite_003_value}</#if>" class="JS_checkbox_switch gi-tgms-checkbox" <#if line_hotelBewrite_003 == 'Y'>checked="checked"</#if>/>
                                    <em>
					泰国团队酒店描述
                                        <span class="gi-tgms-status">
                                            <span class="gi-color-green" style="<#if is_line_hotelBewrite_003_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_003_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-tgms-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_003 != 'Y'>hide</#if>" data-class="gi-modal-tgms">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>


                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="hotelBewrite['HB4']" value="<#if line_hotelBewrite_004_value??>${line_hotelBewrite_004_value}</#if>" class="JS_checkbox_switch gi-bldms-checkbox" <#if line_hotelBewrite_004 == 'Y'>checked="checked"</#if>/>
                                    <em>
					巴厘岛团队酒店描述
                                        <span class="gi-bldms-status">
                                           <span class="gi-color-green" style="<#if is_line_hotelBewrite_004_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_004_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-bldms-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_004 != 'Y'>hide</#if>" data-class="gi-modal-bldms">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="hotelBewrite['HB5']" value="<#if line_hotelBewrite_005_value??>${line_hotelBewrite_005_value}</#if>" class="JS_checkbox_switch gi-pjdms-checkbox" <#if line_hotelBewrite_005 == 'Y'>checked="checked"</#if>/>
                                    <em>
					普吉岛团队酒店描述
                                        <span class="gi-pjdms-status">
                                            <span class="gi-color-green" style="<#if is_line_hotelBewrite_005_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_005_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-pjdms-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_005 != 'Y'>hide</#if>" data-class="gi-modal-pjdms">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>


                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="hotelBewrite['HB6']" value="<#if line_hotelBewrite_006_value??>${line_hotelBewrite_006_value}</#if>" class="JS_checkbox_switch gi-ctms-checkbox" <#if line_hotelBewrite_006 == 'Y'>checked="checked"</#if>/>
                                    <em>
					长滩团队酒店描述
                                        <span class="gi-ctms-status">
                                           <span class="gi-color-green" style="<#if is_line_hotelBewrite_006_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_006_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-ctms-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_006 != 'Y'>hide</#if>" data-class="gi-modal-ctms">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="hotelBewrite['HB7']" value="<#if line_hotelBewrite_007_value??>${line_hotelBewrite_007_value}</#if>" class="JS_checkbox_switch gi-gdms-checkbox" <#if line_hotelBewrite_007 == 'Y'>checked="checked"</#if>/>
                                    <em>
					关岛团队酒店描述
                                        <span class="gi-gdms-status">
                                           <span class="gi-color-green" style="<#if is_line_hotelBewrite_007_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_007_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-gdms-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_007 != 'Y'>hide</#if>" data-class="gi-modal-gdms">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="hotelBewrite['HB8']" value="<#if line_hotelBewrite_008_value??>${line_hotelBewrite_008_value}</#if>" class="JS_checkbox_switch gi-sbms-checkbox" <#if line_hotelBewrite_008 == 'Y'>checked="checked"</#if>/>
                                    <em>
					塞班团队酒店描述
                                        <span class="gi-sbms-status">
                                           <span class="gi-color-green" style="<#if is_line_hotelBewrite_008_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_008_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-sbms-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_008 != 'Y'>hide</#if>" data-class="gi-modal-sbms">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="hotelBewrite['HB9']" value="<#if line_hotelBewrite_009_value??>${line_hotelBewrite_009_value}</#if>" class="JS_checkbox_switch gi-mndms-checkbox" <#if line_hotelBewrite_009 == 'Y'>checked="checked"</#if>/>
                                    <em>
					美娜多团队酒店描述
                                        <span class="gi-mndms-status">
                                            <span class="gi-color-green" style="<#if is_line_hotelBewrite_009_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_009_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-mndms-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_009 != 'Y'>hide</#if>" data-class="gi-modal-mndms">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="hotelBewrite['HB10']" value="<#if line_hotelBewrite_010_value??>${line_hotelBewrite_010_value}</#if>" class="JS_checkbox_switch gi-nyms-checkbox" <#if line_hotelBewrite_010 == 'Y'>checked="checked"</#if>/>
                                    <em>
					南亚团队酒店描述
                                        <span class="gi-nyms-status">
                                            <span class="gi-color-green" style="<#if is_line_hotelBewrite_010_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_010_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-nyms-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_010 != 'Y'>hide</#if>" data-class="gi-modal-nyms">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>
                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="hidden" name="is_line_hotelBewrite_011_all_selected"/>
                                    <input type="checkbox" name="hotelBewrite['HB11']" value="<#if line_hotelBewrite_011_value??>${line_hotelBewrite_011_value}</#if>" class="JS_checkbox_switch gi-ozms-checkbox" <#if line_hotelBewrite_011 == 'Y'>checked="checked"</#if>/>
                                    <em>
					欧洲团队酒店描述
                                        <span class="gi-ozms-status">
                                            <span class="gi-color-green" style="<#if is_line_hotelBewrite_011_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_011_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                        <a href="javascript:" class="gi-ozms-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_011 != 'Y'>hide</#if>" data-class="gi-modal-ozms">查看编辑条款</a>
                                    </em>
                                </label>
                                </div>
                                <div class="clearfix">
                                    <label class="JS_checkbox_switch_box">
                                        <input type="hidden" name="is_line_hotelBewrite_012_all_selected"/>
                                        <input type="checkbox" name="hotelBewrite['HB12']" value="<#if line_hotelBewrite_012_value??>${line_hotelBewrite_012_value}</#if>" class="JS_checkbox_switch gi-oxms-checkbox" <#if line_hotelBewrite_012 == 'Y'>checked="checked"</#if>/>
                                        <em>
					澳新团队酒店描述
                                            <span class="gi-oxms-status">
                                            <span class="gi-color-green" style="<#if is_line_hotelBewrite_012_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_012_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                            <a href="javascript:" class="gi-oxms-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_012 != 'Y'>hide</#if>" data-class="gi-modal-oxms">查看编辑条款</a>
                                        </em>
                                    </label>
                                </div>
                                <div class="clearfix">
                                    <label class="JS_checkbox_switch_box">
                                        <input type="hidden" name="is_line_hotelBewrite_013_all_selected"/>
                                        <input type="checkbox" name="hotelBewrite['HB13']" value="<#if line_hotelBewrite_013_value??>${line_hotelBewrite_013_value}</#if>" class="JS_checkbox_switch gi-mgms-checkbox" <#if line_hotelBewrite_013 == 'Y'>checked="checked"</#if>/>
                                        <em>
					美洲团队酒店描述
                                            <span class="gi-mgms-status">
                                            <span class="gi-color-green" style="<#if is_line_hotelBewrite_013_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_013_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                            <a href="javascript:" class="gi-mgms-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_013 != 'Y'>hide</#if>" data-class="gi-modal-mgms">查看编辑条款</a>
                                        </em>
                                    </label>
                                </div>
                                <div class="clearfix">
                                    <label class="JS_checkbox_switch_box">
                                        <input type="hidden" name="is_line_hotelBewrite_014_all_selected"/>
                                        <input type="checkbox" name="hotelBewrite['HB14']" value="<#if line_hotelBewrite_014_value??>${line_hotelBewrite_014_value}</#if>" class="JS_checkbox_switch gi-zdfms-checkbox" <#if line_hotelBewrite_014 == 'Y'>checked="checked"</#if>/>
                                        <em>
					中东非团队酒店描述
                                            <span class="gi-zdfms-status">
                                            <span class="gi-color-green" style="<#if is_line_hotelBewrite_014_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_014_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                            <a href="javascript:" class="gi-zdfms-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_014 != 'Y'>hide</#if>" data-class="gi-modal-zdfms">查看编辑条款</a>
                                        </em>
                                    </label>
                                </div>
                                <div class="clearfix">
                                    <label class="JS_checkbox_switch_box">
                                        <input type="hidden" name="is_line_hotelBewrite_015_all_selected"/>
                                        <input type="checkbox" name="hotelBewrite['HB15']" value="<#if line_hotelBewrite_015_value??>${line_hotelBewrite_015_value}</#if>" class="JS_checkbox_switch gi-cebums-checkbox" <#if line_hotelBewrite_015 == 'Y'>checked="checked"</#if>/>
                                        <em>
					宿雾团队酒店描述
                                            <span class="gi-cebums-status">
                                            <span class="gi-color-green" style="<#if is_line_hotelBewrite_015_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_015_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                            <a href="javascript:" class="gi-cebums-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_015 != 'Y'>hide</#if>" data-class="gi-modal-cebums">查看编辑条款</a>
                                        </em>
                                    </label>
                                </div>
                               <div class="clearfix">
                                    <label class="JS_checkbox_switch_box">
                                        <input type="hidden" name="is_line_hotelBewrite_016_all_selected"/>
                                        <input type="checkbox" name="hotelBewrite['HB16']" value="<#if line_hotelBewrite_016_value??>${line_hotelBewrite_016_value}</#if>" class="JS_checkbox_switch gi-hkmams-checkbox" <#if line_hotelBewrite_016 == 'Y'>checked="checked"</#if>/>
                                        <em>
					港澳团队酒店描述
                                            <span class="gi-hkmams-status">
                                            <span class="gi-color-green" style="<#if is_line_hotelBewrite_016_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_016_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                            <a href="javascript:" class="gi-hkmams-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_016 != 'Y'>hide</#if>" data-class="gi-modal-hkmams">查看编辑条款</a>
                                        </em>
                                    </label>
                             </div>
                            <div class="clearfix">
                                    <label class="JS_checkbox_switch_box">
                                        <input type="hidden" name="is_line_hotelBewrite_017_all_selected"/>
                                        <input type="checkbox" name="hotelBewrite['HB17']" value="<#if line_hotelBewrite_017_value??>${line_hotelBewrite_017_value}</#if>" class="JS_checkbox_switch gi-singmams-checkbox" <#if line_hotelBewrite_017 == 'Y'>checked="checked"</#if>/>
                                        <em>
					新加坡马来西亚团队酒店描述
                                            <span class="gi-singmams-status">
                                            <span class="gi-color-green" style="<#if is_line_hotelBewrite_017_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_017_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                            <a href="javascript:" class="gi-singmams-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_017 != 'Y'>hide</#if>" data-class="gi-modal-singmams">查看编辑条款</a>
                                        </em>
                                    </label>
                             </div>
                             <div class="clearfix">
                                    <label class="JS_checkbox_switch_box">
                                        <input type="hidden" name="is_line_hotelBewrite_018_all_selected"/>
                                        <input type="checkbox" name="hotelBewrite['HB18']" value="<#if line_hotelBewrite_018_value??>${line_hotelBewrite_018_value}</#if>" class="JS_checkbox_switch gi-taiwanms-checkbox" <#if line_hotelBewrite_018 == 'Y'>checked="checked"</#if>/>
                                        <em>
					台湾团队酒店描述
                                            <span class="gi-taiwanms-status">
                                            <span class="gi-color-green" style="<#if is_line_hotelBewrite_018_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_018_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                            <a href="javascript:" class="gi-taiwanms-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_018 != 'Y'>hide</#if>" data-class="gi-modal-taiwanms">查看编辑条款</a>
                                        </em>
                                    </label>
                              </div>

                                <div class="clearfix">
                                    <label class="JS_checkbox_switch_box">
                                        <input type="hidden" name="is_line_hotelBewrite_019_all_selected"/>
                                        <input type="checkbox" name="hotelBewrite['HB19']" value="<#if line_hotelBewrite_019_value??>${line_hotelBewrite_019_value}</#if>" class="JS_checkbox_switch gi-sabahbrunei-checkbox" <#if line_hotelBewrite_019 == 'Y'>checked="checked"</#if>/>
                                        <em>
                                            沙巴文莱团队酒店描述
                                            <span class="gi-sabahbrunei-status">
                                            <span class="gi-color-green" style="<#if is_line_hotelBewrite_019_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_019_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                            <a href="javascript:" class="gi-sabahbrunei-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_019 != 'Y'>hide</#if>" data-class="gi-modal-sabahbrunei">查看编辑条款</a>
                                        </em>
                                    </label>
                                </div>
                                <div class="clearfix">
                                    <label class="JS_checkbox_switch_box">
                                        <input type="hidden" name="is_line_hotelBewrite_020_all_selected"/>
                                        <input type="checkbox" name="hotelBewrite['HB20']" value="<#if line_hotelBewrite_020_value??>${line_hotelBewrite_020_value}</#if>" class="JS_checkbox_switch gi-langkawi-checkbox" <#if line_hotelBewrite_020 == 'Y'>checked="checked"</#if>/>
                                        <em>
                                            兰卡威团队酒店描述
                                            <span class="gi-langkawi-status">
                                            <span class="gi-color-green" style="<#if is_line_hotelBewrite_020_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">(已全选)</span>
                                            <span class="gi-color-red hide" style="<#if is_line_hotelBewrite_020_all_selected == 'N'>display: inline;<#else>display: none;</#if>">(未全选)</span>
                                        </span>
                                            <a href="javascript:" class="gi-langkawi-show-modal-btn JS_checkbox_hidden <#if line_hotelBewrite_020 != 'Y'>hide</#if>" data-class="gi-modal-langkawi">查看编辑条款</a>
                                        </em>
                                    </label>
                                </div>
                            </dd>
                        </dl>
		<!--团队酒店描述  end-->

                        <dl class="clearfix">
                             <dt>
                                特殊接待限制 ：
                            </dt>
                            <dd class="js-checkbox-group gi-tsjdxz">
                            
                            	<div class="clearfix">
			                        <label>
			                            本产品只接受持各地签发的
			                            <select name = "receptionSign">
			                                <option value="001" <#if travelAlertOutsideVO.receptionSign == "001">selected="selected"</#if>>中国大陆因私护照</option>
			                                <option value="002" <#if travelAlertOutsideVO.receptionSign == "002">selected="selected"</#if>>内地居民往来港澳通行证</option>
			                                <option value="003" <#if travelAlertOutsideVO.receptionSign == "003">selected="selected"</#if>>大陆居民往来台湾通行证</option>
			                            </select>
			                            客人预定
			                        </label>
			                    </div>

                                <div class="gi-checkbox-combination">
                                    <p class="gi-cc-outer-group">
                                        <label class="clearfix">
			                                	<input type="checkbox" name="reception" value="001" class="JS_checkbox_switch" <#if special_reception_limit_001 == 'Y'>checked="checked"</#if>/>
			                                <em>
                                                未满
                                                <input type="text" name="receptionA1" value="${travelAlertOutsideVO.receptionA1!'18'}" class="gi-w30 js-input" value="18" maxlength="4"
                                                       data-validate="true" required digits="true" <#if special_reception_limit_001 != 'Y'>disabled="disabled"</#if>/>
                                                周岁游客，需由
                                                <input type="text" name="receptionA2" value="${travelAlertOutsideVO.receptionA2!''}" class="gi-w30 js-input" maxlength="4"
                                                       data-validate="true" required digits="true" <#if special_reception_limit_001 != 'Y'>disabled="disabled"</#if>/>
                                                周岁至
                                                <input type="text" name="receptionA3" value="${travelAlertOutsideVO.receptionA3!''}" class="gi-w30 js-input" maxlength="4"
                                                       data-validate="true" required digits="true" <#if special_reception_limit_001 != 'Y'>disabled="disabled"</#if>/>
                                                周岁家属陪同
                                            </em>
                                        </label>
                                    </p>

                                    <p class="gi-cc-inner-group" style="<#if special_reception_limit_001 == 'Y'>display: block;</#if>">
                                        <label class="clearfix">
			                                <input type="checkbox" name="receptionCall" value="001" <#if travelAlertOutsideVO.receptionCall?? && travelAlertOutsideVO.receptionCall?seq_contains("001")>checked="checked"</#if>/>可来电咨询接待方式及费用
			                            </label>
                                    </p>
                                </div>

                                <div class="gi-checkbox-combination">
                                    <p class="gi-cc-outer-group">
                                        <label class="clearfix">
			                                	<input type="checkbox" name="reception" value="002" class="JS_checkbox_switch" <#if special_reception_limit_002 == 'Y'>checked="checked"</#if>/>
			                                <em>
                                                无法接待
                                                <input type="text" name="receptionA4" value="${travelAlertOutsideVO.receptionA4!'18'}" class="gi-w30 js-input" value="18" maxlength="4"
                                                       data-validate="true" required digits="true" <#if special_reception_limit_002 != 'Y'>disabled="disabled"</#if>/>
                                                周岁以下的儿童
                                            </em>
                                        </label>
                                    </p>

                                    <p class="gi-cc-inner-group" style="<#if special_reception_limit_002 == 'Y'>display: block;</#if>">
                                        <label class="clearfix">
			                                <input type="checkbox" name="receptionCall" value="002" <#if travelAlertOutsideVO.receptionCall?? && travelAlertOutsideVO.receptionCall?seq_contains("002")>checked="checked"</#if>/>可来电咨询接待方式及费用
			                            </label>
                                    </p>
                                </div>

                                <div class="gi-checkbox-combination">
                                    <p class="gi-cc-outer-group">
                                        <label class="clearfix">
			                                	<input type="checkbox" name="reception" value="003" class="JS_checkbox_switch" <#if special_reception_limit_003 == 'Y'>checked="checked"</#if>/>
			                                <em>
                                                超过
                                                <input type="text" name="receptionA5" value="${travelAlertOutsideVO.receptionA5!'70'}" class="gi-w30 js-input" value="70" maxlength="4"
                                                       data-validate="true" required digits="true" <#if special_reception_limit_003 != 'Y'>disabled="disabled"</#if>/>
                                                周岁游客，需提供
                                                <input type="text" class="gi-w75 js-input" name="receptionHospital" value="${travelAlertOutsideVO.receptionHospital!'二级甲等'}" <#if special_reception_limit_003 != 'Y'>disabled="disabled"</#if>/>
                                                医院证明
                                            </em>
                                        </label>
                                    </p>

                                    <p class="gi-cc-inner-group" style="<#if special_reception_limit_003 == 'Y'>display: block;</#if>">
                                        <label class="clearfix">
			                                <input type="checkbox" name="receptionCall" value="003" <#if travelAlertOutsideVO.receptionCall?? && travelAlertOutsideVO.receptionCall?seq_contains("003")>checked="checked"</#if>/>可来电咨询接待方式及费用
			                            </label>
                                    </p>
                                </div>

                                <div class="gi-checkbox-combination">
                                    <p class="gi-cc-outer-group">
                                        <label class="clearfix">
			                                	<input type="checkbox" name="reception" value="004" class="JS_checkbox_switch" <#if special_reception_limit_004 == 'Y'>checked="checked"</#if>/>
			                                <em>
                                                无法接待
                                                <input type="text" name="receptionA6" value="${travelAlertOutsideVO.receptionA6!'75'}" class="gi-w30 js-input" value="75" maxlength="4"
                                                       data-validate="true" required digits="true" <#if special_reception_limit_004 != 'Y'>disabled="disabled"</#if>/>
                                                以上的成人
                                            </em>
                                        </label>
                                    </p>

                                    <p class="gi-cc-inner-group" style="<#if special_reception_limit_004 == 'Y'>display: block;</#if>">
                                        <label class="clearfix">
			                                <input type="checkbox" name="receptionCall" value="004" <#if travelAlertOutsideVO.receptionCall?? && travelAlertOutsideVO.receptionCall?seq_contains("004")>checked="checked"</#if>/>可来电咨询接待方式及费用
			                            </label>
                                    </p>
                                </div>

                                <div class="gi-checkbox-combination">
                                    <p class="gi-cc-outer-group clearfix">
                                        
                                        <label>
                                            <input type="checkbox" name="reception" value="005" class="JS_checkbox_switch" <#if special_reception_limit_005 == 'Y'>checked="checked"</#if>/>
                                            <em>
                                                因服务能力所限或游览接待的特殊情况所限， 只接待
                                                <input type="text" class="gi-w30 js-input" name="receptionA7" value="${travelAlertOutsideVO.receptionA7!''}" maxlength="4"
                                                       data-validate="true" required digits="true" <#if special_reception_limit_005 != 'Y'>disabled="disabled"</#if>/>
                                                周岁以上至
                                                <input type="text" class="gi-w30 js-input" name="receptionA8" value="${travelAlertOutsideVO.receptionA8!''}" maxlength="4"
                                                       data-validate="true" required digits="true" <#if special_reception_limit_005 != 'Y'>disabled="disabled"</#if>/>
                                                周岁以下的旅游者报名出游，敬请谅解
                                            </em>
                                        </label>
                                        
                                    </p>

                                    <p class="gi-cc-inner-group clearfix" style="<#if special_reception_limit_005 == 'Y'>display: block;</#if>">
                                        
                                        <label>
                                            <input type="checkbox" name="receptionCall" value="005" <#if travelAlertOutsideVO.receptionCall?? && travelAlertOutsideVO.receptionCall?seq_contains("005")>checked="checked"</#if>/>可来电咨询接待方式及费用
                                        </label>
                                        
                                    </p>
                                </div>

                                <div class="gi-checkbox-combination">
                                    <p class="gi-cc-outer-group clearfix">
                                        
                                        <label>
                                            <input type="checkbox" name="reception" value="006" class="JS_checkbox_switch" <#if special_reception_limit_006 == 'Y'>checked="checked"</#if>/>
                                            <em>
                                                不接受孕妇
                                            </em>
                                        </label>
                                        
                                    </p>

                                    <p class="gi-cc-inner-group" style="<#if special_reception_limit_006 == 'Y'>display: block;</#if>">
                                        
                                        <label>
                                            <input type="checkbox" name="receptionCall" value="006" <#if travelAlertOutsideVO.receptionCall?? && travelAlertOutsideVO.receptionCall?seq_contains("006")>checked="checked"</#if>/>可来电咨询接待方式及费用
                                        </label>
                                        
                                    </p>
                                </div>

                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="reception" value="007" class="JS_checkbox_switch" <#if special_reception_limit_007 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        外籍加收
                                        <input type="text" class="gi-w50 js-input" name="receptionPrice" value="${travelAlertOutsideVO.receptionPrice!''}" data-validate="true" required
                                               digits="true" maxlength="10" <#if special_reception_limit_007 != 'Y'>disabled="disabled"</#if>/>元/人
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label>
                                    <input class="JS_checkbox_switch" type="checkbox" name="reception" value="008" <#if special_reception_limit_008 == 'Y'>checked="checked"</#if>/>
                                    <em>
                                        不接受一人出游
                                    </em>
                                </label>
                                </div>

                                <p class="JS_ta_reception_other_area JS_checkbox_switch_box clearfix">
                                    <input type="checkbox" name="reception" value="000" class="JS_checkbox_switch JS_ta_reception_judge_ctrl" <#if special_reception_limit_000 == 'Y'>checked="checked"</#if>/>


                                    <span class="JS_ta_reception_other_group">
                                        <#if travelAlertOutsideVO.receptionOther?? && travelAlertOutsideVO.receptionOther?size &gt; 0>
                                            <#list travelAlertOutsideVO.receptionOther as item>
                                                <span class="JS_ta_reception_other">
                                                    <input type="text" class="JS_checkbox_disabled input-text gi-w400 placeholder"
                                                           data-placeholder="其他限制" data-validate="true" required
                                                           name="receptionOther" value="${item}"/>
                                                    <#if item_index &gt; 0>
                                                           <a href="javascript:;" class="JS_ta_reception_other_del">删除</a>
                                                       </#if>
                                                </span>
                                            </#list>
                                        <#else>
                                            <span class="JS_ta_reception_other">
                                                    <input disabled type="text" class="JS_checkbox_disabled input-text gi-w400 placeholder"
                                                           data-placeholder="其他限制" data-validate="true" required
                                                           name="receptionOther" value="其他限制"/>
                                            </span>
                                        </#if>
                                        <span class="JS_ta_reception_other_add_box">
                                            <a href="javascript:;" class="JS_ta_reception_other_add">增加一条</a>
                                        </span>

                                    </span>

                                </p>

                            </dd>
                        </dl>
                       </#if>
                    </div>
                </div>
                <!--出行警示 结束-->

                <!--退改说明 开始-->
                <p class="pdi-title"><#if travelAlertTemplateList??><i class="cc1">*</i></#if>退改说明：</p>

                <div class="gi-form lt-tgsm">
                    <#-- 隐藏域存放DIV -->
                    <div class="refundExplainOutsideHiddenDiv" style="display:none;">
                        <input type="hidden" name="refundExplainOutProdDescId" value="${refundProductDescription.prodDescId}"/>
                    </div>
                    <div class="clearfix">
                        <p class="lte_title" style="width: 85px;float: none;">退改说明：</p>

                        <p class="lte_title">跟团条款：</p>
                        <div class="lte_content">
                            <div class="lte_check_list" name="groupList">
                                <div class="lte_check clearfix">
                                    <label class="lte_check_label">
                                        <input type="checkbox" name="refundExplain" value="001" class="lte_checkbox" <#if refundExplainOutsideVO.refundExplain?? && refundExplainOutsideVO.refundExplain?seq_contains("001")>checked="checked"</#if>><em>旅游者在出发前30日内提出解除合同的，应当按下列标准向组团社支付业务损失费：</em>
                                    </label>
                                </div>
                                <div class="lte_check clearfix">
                                    <label class="lte_check_label">
                                        <input type="checkbox" name="refundExplain" value="002" class="lte_checkbox" <#if refundExplainOutsideVO.refundExplain?? && refundExplainOutsideVO.refundExplain?seq_contains("002")>checked="checked"</#if>><em>行程开始前29日至15日，按旅游费用总额的5%；</em>
                                    </label>
                                </div>
                                <div class="lte_check clearfix">
                                    <label class="lte_check_label">
                                        <input type="checkbox" name="refundExplain" value="003" class="lte_checkbox" <#if refundExplainOutsideVO.refundExplain?? && refundExplainOutsideVO.refundExplain?seq_contains("003")>checked="checked"</#if>><em>行程开始前14日至7日，按旅游费用总额的20%；</em>
                                    </label>
                                </div>
                                <div class="lte_check clearfix">
                                    <label class="lte_check_label">
                                        <input type="checkbox" name="refundExplain" value="004" class="lte_checkbox" <#if refundExplainOutsideVO.refundExplain?? && refundExplainOutsideVO.refundExplain?seq_contains("004")>checked="checked"</#if>><em>行程开始前6日至4日，按旅游费用总额的50%；</em>
                                    </label>
                                </div>
                                <div class="lte_check clearfix">
                                    <label class="lte_check_label">
                                        <input type="checkbox" name="refundExplain" value="005" class="lte_checkbox" <#if refundExplainOutsideVO.refundExplain?? && refundExplainOutsideVO.refundExplain?seq_contains("005")>checked="checked"</#if>><em>行程开始前3日至1日，按旅游费用总额的60%；</em>
                                    </label>
                                </div>
                                <div class="lte_check clearfix">
                                    <label class="lte_check_label">
                                        <input type="checkbox" name="refundExplain" value="006" class="lte_checkbox" <#if refundExplainOutsideVO.refundExplain?? && refundExplainOutsideVO.refundExplain?seq_contains("006")>checked="checked"</#if>><em>行程开始当日，按旅游费用总额的70%。</em>
                                    </label>
                                </div>
                                <div class="lte_check clearfix">
                                    <label class="lte_check_label">
                                        <input type="checkbox" name="refundExplain" value="007" class="lte_checkbox" <#if refundExplainOutsideVO.refundExplain?? && refundExplainOutsideVO.refundExplain?seq_contains("007")>checked="checked"</#if>><em>如按上述比例支付的业务损失费不足以赔偿组团社的实际损失，旅游者应当按实际损失对组团社予以赔偿，但最高额不应当超过旅游费用总额</em>
                                    </label>
                                </div>
                                <div class="lte_check clearfix">
                                    <label class="lte_check_label">
                                        <input type="checkbox" name="refundExplain" value="008" class="lte_checkbox" <#if refundExplainOutsideVO.refundExplain?? && refundExplainOutsideVO.refundExplain?seq_contains("008")>checked="checked"</#if>><em>游客转让：出行前，在符合办理团队签证或签注期限或其他条件许可情况下，旅游者可以向组团社书面提出将其自身在本合同中的权利和义务转让给符合出游条件的第三人；并且由第三人与组团社重新签订合同；因此增加的费用由旅游者或第三人承担，减少的费用由组团社退还旅游者。</em>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <p class="lte_title">包机条款：</p>
                        <div class="lte_content">
                            <div class="lte_check_list" name="airPlaneList">
                                <div class="lte_check clearfix">
                                    <label class="lte_check_label">
                                        <input type="checkbox" name="refundExplain" value="101" class="lte_checkbox"
                                               <#if refundExplainOutsideVO.refundExplain?? && refundExplainOutsideVO.refundExplain?seq_contains("101")>checked="checked"</#if>>
                                        <em>此线路为包机产品，旅游者在确认产品后如进行取消、退改应当向组团社支付旅游费用总额100%的业务损失费；</em>
                                    </label>
                                </div>
                                <div class="lte_check clearfix">
                                    <label class="lte_check_label">
                                        <input type="checkbox" name="refundExplain" value="102" class="lte_checkbox"
                                               <#if refundExplainOutsideVO.refundExplain?? && refundExplainOutsideVO.refundExplain?seq_contains("102")>checked="checked"</#if>>
                                        <em>游客转让：出行前，在符合办理团队签证或签注期限或其他条件许可情况下，旅游者可以向组团社书面提出将其自身在本合同中的权利和义务转让给符合出游条件的第三人；并且由第三人与组团社重新签订合同；因此增加的费用由旅游者或第三人承担，减少的费用由组团社退还旅游者；</em>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                    <div class="clearfix">
                        <p class="lte_title">其他 ：</p>

                        <div class="lte_content">
                            <div class="JS_checkbox_switch_box gi-other-box">
                                <div class="gi-other-checkbox">
                                    <input type="checkbox" class="JS_checkbox_switch JS_other_judge_ctrl" name="refundExplain" value="000" <#if refundExplainOutsideVO.refundExplain?? && refundExplainOutsideVO.refundExplain?seq_contains("000")>checked="checked"</#if>/>
                                </div>

                                <div class="gi-others">
                                    <#if refundExplainOutsideVO.refundExplainInput??>
                                        <#list refundExplainOutsideVO.refundExplainInput as item>
                                            <div class="gi-other">
                                                <input type="text" name="refundExplainInput" value="${item}" class="input-text gi-w600 JS_checkbox_disabled"
                                                       data-validate="true"
                                                       required maxlength="500" />
                                                <#if item_index gt 0>
                                                    <a href="javascript:" class="gi-del gi-other-del">删除</a>
                                                </#if>
                                            </div>
                                        </#list>
                                    <#else>
                                        <div class="gi-other">
                                            <input type="text" name="refundExplainInput" class="input-text gi-w600 JS_checkbox_disabled"
                                                   data-validate="true"
                                                   required maxlength="500" disabled/>
                                        </div>
                                     </#if>
                                        <div class="clearfix gi-w600 gi-other-add">
                                            <a href="javascript:" class="fr JS_other_add_btn">增加一条</a>
                                        </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--退改说明 结束-->

                <div class="gi-ctrl clearfix">
                    <div class="fr">
                        <a class="gi-button gi-mr15 JS_button_save" href="javascript:">保存</a>
                        <a href="javascript:void(0);" class="btn btn_cc1 showLogDialog" param='objectId=${prodProduct.productId}&objectType=PROD_PRODUCT_SUGG&sysName=VST'>查看操作日志</a>	
                    </div>
                </div>

            </form>
        </div>
    </div>
</div>

<!-- 模态窗口 开始-->
<!--遮罩 开始-->
<div class="gi-modal-overlay"></div>
<!--遮罩 结束-->

<!--海岛游条款 开始-->
<div class="gi-modal gi-modal-hd">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <#-- data-key值存放了对应ckeckbox的name值 -->
    <div class="gi-modal-content" data-key="clause['LC1']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>地处海岛，气候潮湿，岛上接待能力有限，与市区酒店条件不可相比，宾馆难免会有潮湿等状况，敬请谅解。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em>因此线路属于海岛区域，淡水、电力资源短缺，供给困难，故不能保证24小时供水，入住宾馆时请注意供水时间，并请节约用水、用电。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em>此线路旅游目的地四季如夏，防晒乳液、遮阳用具、太阳眼镜十分重要。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em>大部分海滩及游泳池均无救生人员，海滩活动时请您务必穿着沙滩鞋，以免受伤，游泳时也请您确保人身安全！</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="005"/>
                <em>我们建议您在住酒店期间，将每人每天1美金的小费放在床头，通过酒店预订的餐饮、娱乐、游玩等服务，可能需要收取额外服务费用，敬请您留意。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="006"/>
                <em>此线路旅游目的地就医价格昂贵，医疗条件有限请您注意好室外温差并及时补充水分，以免生病；请自备常用药品；因意外生病或受伤时，请您及时与酒店或境外紧急联系人联络，请酒店方或境外工作人员协助就医，所产生的医疗费用及导游司机的服务费用敬请自理。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--海岛游条款 结束-->

<!--欧洲游条款 开始-->
<div class="gi-modal gi-modal-oz">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="clause['LC2']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>团队行程由领队负责所有的机票及护照，故出发前机票及护照将不配送给客人（如果您是自备签证，请自带护照，如遗忘携带护照，由此产生的相应损失需自行承担）。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em>游客必须按领馆要求在规定的时间内提供准确、完整的送签材料，如果材料系伪造则必须承担相应的责任。游客的材料送进领馆后，如被领馆拒签，必须支付因拒签所产生的相应损失费用，如签证费、翻译费等。因客人被领馆拒签不能成行，旅行社不承担违约责任。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em>当您从欧洲离境时，一定检查海关是否给您的护照盖了清晰的离境章，它是您已经回到中国的唯一凭证。如果没有盖章或者章不清晰无法辨认将会导致使馆要求您面试销签，由此造成不必要的损失，非常抱歉只能由本人承担，请您谅解的同时也请您自己务必仔细留意； </em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="005"/>
                <em>根据欧共体法律规定，导游和司机每天工作时间不得超过10小时。欧洲用车：夏季欧洲旅游团队由于人数较多，且行车时间有时较长，可能导致空调系统无法充分制冷，另外欧盟规定空调只在长途车引擎发动的时候工作，而车辆在停车状态时启动引擎是违法的行为，因此无法在客人上车前10分钟提前制冷，因此可能导致车内温度较高，敬请谅解； </em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="006"/>
                <em>由于各种原因如环保、历史悠久、欧洲气候较温和等，较多酒店无空调设备</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="007"/>
                <em>退税：退税是欧盟对非欧盟游客在欧洲购物的优惠政策，整个退税手续及流程均由欧洲国家控制，经常会出现退税不成功、税单邮递过程中丢失导致无法退
                    税等问题，我们会负责协调处理，但无法承担任何赔偿。导游有责任和义务协助贵宾办理退税手续,导游应详细讲解退税流程、注意事项及税单的正确填写。但是如
                    果因为贵宾个人问题（如没有仔细听讲、没有按照流程操作、没有按照流程邮寄税单）或者客观原因（如遇到海关退税部门临时休息、海关临时更改流程、税单在邮
                    寄过程中发生问题商家没有收到税单等）在退税过程中出现错误，导致您被扣款、无法退钱、退税金额有所出入等情况，旅行社和导游仅能协助您积极处理，并不能承担您的损失，请贵宾们理解。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--欧洲游条款 结束-->

<!--日本游条款 开始-->
<div class="gi-modal gi-modal-rb">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="clause['LC3']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>团队行程由领队负责所有的机票及护照，故出发前机票及护照将不配送给客人（如果您是自备签证，请自带护照，如遗忘携带护照，由此产生的相应损失需自行承担）</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em>日本国土交通省最新规定，每日行车时间不得超过10小时（以自车库实际发车时间为计算基准），若超时，则司机有权拒绝，以有效防止巴士司机因过(疲)劳驾驶所衍生之交通状况。故逢旅游旺季；如巴士无法全程接送时，改采採巴士+电车前往旅游景点，敬请见谅。(2014年7月1日)起日本陆运局更严厉执行旅游车的行车时间及距离的计算。实施条例每天行车不得超过500公里，超出则属违例。夏季团队由于人数较多，且行车时间有时较长，可能导致空调系统无法充分制冷。车辆在停车状态时启动引擎是违法的行为，因此无法在客人上车前10分钟提前制冷，由可能导致车内温度较高，敬请谅解；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em>寒暑假，樱花（约2-5月），红叶（约9-11月）期间是当地旅游旺季，各景点或游乐场等热点游人较多，本社安排的行程、餐食、酒店，导游将按照实际交通及游览情况，略作适当调整，以便顺利完成所有景点，敬请客人配合。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em>樱花、红叶等自然风景观光期间，如行程内所安排的景点因下雨、强风或气温等天候因素影响导致植物未绽开或凋谢，并非人为可以控制，会依照原定行程前往参观，不便之处，敬请理解。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="005"/>
                <em>如遇当地公共假期、节日、气候等状况，上述行程次序及景点可能临时变动、修改或更换，本公司不作预先通知，敬请谅解。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="006"/>
                <em>中国与日本两地间的饮食文化多有不同，日本的多数素食者可食用葱、姜、蒜、辣椒、奶蛋甚至柴鱼或肉汁高汤所熬煮的餐饮，为尊重素食贵宾的饮食习惯，在避免使用上述食材的前提下，各餐厅多以各式蔬菜、豆腐等食材搭配渍物料理的定食或锅物提供给素食贵宾，且当地购买全素食品也相当不易，故建议前往日本旅游的贵宾，如有需要请自行事先准备素食品，以备不时之需。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--日本游条款 结束-->

<!--泰国游条款 开始-->
<div class="gi-modal gi-modal-tg">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="clause['LC4']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>泰国移民局规定：为防止黑劳工入境，持旅游签证之入境旅客需携带等值于25000泰铢（约合人民币5000元）现金方可入境，请提前做好准备。以备入境时移民官抽查,如因游客本人携带现金不够被抽查到，无法入境泰国并且遣返回国，因此产生的费用由游客承担。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em>海关入境注意事项：旅游者可以带入的免税物品包括香烟200支，酒1公斤；各种肉类、植物、蔬菜等禁止入境。根据海关条例，如携带超过5万泰铢或2000美元以上现金入境必须报关。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--泰国游条款 结束-->

<!--美国塞班游条款 开始-->
<div class="gi-modal gi-modal-mg">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="clause['LC5']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>凡有美国绿卡的客人，在出行时，请务必携带。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em>凡曾有办理过美签的客人请提供护照中所有美签的记录的签证页复印件；如有被拒签的记录或者美签出签成功但是在美国期间有不良记录，美国移民局可能会拒绝您入境，因拒签导致的损失需您自行承担，所以请务必谨慎考虑。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em>凡在我国境内公安机关留有不良案底，如携带枪支等，美国移民局可能会拒绝您入境，由造成的损失需您自行承担。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--美国塞班游条款 结束-->

<!--中东非游条款 开始-->
<div class="gi-modal gi-modal-zdf">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="clause['LC6']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>大部分酒店硬件设施无法国内相比，房间相对较小，设施陈旧等，且办理入住需时较长，部分酒店没有电梯或空间较小，每次只能乘坐两个人和行李； </em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em>部分目的地行程中会安排当地特色酒店（如帐篷、洞穴、温泉酒店等），设施一般，旨在给您不同旅游体验，由于各种原因，如环保、气候、地理位置等因素，部分酒店无空调设备； </em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--中东非游条款 结束-->

<!--迪拜游条款 开始-->
<div class="gi-modal gi-modal-db">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="clause['LC7']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>根据迪拜移民局规定，不接受护照上有以色列签证的客人出入境，建议上述客人：A、更换原有护照，使用新护照出行。B、选择使用直接由迪拜出入境的产品。如因以色列签证问题，而造成行程受阻，相应损失需自行承担。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em>以下情况比较容易被拒签，请注意：A、名字为单名（如张明、李丽等）或与迪拜移民局系统黑名单内名字重名；B、1976年后出生的未婚的女性；C、同时委托2家旅行社申请阿联酋签证的人员；D、其他阿联酋移民局认为可能产生问题的人员。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--迪拜游条款 结束-->

<!--南亚游条款 开始-->
<div class="gi-modal gi-modal-ny">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="clause['LC8']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>一般除首都或部分大城市有中餐馆可以安排中餐外，其他地方一般都在酒店内用西式或当地风味自助餐；口味一般较辛辣、香料较多，不一定符合中国人口味。建议您可自备一些适合您个人口味的干粮、零食或其他便于携带的食物。</em>
            </label>
            <label class="clearfix">
               <input type="checkbox" value="002"/>
                <em>因当地医疗条件有效，请您务必自备个人常用药品(特别是肠胃药品)，女士生理用品请自备足够；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em>当地水质较差，切勿直接饮用生水，建议请饮用矿泉水；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em>一般国内移动或联通手机开通国际漫游，在南亚各国均可使用；但在部分偏远山区或郊区可能信号不佳；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="005"/>
                <em>当地部分城市空气质量差、环境污染严重，建议您自备口罩；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="006"/>
                <em>部分山区或丛林地区可能不定时会停水停电，建议自备照明工具；有些酒店采用太阳能取热，不能保证随时有热水提供；</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--南亚游条款 结束-->

<!--关岛游条款 开始-->
<div class="gi-modal gi-modal-gd">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="clause['LC9']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>关岛每成人限酒类3.7公升、烟2条或雪茄50支之内免税。现金、旅行支票超过1万美金时需要申报。麻药、枪械、生肉及肉类加工品严禁携入。蔬果、带有泥土、带叶的蔬菜、华盛顿公约所管制的动物或其部分所制成的产品都要没收。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--关岛游条款 结束-->

<!--马尔代夫游条款 开始-->
<div class="gi-modal gi-modal-medf">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="clause['LC10']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>马尔代夫严禁携带猪肉制品、酒类等违反伊斯兰教教义的物品。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--马尔代夫游条款 结束-->

<!--奥新条款 开始-->
<div class="gi-modal gi-modal-ax">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="clause['LC11']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox"/>
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>海关：请严格按照出团通知书规定的时间、地点集合，迟到超过30分钟以上者视客人自动放弃行程，团费概不退还。
				按照我国外汇管理的有关规定，如无外汇携带许可证，公民出国旅行每人允许携带人民币现钞不超过2万元，外汇折合不超过美元5000元。
				出、入境时，请勿帮其他人携带物品，以免被不良分子利用，各地出入境时，请勿在移民局、海关区域摄影、拍照，以免被扣留器材。
				目的地国家注重知识产权的保护，请勿携带仿制品牌的物品，以及盗版的光盘、书籍，如被海关查及，将会被没收或罚款。 
				澳洲严禁一切肉类、种子、蔬菜、水果入境，如携带任何食物，不论种类必须报关。澳洲并没有限制澳元或外币的进出，但如果携带超过一万澳元或同等值外币的进出，就必须在抵达时申报，否则属于违法。每一名十八岁周岁以上的游客，可免税带2250毫升酒类，50支香烟，如超过的必须申报。
				动植物、未经检疫的新鲜水果以及政治、色情书刊、光盘等在行程结束回国时严禁携带入境。回程入境中国，每人免税烟酒的携带限量是：烟一条（或两条）、酒一瓶。
				在您出入境时，可能会有其他游客同时在办理手续，因此需要排队等候。行程中的用餐、景点游览、办理酒店入住等，也可能会出现此类情况，特别遇到旅游旺季，请团友耐心等待。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em>当地习俗：为保证乘客生命财产安全，法律禁止司机超时工作。巴士司机每天必须保证连续10个小时的休息，每天开车时间不得超过10小时（包括就餐和景点参观时间），因此要求司机额外加班可能被拒绝。若司机同意加班也需支付一定的加班费用。
				澳新属英联邦国家，交通管制同英国一样，为靠左行驶制度。在您乘车和横过马路时注意交通安全，请按信号灯提示行走斑马线。
				根据环保条例，司机在停车侯客时，不允许开空调，否则要罚款，请您理解。
				机场、车站、办公楼等公共场所大都要求禁烟，违反会被处以高额罚款。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em>安全问题：搭乘游船或进行其他水上活动时，请注意安全，不要将手、脚或身体的其他部位靠在船舷上，以免发生危险。行程途中，贵宾在行驶的旅游车上，不可随意站立和中途拿取行李物品，更不能在车子停稳之前在车厢里随意走动。（如发生意外，一切后果由当事人自行负责！）
				请确切了解自己的身体、年龄、健康等状况。孕妇、心脏病患者、高龄人士、低龄、婴幼儿、高血压、骨质疏松等游客，绝对不适合参加任何剧烈、刺激性、高危的活动项目。
				游览野生动物园时，请听从导游的知道，做到“不下车，不吸烟，不喂食，不挑衅”。
				团队活动时严禁擅自离团，如有特殊情况离团，需征得导游和领队的同意，且必须签署个人离团免责书（如发生意外，一切后果由当事人自行负责！）
				在境外，医疗费用通常十分昂贵。请您带上一些常用药品，旅行中最常见的疾病是腹泻或感冒。请随带感冒药、消炎药、止泻药、晕车药等，如有高血压、心脏病、胃病或其他慢性病患者必须带备足够药品（最好能携带英文说明书）及医生处方，以备不时之需。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix" >
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--奥新条款 结束-->
<!--美洲条款 开始-->
<div class="gi-modal gi-modal-provision gi-modal-mz">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="clause['LC12']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> <em>美洲常规散拼团的酒店一般在城外60公里以上，车程从市区到酒店一般要30分钟至80分钟，按惯例一般不安排在市区内；部分酒店大堂比较小，电梯数量少，甚至无电梯；美国酒店不确定房型， 一般为双人床。不加床。早餐为一般为美式简餐。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--美洲条款 结束-->

<!--韩国团队酒店描述 开始-->
<div class="gi-modal gi-modal-hgms">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <#-- data-key值存放了对应ckeckbox的name值 -->
    <div class="gi-modal-content" data-key="hotelBewrite['HB1']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> 韩国当地酒店房间面积普遍偏小，设施略显简陋。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em>原则上安排同性两人一间房，在无单人需拼房的前提下可安排夫妻或一家人同住，特殊情况可能存在夫妻分开的现象。一般情况下均安排双标间，部分酒店双标间会存在大小床差异，如需大床房请提前告知，尽量安排不保证。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em>团队酒店一般均不安排在市区位置，离市区都有一定距离，个别指定区域酒店的线路除外。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em>韩国电压为220伏，酒店插座一般为两眼圆孔插口，需使用转换插座，请在出行前自行准备。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="005"/>
                <em>因国外环保因素，酒店内一般不备有牙刷、牙膏和拖鞋等一次性洗漱用品，请自行携带。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--韩国团队酒店描述 结束-->

<!--日本团队酒店描述 开始-->
<div class="gi-modal gi-modal-rbms">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="hotelBewrite['HB2']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> 日本跟团产品的酒店，除产品中非特别注明外，一般情况不会安排到市中心区域，所安排的酒店位置离市中心大概有40-60分钟车程。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em>第一天和最后一天有可能安排在机场附近酒店。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em>日本酒店的大堂和房间都偏小，床也较小，但是干净整洁。房间内基本上配备毛巾、牙膏、沐浴乳、洗发露等基本需求品。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--日本团队酒店描述 结束-->

<!--泰国团队酒店描述 开始-->
<div class="gi-modal gi-modal-tgms">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="hotelBewrite['HB3']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> 泰国的酒店大堂一般不是很大，团队酒店一般不靠近市区，购物中心。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em> 泰国酒店的自来水不可直接饮用，建议客人购买瓶装水饮用。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em> 由于热带国家，房间里建议客人不要随便乱放甜食，以免招惹虫蚁。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em> 泰国酒店一般不提供一次性用品，建议自备拖鞋、毛巾、洗漱用品、转换插座等物品。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="005"/>
                <em> 泰国酒店早餐没有什么很特殊的讲究，水果类很丰富，但是不一定有适合中国人肠胃的粥什么的，偏西式。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="006"/>
                <em> 我们建议您在住酒店期间，将每人每天20泰铢的小费放在床头，通过酒店预订的餐饮、娱乐、游玩等服务，可能需要收取额外服务费用，敬请您留意。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--泰国团队酒店描述 结束-->

<!--巴厘岛团队酒店描述  开始-->
<div class="gi-modal gi-modal-bldms">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="hotelBewrite['HB4']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> 巴厘岛早餐多以印尼式自助餐为主，印尼当地风味粥，青菜，肉，鸡蛋，水，果汁，咖啡等。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em> 巴厘岛酒店的自来水不可直接饮用，建议客人购买瓶装水饮用。</em>
            </label>
             <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em>巴厘岛为旅城市，酒店多以休闲度假为主，其中VILLA别墅为具有当地特色的一种住宿方式，主要是以体验当地特色为主，在VILLA别墅中的设施设备总体不如国际知名酒店，另因VILLA别墅以休闲安静为主，所以地理位置一般较为僻静；庭院中花草比较多，从而导致蚊虫较多，建议您在出行时自带防蚊药水。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em>巴厘岛VILLA别墅一般为大床房，无法安排拼房，建议您可以选择交付单房差享用一间房或与其他一同出游客人加床（加床一般为无床架的床垫）。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!-- 巴厘岛团队酒店描述 结束-->

<!--普吉岛团队酒店描述 开始-->
<div class="gi-modal gi-modal-pjdms">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="hotelBewrite['HB5']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> 普吉岛酒店大堂较小，早餐通常以自助餐的形式提供，较为简单。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em> 普吉岛酒店的自来水不可直接饮用，建议客人购买瓶装水饮用。</em>
            </label>
             <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em> 普吉岛当地酒店多以花园形式，庭院中花草比较多，导致蚊虫较多，建议您在出行时自带防蚊药水。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em> 普吉岛天气湿热，房间锁容易生锈，故如遇到房间无法正常打开等情况，还请联系酒店服务人员。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--普吉岛团队酒店描述 结束-->

<!--长滩团队酒店描述   开始-->
<div class="gi-modal gi-modal-ctms">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="hotelBewrite['HB6']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> 长滩岛为旅游热门目的地，酒店装潢多以简洁、舒适、干净的风格，但相对较小。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em> 长滩岛酒店的自来水不可直接饮用，建议客人购买瓶装水饮用。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em> 长滩酒店房间内设施设备简单、一般不提供拼房服务，如有需要，详询相关客服人员。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em> 长滩因气候湿热，故酒店蚊虫蚂蚁较多，建议您在出行时自带防蚊药水，亦可向前台咨询换房服务。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--长滩团队酒店描述   结束-->

<!--关岛团队酒店描述  开始-->
<div class="gi-modal gi-modal-gdms">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="hotelBewrite['HB7']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> 关岛酒店大堂较小，早餐通常以自助餐的形式提供，较为简单。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em> 关岛酒店的自来水不可直接饮用，建议客人购买瓶装水饮用。</em>
            </label>
             <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em> 关岛酒店一般不提供牙膏牙刷、沐浴露、洗发露等，建议自备。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em> 关岛多为情侣、家庭出游，无法安排拼房，建议您可以选择交付单房差享用一间房。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--关岛团队酒店描述 结束-->

<!--塞班团队酒店描述   开始-->
<div class="gi-modal gi-modal-sbms">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="hotelBewrite['HB8']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> 塞班岛酒店大堂较小，早餐通常以自助餐的形式提供，较为简单。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em> 塞班岛酒店的自来水不可直接饮用，建议客人购买瓶装水饮用。</em>
            </label>
              <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em> 塞班岛团队用房为双人标准间，无大床房安排（且不可2张床拼在一起），酒店可以安排加床（多为床垫或沙发床），无拼房服务。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em> 塞班岛美属海岛，酒店建成较久，故酒店设施设备不如国内的同等酒店设备，给您造成的不便，敬请谅解！</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--塞班团队酒店描述 结束-->

<!--美娜多团队酒店描述 开始-->
<div class="gi-modal gi-modal-mndms">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="hotelBewrite['HB9']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> 美娜多早餐通常为印尼式和欧式结合，面包，印尼当地风味粥，青菜，肉，鸡蛋，水，果汁，咖啡等。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em> 美娜多酒店大堂属于东南亚风格，不是很大，电梯一般8-13人左右承载。</em>
            </label>
             <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em> 美娜多酒店的自来水不可直接饮用，建议客人购买瓶装水饮用。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em> 美娜多房间多为大床房，1.8-2米不等规格，双床很少，一般是请酒店加被子。</em>
            </label>
             <label class="clearfix">
                <input type="checkbox" value="005"/>
                <em> 美娜多几乎所有酒店装有空调，除了少数海边的小型度假村，为了环保一般洗漱用品自备。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="006"/>
                <em> 美娜多酒店插座为印尼2项圆头的，最好提前准备好，酒店前台很少有备用。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--美娜多团队酒店描述 结束-->

<!--南亚团队酒店描述 开始-->
<div class="gi-modal gi-modal-nyms">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="hotelBewrite['HB10']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> 南亚 大部分当地酒店采用太阳能取热，无法24小时保证提供热水；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em> 当地供电不稳定，会不定时的停电，请游客做好心理准备，能自备照明工具。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em> 南亚自来水不能直接饮用， 建议客人购买瓶装水饮用。 </em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--南亚团队酒店描述 结束-->

<!--欧洲团队酒店描述 开始-->
<div class="gi-modal gi-modal-ozms">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="hotelBewrite['HB11']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> 欧洲跟团产品的酒店一般不安排在市区内，基本安排在城外35公里至100公里处，车程从市区到酒店一般要30分钟至90分钟；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em> 酒店大堂都比较小，无商场，电梯每次只能乘坐两个人和行李，大部分酒店甚至没有电梯；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em> 有些酒店的双人标准房会设置一大一小两张床，方便有小孩的家庭游客；还有些酒店双人房只设置一张大的双人大床，放置双份床上用品，有时是二张单人床拼在一起，用时可拉开。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em> 由于各种原因如环保、如历史悠久、如欧洲气候较温和等，较多酒店无空调。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="005"/>
                <em> 欧洲习惯吃简单的早餐，酒店提供的早餐通常只有面包、咖啡、茶、果汁等。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--欧洲团队酒店描述 结束-->

<!--澳新团队酒店描述 开始-->
<div class="gi-modal gi-modal-oxms">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="hotelBewrite['HB12']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> 澳洲酒店冷水龙头的自来水可直接饮用，水龙头的热水不能直接饮用。酒店客房内通常不提供开水，只有少部分酒店提供煮开水的用具。如您有饮热水的习惯，建议您自带小型电热杯。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em> 此外澳洲使用的是电压为240/250伏特50赫兹交流电，酒店插座为三相扁状插口，需使用转换插座，请在出行前自行准备。</em>
            </label>
             <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em> 酒店内通常提供免费和收费电视，观看收费闭路电视前先请查阅费用说明再做决定。如您无意收看收费电视，请在使用遥控器时避免接触相应的按键，酒店不会减免由于误操作而引起的费用。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em> 酒店客房内的电话拨打外线均需收费，此费用比较昂贵，建议在当地购买电话卡使用。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="005"/>
                <em> 我们选用干净、整洁、舒适的酒店安排入住，但是国外的星级评定标准与我国国内有一定差异，而且很多酒店建造年份已久，因此设施与国内同星级酒店相比较，普遍比较陈旧。</em>
            </label>
             <label class="clearfix">
                <input type="checkbox" value="006"/>
                <em> 澳洲很多酒店大堂不设置星级评定，而且大堂普遍较小。很多酒店出于环保，一般不提供个人洗漱用品，请您自带牙膏、牙刷、拖鞋、梳子、笔（需填写部分表格）等。部分酒店会提供沐浴液（Bath Liquid）、护发素（Hair Conditoner）和护肤液（Body Lotion）。某些客房内的床位是按一张双人床+一张沙发床或一张双人床+一张单人床的形式设置的。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--澳新团队酒店描述 结束-->

<!--美洲团队酒店描述 开始-->
<div class="gi-modal gi-modal-mgms">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="hotelBewrite['HB13']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> 美洲跟团行程安排的酒店一般在距离闹市区30-80分钟车程。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em> 部分酒店大堂较小，房间宽敞床大，房型不确定。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em> 早餐一般为美式简餐（冷/热）。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--美洲团队酒店描述 结束-->

<!--中东非团队酒店描述 开始-->
<div class="gi-modal gi-modal-zdfms">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="hotelBewrite['HB14']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> 中东非洲习惯吃简单的早餐，酒店提供的早餐通常只有面包、咖啡、茶、果汁等；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em> 中东非洲的当地酒店大堂和房间都比较小，电梯每次只能乘坐两个人和行李，有些酒店没有电梯；</em>
            </label>
             <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em> 中东非洲有些酒店的双人标准房会设置一大一小两张床，方便有小孩的家庭游客；还有些酒店双人房只设置一张大的双人大床，放置双份床上用品，有时是二张单人床拼在一起，用时可拉开；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em> 中东非洲的酒店提倡环保，部分酒店里不放一次性的用品。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="005"/>
                <em> 中东非洲部分目的地的特色酒店，由于地理位置，环保，气候较温和等原因无空调设备。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--中东非团队酒店描述 结束-->


<!-- 宿雾团队酒店描述 开始-->
<div class="gi-modal gi-modal-cebums">
    <a href="javascript:" class="gi-modal-close">&times;</a>

    <div class="gi-modal-content" data-key="hotelBewrite['HB15']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>宿雾气候潮湿、雨量充沛，入住酒店请自行携带蚊虫药，风油精等。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em>宿雾酒店大堂较小，房间以标间为主 。</em>
            </label>
             <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em>酒店早餐主要是以自助式早餐为主。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em>酒店自来水不可直接饮用， 建议客人自行购买矿泉水。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="005"/>
                <em>宿雾酒店内电源为220伏。插座为两眼圆孔、三眼扁形插座。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="006"/>
                <em>每天早晨在离开酒店房间时，建议放20菲币作为给打扫房间服务员的小费，行李员提拿行李请按国际礼仪支付小费。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="007"/>
                <em>酒店内食物和饮料如需要食用，酒店必须收费。房间内的电视部分节目收看需收取费用，请询问清楚后使用，以免结帐时发生误会。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="008"/>
                <em>酒店房间内不可打长途电话，如要打长途电话必需先付押金。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="009"/>
                <em>入住酒店时，私人财物请自行保管好，贵重物品可存放总台保险箱，饭店概不负责赔偿失窃物品。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--宿雾团队酒店描述 结束-->
<!-- 港澳团队酒店描述 开始-->
<div class="gi-modal gi-modal-hkmams">
    <a href="javascript:" class="gi-modal-close">&times;</a>
    <div class="gi-modal-content" data-key="hotelBewrite['HB16']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>港澳地区大部分酒店不提供一次性洗漱用品，建议您自备拖鞋、毛巾、洗漱用品、转换插座等物品；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em>港澳地区酒店均不挂星，我司页面所列酒店所示评分为住客网络评分，请知悉；</em>
            </label>
             <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em>港澳地区酒店房间面积相较于国内酒店普遍较小，故部分酒店不提供加床服务；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em>跟团游产品所用到的港澳地区酒店一般不安排在市中心或者热门商圈内，基本安排在离市中心或者热门商圈车程约30分钟至60分钟的范围内；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="005"/>
                <em>港澳地区酒店一般不提供免费早餐，如您需要在酒店内享用早餐需额外付费；</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--港澳团队酒店描述 结束-->
<!-- 新加坡马来西亚团队酒店描述 开始-->
<div class="gi-modal gi-modal-singmams">
    <a href="javascript:" class="gi-modal-close">&times;</a>
    <div class="gi-modal-content" data-key="hotelBewrite['HB17']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>新马旅游业起步较早，酒店建造的年份较长，房间也比国内的小。位置较好的酒店，都在老城区，老城区基本没有大型酒店。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em>出于环保考虑，大部分酒店不提供牙膏牙刷，沐浴露和拖鞋等一次性洗漱用品。</em>
            </label>
             <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em>当地酒店一般不能加床。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em>酒店提供的早餐普遍为西式自助简餐。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--新加坡马来西亚团队酒店描述 结束-->
<!-- 台湾团队酒店描述 开始-->
<div class="gi-modal gi-modal-taiwanms">
    <a href="javascript:" class="gi-modal-close">&times;</a>
    <div class="gi-modal-content" data-key="hotelBewrite['HB18']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>房型默认为双人标间；可申请三人间、大床房或者拼房，需预订时提前告知，将尽力安排。如遇旺季满房，酒店标准将按照产品同级别安排 。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--台湾团队酒店描述 结束-->

<!-- 沙巴 文莱团队酒店描述 开始-->
<div class="gi-modal gi-modal-sabahbrunei">
    <a href="javascript:" class="gi-modal-close">&times;</a>
    <div class="gi-modal-content" data-key="hotelBewrite['HB19']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> 酒店早餐多为自助餐，都不含饮料、酒水，如客人需要饮料或酒，请自行付费。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em> 酒店内的水需要烧开后饮用，建议饮用瓶装、罐装或杯装水及饮料。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em> 严禁在酒店房间内煮食，违者最高罚款可达美金5000。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em> 沙巴、文莱电压为220伏特，插孔为英标三孔方型。需要准备插座转换器。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="005"/>
                <em> 在汶莱国的任何酒店都没有卖酒，客人可带酒进汶莱，但必须填写表格。每成人2瓶烈酒和12罐啤酒，在酒店用餐想要喝酒必须先请示导游。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="006"/>
                <em> 在汶莱国所有酒店、汶莱航空上都没有猪肉。请尊重当地民风，入乡随俗。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="007"/>
                <em> 酒店内的电话及部分电视频道可能需要收费，请询问清楚后使用，以免结账时发生误会。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="008"/>
                <em> 贵重物品及钱款请务必随身携带或存放在宾馆总台保险柜内，切勿留在房间里或放在行李中及客车车厢里的行李箱内。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--沙巴 文莱团队酒店描述 结束-->

<!-- 兰卡威团队酒店描述 开始-->
<div class="gi-modal gi-modal-langkawi">
    <a href="javascript:" class="gi-modal-close">&times;</a>
    <div class="gi-modal-content" data-key="hotelBewrite['HB20']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em> 办理完入住手续后，入住房间请先检查房间设施是否完整无损，房间是否干净整洁，如有问题请及时和酒店前台联系。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em>  酒店房费中一般只包含早餐或有特别说明连住几晚赠送晚餐等，其余餐食均不包含。
                    <br>早餐券或赠送餐食券于办理入住时前台会和房卡一同交给您，如果您连续入住多日，请保管好餐券，如有遗失请及时联系酒店前台。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em> 酒店房间内的迷你吧或冰箱里饮料酒水小食是要收费的，如您有消费需要在离店时自己付清费用，房费中不包含。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em> 酒店早餐时间一般为早晨07:00-09:00/10:00，具体用餐时间以酒店披露时间为准，请您于用餐时间内前往餐厅用餐，若超过用餐时间，可能会无法用早餐，请知晓。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="005"/>
                <em> 境外酒店入住，需要支付房间押金，一般为1晚或2晚房费的金额，具体金额以酒店前台收取金额为准，退房时若无损坏酒店物品或房费以外的消费，押金于办理退房手续时退还，若以现金形式支付，退还现金；若以信用卡方式支付，则退还回信用卡中，退还信用卡时间比较漫长，一般为15天-30天不等，甚至更久，可拨打信用卡发放银行的客服电话进查询退款进度。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="006"/>
                <em> 兰卡威政府规定从2016年7月1日起对入住酒店的游客征收旅游保护税，金额：约折合人民币2RMB-13RMB每间每晚（依据入住标准不等收费不同）；按照入住日期征收，提前付款无法免除，旅行社亦不能代付，具体金额请于入住酒店酒店提供的账单为准，于酒店现场支付，停止征收日期尚未通知，请知晓！</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
</div>
<!--兰卡威团队酒店描述 结束-->
<!-- 模态窗口 结束-->

<!--/弹出层END-->


<div class="JS_template_inner">

    <!--其他 开始-->
    <div class="gi-other">
        <input type="text" name="refundExplainInput" class="input-text gi-w600 JS_checkbox_disabled" value="" data-validate="true" required
               maxlength="500" data-validate="true" required/>
        <a href="javascript:" class="gi-del gi-other-del">删除</a>
    </div>
    <!--其他 结束-->

    <span class="JS_ta_limit_other">
        <input type="text" class="JS_checkbox_disabled input-text gi-w400 placeholder"
               data-placeholder="其他限制" name="otherIn" data-validate="true" required/>
        <a href="javascript:;" class="JS_ta_limit_other_del">删除</a>
    </span>

    <span class="JS_ta_reception_other">
        <input type="text" class="JS_checkbox_disabled input-text gi-w400 placeholder"
               data-placeholder="其他限制" name="receptionOther" data-validate="true" required/>
        <a href="javascript:;" class="JS_ta_reception_other_del">删除</a>
    </span>

</div>


<script src="http://pic.lvmama.com/min/index.php?f=/js/new_v/jquery-1.7.2.min.js"></script>
<!-- 引入基本的js -->
<#include "/base/foot.ftl"/>

<!--新增脚本文件-->
<script src="/vst_admin/js/vst-product-provision-out.js"></script>
<script>
(function() {
     //初始化页面默认选中项
    initPageChecked();

    var $document = $(document);
    $document.on("click", ".JS_button_save", function () {
        if(!refund_explain.requireChecked() && $("input[name='packageType']").val()=="SUPPLIER"){
            $.alert("退改说明必填");
            return;
        }
        if(!$(".productSuggOutForm").validate().form()){
            return;
        }


        var $this = $(this);
        var $giForm = $this.parents(".box_content");

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

        //表单
        (function () {
            var validate = $form.validate();
            var $input = $form.find('[data-validate="true"]:not([disabled])');

            $input.each(function (index) {
                var $required = $input[index];
                var ret = validate.element($required);
                if (!ret) {
                    isValidate = false;
                }
            });
        })();

        //验证通过
        var alertObj;
        if (isValidate) {
            //ajax保存出行警示（出境）VO数据
            changeSaveButtonStatus(true);
            saveTravelAlertOutside();
        } else {
            alertObj = $.saveAlert({
                "width": 250,
                "type": "danger",
                "text": "请完成必填填写项并确认填写正确"
            });
        }

    });

    //点击 查看编辑范围
    $document.off("click", ".JS_checkbox_hidden");
    $document.on("click", ".JS_checkbox_hidden", function() {
        // 获取查看编辑范围 a标签的父label
        var $label = $(this).closest("label");
        var value = "";
        if ($label.length > 0) {
             value = $label.find("input[type='checkbox']").val();
        }

        //获得当前弹出的模态窗口的主DIV的class
        var classTag = $(this).data("class");
        
        if (isEmpty(value)) {
            //将弹出模态框内的所有checkbox控件设置为不选中
            if(classTag!="gi-modal-ax"){
            	$("." + classTag + " input[type='checkbox']").removeAttr("checked");
            }else{//澳新默认为选中
            	$("." + classTag + " input[type='checkbox']").attr("checked","checked");
            }
        } else {
            var checkboxValues = value.split(",");
            $.each(checkboxValues, function(index, value) {
                $("." + classTag + " input[value='"+ value +"']").attr("checked", "checked");
            });

            //判断是否选中弹出的模态框内的全选按钮
            var checkboxs = $("." + classTag).find("input[type='checkbox']:not('.gi-check-all')");
            if (checkboxs.length == checkboxValues.length) {
                $("." + classTag + " .gi-check-all").attr("checked", "checked");
            }
        }
    });

    //点击 弹出框中 确定按钮
    $document.off("click", ".gi-save-btn");
    $document.on("click", ".gi-save-btn", function() {
        var $modalContent = $(this).closest(".gi-modal-content");

        //获得弹出框中所有被选中的checkbox（除去全选按钮）
        var selectedCheckBoxs = $modalContent.find("input[type='checkbox']:checked:not('.gi-check-all')");

        //接收组合好的被选中checkbox控件的value字符串
        var buildValueStr = "";
        $.each(selectedCheckBoxs, function(index, selectedCheckBox) {
            var value = $(selectedCheckBox).val();
            buildValueStr += value + ",";
        });

        //删除字符串中最后一个','号
        if (buildValueStr != "") {
            buildValueStr = buildValueStr.substring(0, buildValueStr.length-1);
        }

        //找到弹框对应的主页面中checkbox控件回填其value值
        var nameKey = $modalContent.data("key");
        $("input[name='"+ nameKey +"']").val(buildValueStr);
    });

    // 保存出行警示（出境）信息
    function saveTravelAlertOutside() {

        $.ajax({
            url : "/vst_admin/dujia/group/product/saveOrUpdateProductSuggOut.do",
            data : $(".productSuggOutForm").serialize(),
            type : "POST",
            dataType : "JSON",
            success : function(result) {
                if (result.code == "success") {
                    window.location.reload();
                    $.saveAlert({"width": 150,"type": "success","text": result.message});
                } else {
                    $.saveAlert({"width": 250,"type": "danger","text": result.message});
                }

				changeSaveButtonStatus(false);
            },
            error: function() {
                //改变保存按钮状态
                changeSaveButtonStatus(false);
                console.log("Call saveOrUpdateProductSuggOut method occurs error");
                $.saveAlert({"width": 250,"type": "danger","text": "网络服务异常, 请稍后重试"});
            }
        });
    }
    
    
    
    //改变 保存、保存并下一步 按钮的状态（isLoading：true 保存前 false 保存结束后）
    function changeSaveButtonStatus(isLoading) {
    	var $form = $(".productSuggOutForm");
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

    //初始化页面默认选中项
    function initPageChecked() {
        var travelAlertOutProdDescId = $(".travelAlertOutsideHiddenDiv>input[name='travelAlertOutProdDescId']").val();
        //如果travelAlertOutProdDescId为空，表示页面是新增页面需要初始化页面默认选中项
        if (isEmpty(travelAlertOutProdDescId)) {
            $("input[name='addBed'][value='001']").attr("checked", "checked");
            $("input[name='latestMater'][value='user_sele']").attr("checked", "checked");
            $("select[name='latestMaterDay']").removeAttr("disabled");
            $("input[name='other'][value='001']").attr("checked", "checked");
            //初始化 线路条款 中的每个checkbox的value值
            $(".gi-color-green").css("display", "inline");
            $("input[name=\"clause['LC1']\"]").val("001,002,003,004,005,006");
            $("input[name=\"clause['LC2']\"]").val("001,002,003,005,006,007");
            $("input[name=\"clause['LC3']\"]").val("001,002,003,004,005,006");
            $("input[name=\"clause['LC4']\"]").val("001,002");
            $("input[name=\"clause['LC5']\"]").val("001,002,003");
            $("input[name=\"clause['LC6']\"]").val("001,002");
            $("input[name=\"clause['LC7']\"]").val("001,002");
            $("input[name=\"clause['LC8']\"]").val("001,002,003,004,005,006");
            $("input[name=\"clause['LC9']\"]").val("001");
            $("input[name=\"clause['LC10']\"]").val("001");
            $("input[name=\"clause['LC11']\"]").val("001,003,004");
            $("input[name=\"clause['LC12']\"]").val("001");					
            $("input[name=\"hotelBewrite['HB1']\"]").val("001,002,003,004,005");
            $("input[name=\"hotelBewrite['HB2']\"]").val("001,002,003");
            $("input[name=\"hotelBewrite['HB3']\"]").val("001,002,003,004,005,006");
            $("input[name=\"hotelBewrite['HB4']\"]").val("001,002,003,004");
            $("input[name=\"hotelBewrite['HB5']\"]").val("001,002,003,004");
            $("input[name=\"hotelBewrite['HB6']\"]").val("001,002,003,004");
            $("input[name=\"hotelBewrite['HB7']\"]").val("001,002,003,004");
            $("input[name=\"hotelBewrite['HB8']\"]").val("001,002,003,004");
            $("input[name=\"hotelBewrite['HB9']\"]").val("001,002,003,004,005,006");
            $("input[name=\"hotelBewrite['HB10']\"]").val("001,002,003");
            $("input[name=\"hotelBewrite['HB11']\"]").val("001,002,003,004,005");
            $("input[name=\"hotelBewrite['HB12']\"]").val("001,002,003,004,005,006");
            $("input[name=\"hotelBewrite['HB13']\"]").val("001,002,003");
            $("input[name=\"hotelBewrite['HB14']\"]").val("001,002,003,004,005");
            $("input[name=\"hotelBewrite['HB15']\"]").val("001,002,003,004,005,006,007,008,009");
            $("input[name=\"hotelBewrite['HB16']\"]").val("001,002,003,004");
            $("input[name=\"hotelBewrite['HB17']\"]").val("001,002,003,004,005");
            $("input[name=\"hotelBewrite['HB18']\"]").val("001");
            $("input[name=\"hotelBewrite['HB19']\"]").val("001,002,003,004,005,006,007,008");
            $("input[name=\"hotelBewrite['HB20']\"]").val("001,002,003,004,005,006");
        }
        var refundExplainOutProdDescId = $(".refundExplainOutsideHiddenDiv>input[name='refundExplainOutProdDescId']").val();
        //如果refundExplainOutProdDescId为空，表示页面是新增页面需要初始化页面默认选中项\
        if (isEmpty(refundExplainOutProdDescId)) {
            $("input[name='refundExplain']").each(function () {
                var $me = $(this);
                var $meVal = $me.val();
                if($meVal == '000' || $meVal == '101' || $meVal == '102'){

                }else{
                    $me.attr("checked", "checked")
                }
            });
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
    
    //移除保存按钮
	isRemoveSaveButton();
	
	function isRemoveSaveButton(){
		if($("#isView",parent.document).val()=='Y' || $("#isView",parent.top.document).val()=='Y'){
			//移除保存,增加一条，删除按钮
			$("a[class*=JS_button_save],a[class*=JS_other_add_btn],a[class*=gi-other-del],a[class*=JS_ta_limit_other_add],a[class*=JS_ta_reception_other_add]").remove();
		}
	}


})();

    $(function () {
        refund_explain.init();
    });
    /*
     * 做了一件事情，包机条款和跟团条款，只能选中一个
     * */
    var refund_explain = {
        groupLi: $("div[name='groupList'] input[name='refundExplain']"),
        airPlaneLi: $("div[name='airPlaneList'] input[name='refundExplain']"),
        otherInputLi:$("div[name='otherInputList'] input[name='refundExplainInput']"),
        init: function() {
            //跟团条款添加点击事件
            refund_explain.groupLi.each(function () {
                $(this).bind('click', function () {
                    $me = $(this);
                    $meVal = $me.val();
                    if(refund_explain.isChecked($me) && refund_explain.hasChecked(refund_explain.airPlaneLi)){
                        refund_explain.unChecked($me);
                        $.alert('请先取消包机条款！');
                    }
                });
            });
            //包机条款添加点击事件
            refund_explain.airPlaneLi.each(function () {
                $(this).bind('click', function () {
                    $me = $(this);
                    $meVal = $me.val();
                    if(refund_explain.isChecked($me) && refund_explain.hasChecked(refund_explain.groupLi)){
                        refund_explain.unChecked($me);
                        $.alert('请先取消跟团条款！');
                    }
                });
            });
        },
        hasChecked: function (obj) {
            var checkFlag = false;
            if(typeof obj == 'object' && obj != null){
                var len = obj.length;
                for(var i=0;i<len;i++){
                    var $temp = $(obj[i]);
                    if(refund_explain.isChecked($temp)){
                        checkFlag = true;
                        break;
                    }
                }
            }
            return checkFlag;
        },
        isChecked: function (obj) {
            var checkFlag = false;
            if(typeof obj == 'object' && obj != null && obj.attr('checked') == 'checked'){
                checkFlag = true;
            }
            return checkFlag;
        },
        unChecked: function (obj) {
            if(typeof obj == 'object' && obj != null){
                obj.removeAttr('checked');
            }
        },
        checked: function () {
            if(!refund_explain.isChecked(obj)){
                obj.removeAttr('checked');
            }
        },
        requireChecked: function () {
            var required = false;
            refund_explain.groupLi.each(function () {
                $me = $(this);
                if (refund_explain.isChecked($me) || refund_explain.hasChecked(refund_explain.airPlaneLi)) {
                    required = true;
                    return false;
                }
            });

            refund_explain.airPlaneLi.each(function () {
                $me = $(this);
                if (refund_explain.isChecked($me) || refund_explain.hasChecked(refund_explain.groupLi)) {
                    required = true;
                    return false;
                }
            });
            return required;

        }
    };



</script>
</body>
</html>

