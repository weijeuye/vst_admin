<#if costIncludeOutsideVO.localTraffic??>
<#list costIncludeOutsideVO.localTraffic as ltraffic> 
    <#if ltraffic =="local_tra">
       <#assign local_tra = 'Y' />
    </#if>
    <#if ltraffic =="local_tra_boat">
       <#assign local_tra_boat = 'Y' />
    </#if>
    <#if ltraffic =="local_tra_scenic">
       <#assign local_tra_scenic = 'Y' />
    </#if>
    <#if ltraffic =="local_tra_pub_tra">
       <#assign local_tra_pub_tra = 'Y' />
    </#if>
    <#if ltraffic =="local_tra_other">
       <#assign local_tra_other = 'Y' />
    </#if>
</#list>
</#if>

<#if costIncludeOutsideVO.staySec??>
<#list costIncludeOutsideVO.staySec as outSec>
    <#if outSec =="only_designated">
       <#assign only_designated = 'Y' />
    </#if>
    <#if outSec =="no_extra_bed">
       <#assign no_extra_bed = 'Y' />
    </#if>
</#list>
</#if>

<#if costIncludeOutsideVO.ticketSel??>
<#list costIncludeOutsideVO.ticketSel as outtickSel>
    <#if outtickSel =="union_ticket">
       <#assign only_designated = 'Y' />
    </#if>
    <#if outtickSel =="give_ticket">
       <#assign no_extra_bed = 'Y' />
    </#if>
</#list>
</#if>

<#if costIncludeOutsideVO.dinnerSel??>
<#list costIncludeOutsideVO.dinnerSel as outdinnerSel>
    <#if outdinnerSel =="dinner_price">
       <#assign dinner_price = 'Y' />
    </#if>
    <#if outdinnerSel =="dinner_food">
       <#assign dinner_food = 'Y' />
    </#if>
</#list>
</#if>

<#if costIncludeOutsideVO.chilPriStanSec??>
<#list costIncludeOutsideVO.chilPriStanSec as outchilP>
    <#if outchilP =="chil_age">
       <#assign chil_age = 'Y' />
    </#if>
    <#if outchilP =="chil_hei">
       <#assign chil_hei = 'Y' />
    </#if>
    <#if outchilP =="chil_equ">
       <#assign chil_equ = 'Y' />
    </#if>
</#list>
</#if>

<#if costIncludeOutsideVO.chilCostInclCheck??>
<#list costIncludeOutsideVO.chilCostInclCheck as outcheck>
    <#if outcheck =="CHILD_ROUND_T">
       <#assign CHILD_ROUND_T = 'Y' />
    </#if>
    <#if outcheck =="CHILD_TICKET">
       <#assign CHILD_TICKET = 'Y' />
    </#if>
    <#if outcheck =="CHILD_TOUR_GUIDE_SER">
       <#assign CHILD_TOUR_GUIDE_SER = 'Y' />
    </#if>
    <#if outcheck =="CHILD_VISA">
       <#assign CHILD_VISA = 'Y' />
    </#if>
    <#if outcheck =="CHILD_PACK">
       <#assign CHILD_PACK = 'Y' />
    </#if>
    <#if outcheck =="CHILD_DINNER">
       <#assign CHILD_DINNER = 'Y' />
    </#if>
</#list>
</#if>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>费用说明出境</title>
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
                <#if noEditFlag == "true"><a href="javascript:void(0);" id="toEdit">编辑费用</a></#if>
            </div>
            <!--线路行程 开始-->
            <div class="gi-form">

                <div class="tiptext tip-warning" <#if isAddPage?? && isAddPage>style="display:block;"<#else>style="display:none;"</#if>>
                    <span class="tip-icon tip-icon-warning"></span>温馨提示：默认勾选项请点击保存才会生效
                </div>

               <form class="costOutsideForm" action="#" method="post">
                    <p>
                        费用包含说明：
                    </p>
                    <!--费用包含 国外 开始-->
                    <div class="gi-form JS_inner_include_abroad">
                       
        <#-- 隐藏域存放DIV -->
        <div class="costOutsideHiddenDiv" style="display:none;">
            <input type="hidden" name="categoryId" value="15"/>
            <input type="hidden" name="productId" value="${productId}"/>
            <input type="hidden" name="productType" value="${productType}" />
            <input type="hidden" name="lineRouteId" value="${lineRouteId}"/>
        </div>

        <dl class="clearfix">
            <dt>
                大交通 ：
            </dt>
            <dd class="JS_radio_box">
                <label class="gi-mr15">
                    <input type="radio"    class="JS_radio_switch" name="largeTrans" value="team_ticket" required data-validate="true"
                         <#if costIncludeOutsideVO.largeTrans=='team_ticket'>checked="checked"</#if> />
                    团队机票
                </label>
                <label class="gi-mr15">
                    <input type="radio" class="JS_radio_switch" name="largeTrans" value="fit"  <#if costIncludeOutsideVO.largeTrans=='fit'> checked="checked"</#if> />
                    散客机票
                </label>
                <label class="gi-mr15">
                    <input type="radio"    class="JS_radio_switch" name="largeTrans" value="bus" required data-validate="true"
                         <#if costIncludeOutsideVO.largeTrans=='bus'>checked="checked"</#if> />
                    巴士
                </label>
                <label class="gi-mr15">
                    <span class="JS_radio_switch_box">
                    <input type="radio" name="largeTrans" value="lt_other"  <#if costIncludeOutsideVO.largeTrans=='lt_other'> checked="checked"</#if>  class="JS_radio_switch"/>
                    <input type="text" class="input-text JS_radio_disabled placeholder" <#if costIncludeOutsideVO.largeTrans!='lt_other'>disabled="disabled"</#if>
                           data-placeholder="自定义"   data-validate="true" required
                           maxlength="100" name="largeTransInput"  value="${costIncludeOutsideVO.largeTransInput!'自定义'}" />
                    </span>
                </label>
                <span class="JS_radio_switch_box">
                <p>
                    <label>
                        
                        <input type="radio" name="largeTrans"  value="differ"  <#if costIncludeOutsideVO.largeTrans=='differ'>checked="checked"</#if>  class="JS_radio_switch"/>
                        出发返程目的地不一致
                    </label>
                </p>
                <p>
                    <label class="gi-ml20">
                        出发
                        <select style="width:90px;" name="startWay" class="JS_radio_disabled" <#if costIncludeOutsideVO.largeTrans!='differ'>disabled="disabled"</#if> data-validate="true" required>
                            <option value="team_ticket" <#if costIncludeOutsideVO.startWay=='team_ticket'>selected="selected"</#if>>团队机票</option>
                            <option value="fit" <#if costIncludeOutsideVO.startWay=='fit'>selected="selected"</#if>>散客机票</option>
                            <option value="bus" <#if costIncludeOutsideVO.startWay=='bus'>selected="selected"</#if>>巴士</option>
                        </select>
                        <input maxlength="15" name="startPlace" value="${costIncludeOutsideVO.startPlace}" type="text" data-validate="true" required placeholder="出发地" class="input-text JS_radio_disabled" <#if costIncludeOutsideVO.largeTrans!='differ'>disabled="disabled"</#if>/>-<input maxlength="15" name="startDest" value="${costIncludeOutsideVO.startDest}" type="text" data-validate="true" required placeholder="目的地" class="input-text JS_radio_disabled" <#if costIncludeOutsideVO.largeTrans!='differ'>disabled="disabled"</#if>/>
                    </label>
                </p>

                <p>
                    <label class="gi-ml20">
                        返程
                        <select style="width:90px;" name="endWay" class="JS_radio_disabled" <#if costIncludeOutsideVO.largeTrans!='differ'>disabled="disabled"</#if> data-validate="true" required>
                            <option value="team_ticket" <#if costIncludeOutsideVO.endWay=='team_ticket'>selected="selected"</#if>>团队机票</option>
                            <option value="fit" <#if costIncludeOutsideVO.endWay=='fit'>selected="selected"</#if>>散客机票</option>
                            <option value="bus" <#if costIncludeOutsideVO.endWay=='bus'>selected="selected"</#if>>巴士</option>
                        </select>
                            <input maxlength="15" name="endPlace" value="${costIncludeOutsideVO.endPlace}" type="text" data-validate="true" required placeholder="出发地" class="input-text JS_radio_disabled" <#if costIncludeOutsideVO.largeTrans!='differ'>disabled="disabled"</#if>/>-<input maxlength="15" name="endDest" value="${costIncludeOutsideVO.endDest}" type="text" data-validate="true" required placeholder="目的地" class="input-text JS_radio_disabled" <#if costIncludeOutsideVO.largeTrans!='differ'>disabled="disabled"</#if>/>
                    </label>
                </p>
               </span>
            </dd>
        </dl>

        <div class="gi-hr"></div>


        <dl class="clearfix">
            <dt>

                当地交通 ：
            </dt>
            <dd>
                <p>
                    <span class="JS_checkbox_switch_box">
                        <input type="checkbox"   name="localTraffic" value="local_tra"  class="JS_checkbox_switch"   <#if local_tra=='Y'>checked="checked"</#if>   />
                        当地旅游车
                        <span class="JS_checkbox_hidden">（保证一人一正座位，车型大小根据游客实际人数安排）</span>
                    </span>
                </p>

                <p>
                    <label>
                        <span class="JS_checkbox_switch_box">
                        <input type="checkbox" name="localTraffic"  value="local_tra_boat" class="JS_checkbox_switch"   <#if local_tra_boat=='Y'>checked="checked"</#if>   />
                        <input type="text" class="input-text JS_checkbox_disabled placeholder"
                               data-placeholder="船票信息"  name="localTraBoat" <#if local_tra_boat!='Y'>disabled="disabled"</#if> 
                               data-validate="true" required maxlength="100" value="${costIncludeOutsideVO.localTraBoat!'船票信息'}"/>
                        船票
                        </span>
                    </label>
                </p>

                <p>
                    <label>
                        <span class="JS_checkbox_switch_box">
                        <input type="checkbox" name="localTraffic" value="local_tra_scenic"  class="JS_checkbox_switch" <#if local_tra_scenic=='Y'>checked="checked"</#if> />
                        <input type="text" class="input-text JS_checkbox_disabled placeholder"  <#if local_tra_scenic!='Y'>disabled="disabled"</#if>
                               data-placeholder="景区信息"   name="localTraScenic" value="${costIncludeOutsideVO.localTraScenic!'景区信息'}"
                               data-validate="true" required maxlength="100"/>
                        景区小交通
                        </span>
                    </label>
                </p>

                <p>
                    <label>
                        <span class="JS_checkbox_switch_box">
                        <input type="checkbox" name="localTraffic" value="local_tra_pub_tra" class="JS_checkbox_switch" <#if local_tra_pub_tra=='Y'>checked="checked"</#if> />
                        <input type="text" class="input-text JS_checkbox_disabled placeholder" <#if local_tra_pub_tra!='Y'>disabled="disabled"</#if>
                               data-placeholder="其他公共交通信息"    name="localTraPubTra" value="${costIncludeOutsideVO.localTraPubTra!'其他公共交通信息'}"
                               data-validate="true" required maxlength="100"/>
                        公共交通车费
                        </span>
                    </label>
                </p>

                <p>
                    <span class="JS_checkbox_switch_box">
                    <input type="checkbox" name="localTraffic" value="local_tra_other"  class="JS_checkbox_switch"  <#if local_tra_other=='Y'>checked="checked"</#if>  />
                    <input type="text" class="input-text JS_checkbox_disabled placeholder" <#if local_tra_other!='Y'>disabled="disabled"</#if>
                           data-placeholder="其他用车信息" name="localTraOther" value="${costIncludeOutsideVO.localTraOther!'其他用车信息'}"
                           data-validate="true" required maxlength="100"/>
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

                        <div class="gi-abroad-stay-radio">
                            <input name="stay" type="radio" value="stay_dest_hotel" <#if costIncludeOutsideVO.stay=='stay_dest_hotel'>checked="checked"</#if>
                                   class="JS_radio_switch JS_checkbox_main JS_other_judge_ctrl" />
                        </div>

                        <div class="gi-abroad-stays" data-validate-extend="true" data-maxlength="500" data-tiplength="450">
                      <#if costIncludeOutsideVO.stayDest??& costIncludeOutsideVO.stayDest?size &gt; 0>
                         <#list costIncludeOutsideVO.stayDest as destName>
                            <div class="gi-abroad-stay">
                                <input class="input-text JS_radio_disabled placeholder" type="text" <#if costIncludeOutsideVO.stay!='stay_dest_hotel'>disabled="disabled"</#if>
                                       data-placeholder="输入目的地名称" name="stayDest" value="${destName}"
                                       maxlength="10" data-validate="true" required/>
                                <input class="input-text JS_radio_disabled placeholder" type="text" data-placeholder="输入酒店名称"  <#if costIncludeOutsideVO.stay!='stay_dest_hotel'>disabled="disabled"</#if>
                                       maxlength="90" data-validate="true" required name="stayHotel" value="${costIncludeOutsideVO.stayHotel[destName_index]}" />
                                <select class="JS_radio_disabled" name="staySel"  <#if costIncludeOutsideVO.stay!='stay_dest_hotel'>disabled="disabled"</#if> >
                                    <option data-placeholder="双人标准间" <#if costIncludeOutsideVO.staySel[destName_index]=="DOU_STA_ROOM">selected </#if>  value="DOU_STA_ROOM"  >双人标准间</option>
                                    <option data-placeholder="双人大床房" <#if costIncludeOutsideVO.staySel[destName_index]=="TWIN_BED">selected </#if> value="TWIN_BED" >双人大床房</option>
                                    <option data-placeholder="双人标准间或大床房" <#if costIncludeOutsideVO.staySel[destName_index]=="DOU_STA_OR_TWIN_BED">selected </#if> value="DOU_STA_OR_TWIN_BED" >双人标准间或大床房</option>
                                    <option data-placeholder="双人标准间或单人间"   <#if costIncludeOutsideVO.staySel[destName_index]=="DOU_STA_OR_SINGLE_ROOM">selected </#if> value="DOU_STA_OR_SINGLE_ROOM" >双人标准间或单人间</option>
                                </select>
                             <#if destName_index gt 0>
                                 <a href="javascript:" class="gi-del gi-abroad-stay-del-btn">删除</a>
                             </#if>
                            </div>
                         </#list>
                      <#else>
                          <div class="gi-abroad-stay">
                                <input class="input-text JS_radio_disabled placeholder" type="text"
                                       data-placeholder="输入目的地名称" name="stayDest"  value="输入目的地名称"  <#if costIncludeOutsideVO.stay==null|costIncludeOutsideVO.stay!='stay_dest_hotel'>disabled="disabled"</#if>
                                       maxlength="10" data-validate="true" required/>
                                <input class="input-text JS_radio_disabled placeholder" type="text" data-placeholder="输入酒店名称" value="输入酒店名称" <#if costIncludeOutsideVO.stay==null|costIncludeOutsideVO.stay!='stay_dest_hotel'>disabled="disabled"</#if>
                                       maxlength="90" data-validate="true" required name="stayHotel"   />
                                <select class="JS_radio_disabled" name="staySel"  <#if costIncludeOutsideVO.stay==null|costIncludeOutsideVO.stay!='stay_dest_hotel'>disabled="disabled"</#if>>
                                    <option data-placeholder="双人标准间"  selected  value="DOU_STA_ROOM"  >双人标准间</option>
                                    <option data-placeholder="双人大床房"   value="TWIN_BED" >双人大床房</option>
                                    <option data-placeholder="双人标准间或大床房"   value="DOU_STA_OR_TWIN_BED" >双人标准间或大床房</option>
                                    <option data-placeholder="双人标准间或单人间"   value="DOU_STA_OR_SINGLE_ROOM" >双人标准间或单人间</option>
                                </select>
                            </div>
                      </#if>

                            <div class="gi-abroad-stay-add">
                                <a href="javascript:" class="gi-abroad-stay-add-btn">
                                    增加一条
                                </a>
                            </div>

                        </div>
                    </div>

                    <p>
                    <span class="gi-ml20">
                        <label>
                            <input type="checkbox" class="JS_radio_disabled" name="staySec" value="only_designated"  <#if only_designated=="Y">checked</#if>  <#if costIncludeOutsideVO.stay==null|costIncludeOutsideVO.stay!='stay_dest_hotel'>disabled="disabled"</#if>   />
                            此线路参考酒店为唯一指定入住酒店（遇不可抗力特殊情况除外）
                        </label>
                    </span>
                    </p>

                    <p>
                    <span class="gi-ml20">
                        <label>
                            <input type="checkbox" class="JS_radio_disabled" name="staySec"  value="no_extra_bed"  <#if no_extra_bed=="Y">checked</#if> <#if costIncludeOutsideVO.stay==null|costIncludeOutsideVO.stay!='stay_dest_hotel'>disabled="disabled"</#if>  />
                            此线路酒店无三人间且不能加床
                        </label>
                    </span>
                    </p>
                </div>

                <p>
                    <span class="JS_radio_switch_box">
                    <input type="radio" name="stay" value="stay_other"  class="JS_radio_switch"  <#if costIncludeOutsideVO.stay=='stay_other'>checked="checked"</#if> />
                    <input class="input-text gi-w250 JS_radio_disabled placeholder"  type="text"  <#if costIncludeOutsideVO.stay!='stay_other'>disabled="disabled"</#if>
                           data-placeholder="输入补充信息或自定义"  data-validate="true" required name="stayOther"
                           maxlength="500" value="${costIncludeOutsideVO.stayOther!'输入补充信息或自定义'}"/>
                    </span>
                </p>

            </dd>
        </dl>

        <div class="gi-hr"></div>

        <dl class="clearfix">
            <dt>

                门票 <a class="JS_none" href="javascript:;">无</a>：
            </dt>
            <dd class="JS_radio_box">
                <div class="JS_radio_switch_box">
                    <p>
                        <label>

                            <input type="radio" name="ticket"  value="include_ticket"  <#if costIncludeOutsideVO.ticket=='include_ticket'>checked="checked"</#if>  class="JS_radio_switch"/>
                            包含
                            <input type="text" class="input-text gi-w350 JS_radio_disabled placeholder" <#if costIncludeOutsideVO.ticket==null|costIncludeOutsideVO.ticket!='include_ticket'>disabled="disabled"</#if> 
                                   data-placeholder="输入景点" name="ticketInput" value="${costIncludeOutsideVO.ticketInput!'输入景点'}"
                                   maxlength="100"  data-validate="true" required />
                            首道大门票

                        </label>
                    </p>

                    <p>
                        <label>
                        <span class="gi-ml20 JS_checkbox_switch_box">
                        <input type="checkbox" name="ticketSel" value="union_ticket" <#if union_ticket=='Y'>checked</#if>   <#if costIncludeOutsideVO.ticket==null|costIncludeOutsideVO.ticket!='include_ticket'>disabled="disabled"</#if> class="JS_checkbox_switch JS_radio_disabled"      />
                        其中
                        <input type="text" class="input-text JS_checkbox_disabled placeholder"
                               data-placeholder="输入景点" name="ticketViewSpot1" <#if costIncludeOutsideVO.ticket!='include_ticket'|union_ticket!='Y'>disabled="disabled"</#if> 
                               value="${costIncludeOutsideVO.ticketViewSpot1!'输入景点'}"
                               data-validate="true" maxlength="100" required/>
                        为联票，放弃其中任何一个景点费用不退
                        </span>
                        </label>
                    </p>

                    <p>
                        <label>
                        <span class="gi-ml20 JS_checkbox_switch_box">
                        <input type="checkbox" name="ticketSel" value="give_ticket" <#if give_ticket=='Y'>checked</#if>  <#if costIncludeOutsideVO.ticket==null|costIncludeOutsideVO.ticket!='include_ticket'>disabled="disabled"</#if>  class="JS_checkbox_switch JS_radio_disabled"    />
                        其中
                        <input type="text" class="input-text JS_checkbox_disabled placeholder"
                               data-placeholder="输入景点" name="ticketViewSpot2"  <#if costIncludeOutsideVO.ticket!='include_ticket'|give_ticket!='Y'>disabled="disabled"</#if> 
                               value="${costIncludeOutsideVO.ticketViewSpot2!'输入景点'}"
                               data-validate="true" maxlength="100" required/>
                        为增送项目，赠送景点如不参加或不能游览，不退任何费用
                        </span>
                        </label>
                    </p>
                </div>

                <p>
                    <label>
                        <span class="JS_radio_switch_box">
                        <input type="radio" name="ticket"  value="ticket_other"  <#if costIncludeOutsideVO.ticket=='ticket_other'>checked="checked"</#if>    class="JS_radio_switch"/>
                        <input type="text" class="input-text gi-w400 JS_radio_disabled placeholder"   data-validate="true" required
                               data-placeholder="输入补充信息或自定义"  name="ticketOther"  value="${costIncludeOutsideVO.ticketOther!'输入补充信息或自定义'}"
                                maxlength="500" <#if costIncludeOutsideVO.ticket!='ticket_other'>disabled="disabled"</#if>  />
                        </span>
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
                        <label>
                            <input  name="dinner"  value="dinner_detail"  <#if costIncludeOutsideVO.dinner=='dinner_detail'>checked</#if>  class="input-text gi-w25 JS_radio_switch" type="radio"/>
                            含
                           <em> <input class="input-text gi-w25 JS_checkbox_disabled" type="text" 
                                    maxlength="10"  name="breackfaskCount" value="${costIncludeOutsideVO.breackfaskCount}" readonly="true"  /></em>
                            早
                            <em><input class="input-text gi-w25 JS_checkbox_disabled" type="text"  
                                    maxlength="10"  name="lunchCount" value="${costIncludeOutsideVO.lunchCount}" readonly="true"  /></em>
                            正（根据该行程明细中是否包含早餐中餐晚餐自动计算）
                        </label>
                    </p>

                    <p>
                        <span class="gi-ml20">
                            <label class="JS_checkbox_switch_box">
                                <input type="checkbox" class="JS_radio_disabled JS_checkbox_switch" name="dinnerSel" value="dinner_price" <#if dinner_price=='Y'>checked</#if>  <#if costIncludeOutsideVO.dinner==null|costIncludeOutsideVO.dinner!='dinner_detail'>disabled="disabled"</#if> />
                                <input class="input-text gi-w100 JS_checkbox_disabled placeholder" type="text" name="dinnerPri"
                                       data-placeholder="输入价格和币种"   data-validate="true" required maxlength="10"  value="${costIncludeOutsideVO.dinnerPri!'输入价格和币种'}"
                                       <#if costIncludeOutsideVO.dinner!='dinner_detail'|dinner_price!='Y'>disabled</#if>  />
                                正餐/人/餐
                            </label>
                        </span>
                    </p>

                    <p>
                        <span class="gi-ml20 JS_checkbox_switch_box">
                        <label>
                            <input type="checkbox" class="JS_radio_disabled JS_checkbox_switch" name="dinnerSel" value="dinner_food"  <#if dinner_food=='Y'>checked</#if>   <#if costIncludeOutsideVO.dinner==null|costIncludeOutsideVO.dinner!='dinner_detail'>disabled="disabled"</#if> />
                            正餐
                            <input class="input-text gi-w25 JS_checkbox_disabled" type="text" data-validate="true"
                                   required maxlength="10" <#if costIncludeOutsideVO.dinner!='dinner_detail'|dinner_food!='Y'>disabled</#if> name="dinnerPeo" value="${costIncludeOutsideVO.dinnerPeo}" />
                            人
                            <input class="input-text gi-w25 JS_checkbox_disabled" type="text" data-validate="true"
                                   required maxlength="10" <#if costIncludeOutsideVO.dinner!='dinner_detail'|dinner_food!='Y'>disabled</#if>  name="dinnerTab" value="${costIncludeOutsideVO.dinnerTab}"  />
                            桌
                            <input class="input-text gi-w25 JS_checkbox_disabled" type="text" data-validate="true"
                                   required maxlength="10" <#if costIncludeOutsideVO.dinner!='dinner_detail'|dinner_food!='Y'>disabled</#if>  name="dinnerFood" value="${costIncludeOutsideVO.dinnerFood}" />
                            菜
                            <input class="input-text gi-w25 JS_checkbox_disabled" type="text" data-validate="true"
                                   required maxlength="10" <#if costIncludeOutsideVO.dinner!='dinner_detail'|dinner_food!='Y'>disabled</#if>  name="dinnerSoup" value="${costIncludeOutsideVO.dinnerSoup}"  />
                            汤
                        </label>
                        </span>
                    </p>
                </div>

                <p>
                    <label>
                        <input type="radio" name="dinner" value="dinner_all_self" <#if costIncludeOutsideVO.dinner=='dinner_all_self'>checked</#if>  class="JS_radio_switch"/>
                        全程用餐自理
                    </label>
                </p>

                <p>
                    <label>
                        <input type="radio" name="dinner"  value="dinner_self"  <#if costIncludeOutsideVO.dinner=='dinner_self'>checked</#if>  class="JS_radio_switch"/>
                        酒店含早，正餐自理
                    </label>
                </p>

                <p>
                    <span class="JS_radio_switch_box">
                    <input type="radio" name="dinner"  value="dinner_other"  <#if costIncludeOutsideVO.dinner=='dinner_other'>checked</#if>  class="JS_radio_switch"/>
                    <input class="input-text gi-w250 JS_radio_disabled placeholder" data-placeholder="自定义" name="dinnerOther"  data-validate="true" required
                           type="text"  <#if costIncludeOutsideVO.dinner!='dinner_other'>disabled="disabled"</#if>  value="${costIncludeOutsideVO.dinnerOther!'自定义'}"/>
                    </span>
                </p>
            </dd>
        </dl>
        <div class="gi-hr"></div>

            <dl class="clearfix">
                <dt>

                    导游 ：
                </dt>
                <dd class="JS_radio_box">

                    <div class="JS_radio_switch_box">
                        <p>
                            <label>
                                <input class="JS_radio_switch" checked  type="radio" name="tourGuideSer" required
                                       data-validate="true"  value="local_tour_guide"  <#if costIncludeOutsideVO.tourGuideSer=='local_tour_guide'>checked</#if>  />
                                当地中文导游
                            </label>
                        </p>

                        <p>
                            <label>
                    <span class="gi-ml20">
                        <input class="JS_radio_disabled" type="checkbox" name="tourGuideSerCheck1" value="Y"  <#if costIncludeOutsideVO.tourGuideSerCheck1=='Y'>checked</#if>   <#if costIncludeOutsideVO.tourGuideSer??&costIncludeOutsideVO.tourGuideSer!='local_tour_guide'>disabled</#if> />
                        16人以上安排专职领队
                    </span>
                            </label>
                            <br>
                            <label>
                    <span class="gi-ml20">
                        <input class="JS_radio_disabled" type="checkbox" name="tourGuideSerCheck1" value="S"  <#if costIncludeOutsideVO.tourGuideSerCheck1=='S'>checked</#if>   <#if costIncludeOutsideVO.tourGuideSer??&costIncludeOutsideVO.tourGuideSer!='local_tour_guide'>disabled</#if> />
                        不论人数都安排专职领队
                    </span>
                            </label>
                        </p>
                    </div>

                    <div class="JS_radio_switch_box">
                        <p>
                            <label>
                                <input class="JS_radio_switch" type="radio" name="tourGuideSer"  value="local_guide_chin"  <#if costIncludeOutsideVO.tourGuideSer=='local_guide_chin'> checked </#if>  />
                                当地外语导游+中文翻译
                            </label>
                        </p>

                        <p>
                            <label>
                    <span class="gi-ml20">
                        <input class="JS_radio_disabled" <#if costIncludeOutsideVO.tourGuideSer!='local_guide_chin'>disabled</#if>  type="checkbox" name="tourGuideSerCheck2" value="Y" <#if costIncludeOutsideVO.tourGuideSerCheck2=='Y'>checked</#if> />
                        16人以上安排专职领队
                    </span>
                            </label>
                            <br>
                            <label>
                    <span class="gi-ml20">
                        <input class="JS_radio_disabled" <#if costIncludeOutsideVO.tourGuideSer!='local_guide_chin'>disabled</#if>  type="checkbox" name="tourGuideSerCheck2" value="S" <#if costIncludeOutsideVO.tourGuideSerCheck2=='S'>checked</#if> />
                        不论人数都安排专职领队
                    </span>
                            </label>
                        </p>
                    </div>

                    <div class="JS_radio_switch_box">
                        <p>
                            <label>
                                <input class="JS_radio_switch" type="radio" name="tourGuideSer" value="local_guide_lead"  <#if costIncludeOutsideVO.tourGuideSer=='local_guide_lead'>checked</#if>  />
                                全程专职领队兼境外导游讲解服务
                            </label>
                        </p>
                    </div>

                    <div class="JS_radio_switch_box">
                        <p>
                            <label>
                                <input class="JS_radio_switch"  type="radio" name="tourGuideSer" required
                                       data-validate="true"  value="guide_self"  <#if costIncludeOutsideVO.tourGuideSer=='guide_self'>checked</#if>  />
                                自定义
                            </label>
                        </p>

                        <p>
                            <label>
                    <span class="gi-ml20">
                        <textarea class="w35 textWidth" id="tourGuideSerOther" name="tourGuideSerOther" maxlength="200">${costIncludeOutsideVO.tourGuideSerOther}</textarea>
                    </span>
                            </label>
                        </p>
                    </div>

                </dd>
            </dl>
        
                <div class="gi-hr"></div>

       <dl class="clearfix">
            <dt>

                司机导游工资 ：
            </dt>
            <dd>
                <p>
                    <span class="JS_checkbox_switch_box">
                        <input type="checkbox"   name="driverTourGuideSalaryCheck" value="Y" class="JS_checkbox_switch"   <#if costIncludeOutsideVO.driverTourGuideSalaryCheck=='Y'>checked="checked"</#if>   />
                        包含司机导游工资（原服务费改为工资）约人民币<input type="text" class="gi-w75" name="driverTourGuideSalary" data-validate="true" digits="true" value="${costIncludeOutsideVO.driverTourGuideSalary}"/>元
                    </span>
                </p>
            </dd>
        </dl>
        
        <div class="gi-hr"></div>
        <dl class="clearfix">
            <dt>

                签证/签注：
            </dt>
            <dd>

                <div class="JS_visa_select_box">
                    <select class="JS_visa_select gi-w250" name="visa"  >
                        <option value="8"   <#if costIncludeOutsideVO.visa=='8'>selected="selected"</#if> >免签</option>
                        <option value="0"   <#if costIncludeOutsideVO.visa=='0'>selected="selected"</#if> >不含签证（境外）</option>
                        <option value="1" <#if costIncludeOutsideVO.visa=='1'>selected="selected"</#if> >不含签证且需游客办理落地签（境外）</option>
                        <option value="2" <#if costIncludeOutsideVO.visa=='2'>selected="selected"</#if>  >含团队旅游签证（境外）</option>
                        <option value="3" <#if costIncludeOutsideVO.visa=='3'>selected="selected"</#if>  >含个人旅游签证（境外）</option>
                        <option value="4" <#if costIncludeOutsideVO.visa=='4'>selected="selected"</#if>  >含个人或团队旅游签证（境外）</option>
                        <option value="5" <#if costIncludeOutsideVO.visa=='5'>selected="selected"</#if>  >不含港澳通行证（港澳）</option>
                        <option value="6" <#if costIncludeOutsideVO.visa=='6'>selected="selected"</#if> >不含入台证（台湾）</option>
                        <option value="7" <#if costIncludeOutsideVO.visa=='7'>selected="selected"</#if> >含入台证（台湾）</option>
                    </select>

                    <!--TODO-->
                    <span class="JS_visa_checkbox" <#if costIncludeOutsideVO.visa=='2' |costIncludeOutsideVO.visa=='3'|costIncludeOutsideVO.visa=='4'>style="display: block;"</#if>>
                        <input type="checkbox" name="visaDepend1"  value="Y" <#if costIncludeOutsideVO.visaDepend1=='Y' >checked</#if>  />视情况可能办理落地签证
                    </span>
                    
                    <div class="JS_visa_p" <#if costIncludeOutsideVO.visa=='1'>style="display: block;"</#if> >
                        <p>本产品不含落地签证费用 <input type="text" class="gi-w75 input-text"  name="visaPrice" value="${costIncludeOutsideVO.visaPrice}" maxlength="30"/>/人（请提前携带好相应数量的现金），
                        </p>

                        <p>并请各位贵宾自行携带护照原件、( <input type="text" class="gi-w100 input-text" name="visaMaterial" value="${costIncludeOutsideVO.visaMaterial}"
                                                   maxlength="30"/> )，落地签表格请在入境国海关领取；</p>
                    </div>
    </div>

            </dd>
        </dl>
        <div class="gi-hr"></div>
        <dl class="clearfix">
            <dt>

                保险 ：
            </dt>
            <dd class="JS_radio_box">

                <div class="JS_radio_switch_box">
                    <p>
                        <label>
                            <input type="radio" checked class="JS_radio_switch" name="insurance" value="insurace_give"  <#if costIncludeOutsideVO.insurance=='insurace_give'>checked</#if> />
                            含保险 <input type="text" class="input-text JS_radio_disabled gi-w75" data-validate="true"  <#if costIncludeOutsideVO.insurance??&costIncludeOutsideVO.insurance!='insurace_give'>disabled="disabled"</#if> 
                                       required digits="true" maxlength="20" name="insuranceAge1"  value="${costIncludeOutsideVO.insuranceAge1}" />
                            周岁以下客人报名，赠送境外旅游人身意外保险
                        </label>
                    </p>

                    <p class="gi-ml20">
                        <label>
                            <span class="JS_checkbox_switch_box">
                                <input type="checkbox" name="insuranceSel" value="Y" <#if costIncludeOutsideVO.insuranceSel=='Y'>checked</#if>  <#if costIncludeOutsideVO.insurance??&costIncludeOutsideVO.insurance!='insurace_give'>disabled</#if>   class="JS_checkbox_switch JS_radio_disabled"/>
                                <input type="text" class="input-text gi-w75 JS_checkbox_disabled"  name="insuranceAge2" 
                                       data-validate="true" required digits="true" <#if costIncludeOutsideVO.insurance!='insurace_give'|costIncludeOutsideVO.insuranceSel!='Y'>disabled="disabled"</#if> 
                                       maxlength="20"  value="${costIncludeOutsideVO.insuranceAge2}"  />
                                周岁以上客人建议自行购买符合自身身体状况及领馆要求的保险，并在送签前提供保险原件，也可由我公司代办
                                <input type="text" class="input-text gi-w75 JS_checkbox_disabled" name="insurancePrice"
                                       data-validate="true" required  <#if costIncludeOutsideVO.insurance!='insurace_give'|costIncludeOutsideVO.insuranceSel!='Y'>disabled="disabled"</#if> 
                                       maxlength="20" value="${costIncludeOutsideVO.insurancePrice!'100元'}"  />
                                ，具体请联系我公司
                            </span>
                        </label>
                    </p>
                </div>

                <p>
                    <label>
                    <span class="JS_radio_switch_box">
                        <input type="radio" class="JS_radio_switch" name="insurance" value="insurace_no"  <#if costIncludeOutsideVO.insurance=='insurace_no'>checked</#if>/>
                        不含保险
                    </span>
                    </label>
                </p>

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
                        <label>
                            <input type="radio"  class="JS_radio_switch JS_child_include_switch"
                                   name="chilPriStan" value="children_price"  <#if costIncludeOutsideVO.chilPriStan=='children_price'>checked</#if> />
                            创建儿童价标准
                        </label>
                        <span class="JS_child_error hide " style="color:red">至少选择一项</span>
                    </p>

                    <p>
                        <label>
                        <span class="gi-ml20 JS_checkbox_switch_box">
                            <input type="checkbox" name="chilPriStanSec" value="chil_age" <#if chil_age=='Y'>checked</#if>   <#if costIncludeOutsideVO.chilPriStan==null|costIncludeOutsideVO.chilPriStan!='children_price'>disabled</#if>  class="JS_radio_disabled JS_checkbox_switch JS_child_checkbox"/>
                            年龄；适用于
                            <input class="input-text gi-w50 JS_checkbox_disabled" type="text" data-validate="true"
                                   required  name="chilAge1" value="${costIncludeOutsideVO.chilAge1}"
                                   digits="true" maxlength="6" <#if costIncludeOutsideVO.chilPriStan!='children_price'|chil_age!='Y'>disabled</#if> />
                            至
                            <input class="input-text gi-w50 JS_checkbox_disabled" type="text" data-validate="true"
                                   required   name="chilAge2" value="${costIncludeOutsideVO.chilAge2}"
                                   digits="true" maxlength="6" <#if costIncludeOutsideVO.chilPriStan!='children_price'|chil_age!='Y'>disabled</#if> />
                            周岁（不含）的儿童
                        </span>
                        </label>
                    </p>

                    <p>
                        <label>
                        <span class="gi-ml20 JS_checkbox_switch_box">
                            <input type="checkbox" name="chilPriStanSec" value="chil_hei"  <#if chil_hei=='Y'>checked</#if> <#if costIncludeOutsideVO.chilPriStan==null|costIncludeOutsideVO.chilPriStan!='children_price'>disabled</#if>   class="JS_radio_disabled JS_checkbox_switch JS_child_checkbox"/>
                            身高；适用于
                            <input class="input-text gi-w50 JS_checkbox_disabled" type="text" data-validate="true"
                                   required  name="chilHei1"  value="${costIncludeOutsideVO.chilHei1}"
                                   digits="true" maxlength="6" <#if costIncludeOutsideVO.chilPriStan!='children_price'|chil_hei!='Y'>disabled</#if> />
                            至
                            <input class="input-text gi-w50 JS_checkbox_disabled" type="text" data-validate="true"
                                   required  name="chilHei2" value="${costIncludeOutsideVO.chilHei2}"
                                   digits="true" maxlength="6" <#if costIncludeOutsideVO.chilPriStan!='children_price'|chil_hei!='Y'>disabled</#if> />
                            cm（不含）以下的儿童。
                        </span>
                        </label>
                    </p>

                    <p>
                        <label>
                        <span class="gi-ml20 JS_checkbox_switch_box">
                            <input type="checkbox" name="chilPriStanSec"  value="chil_equ"  <#if chil_equ=='Y'>checked</#if>  <#if costIncludeOutsideVO.chilPriStan==null|costIncludeOutsideVO.chilPriStan!='children_price'>disabled</#if>  class="JS_radio_disabled JS_checkbox_switch JS_child_checkbox"/>
                            儿童价等于或高于成人价格（且不占床位）
                        </span>
                        </label>
                    </p>
                </div>

                <p class="JS_radio_switch_box">
                    <label>
                        <input type="radio" name="chilPriStan" value="equal_people"  <#if costIncludeOutsideVO.chilPriStan=='equal_people'>checked</#if>
                               class="JS_radio_switch JS_child_include_switch JS_child_include_switch_ctrl"/>
                        无儿童价。
                    </label>
                </p>

            </dd>
        </dl>

        <div class="JS_child_include_content"  <#if costIncludeOutsideVO.chilPriStan=='equal_people'>style="display: none;"</#if>>

            <div class="gi-hr"></div>

            <dl class="clearfix">
                <dt>
                    儿童价费用包含 ：
                </dt>
                <dd class="JS_radio_box">
                    <p class="JS_radio_switch_box">
                        <input type="radio"  class="JS_radio_switch" name="chilCostIncl" value="children_include" <#if costIncludeOutsideVO.chilCostIncl=='children_include'>checked</#if>  /> 选择包含
                        <label>
                        <span class="gi-mr20">
                            <input type="checkbox" class="JS_radio_disabled" name="chilCostInclCheck" value="CHILD_ROUND_T" <#if CHILD_ROUND_T=='Y'>checked</#if>   <#if costIncludeOutsideVO.chilCostIncl==null|costIncludeOutsideVO.chilCostIncl!='children_include'>disabled</#if>  />
                            往返飞机票
                        </span>
                        </label>
                        <label>
                        <span class="gi-mr20">
                            <input type="checkbox" class="JS_radio_disabled" name="chilCostInclCheck" value="CHILD_TICKET" <#if CHILD_TICKET=='Y'>checked</#if>   <#if costIncludeOutsideVO.chilCostIncl==null|costIncludeOutsideVO.chilCostIncl!='children_include'>disabled</#if>  />
                            门票
                        </span>
                        </label>
                        <label>
                        <span class="gi-mr20">
                            <input type="checkbox" class="JS_radio_disabled" name="chilCostInclCheck" value="CHILD_TOUR_GUIDE_SER"  <#if CHILD_TOUR_GUIDE_SER=='Y'>checked</#if>   <#if costIncludeOutsideVO.chilCostIncl==null|costIncludeOutsideVO.chilCostIncl!='children_include'>disabled</#if>  />
                            导游费用
                        </span>
                        </label>
                        <label>
                        <span class="gi-mr20">
                            <input type="checkbox" class="JS_radio_disabled" name="chilCostInclCheck" value="CHILD_VISA"  <#if CHILD_VISA=='Y'>checked</#if>   <#if costIncludeOutsideVO.chilCostIncl==null|costIncludeOutsideVO.chilCostIncl!='children_include'>disabled</#if>   />
                            签证
                        </span>
                        </label>
                        <label>
                        <span class="gi-mr20">
                            <input type="checkbox" class="JS_radio_disabled" name="chilCostInclCheck" value="CHILD_PACK"  <#if CHILD_PACK=='Y'>checked</#if>   <#if costIncludeOutsideVO.chilCostIncl==null|costIncludeOutsideVO.chilCostIncl!='children_include'>disabled</#if>  />
                            车位
                        </span>
                        </label>
                        <label>
                        <span class="gi-mr20">
                            <input type="checkbox" class="JS_radio_disabled" name="chilCostInclCheck" value="CHILD_DINNER"  <#if CHILD_DINNER=='Y'>checked</#if>   <#if costIncludeOutsideVO.chilCostIncl==null|costIncludeOutsideVO.chilCostIncl!='children_include'>disabled</#if>  />
                            用餐
                        </span>
                        </label>
                    </p>

                    <div class="JS_radio_switch_box clearfix">
                        <p class="gi-block">
                            <input name="chilCostIncl" value="children_self"  type="radio" class="JS_radio_switch"  <#if costIncludeOutsideVO.chilCostIncl=='children_self'>checked</#if> />
                            自定义儿童价包含
                        </p>
                        <textarea class="input-text gi-w500 gi-h150 JS_radio_disabled gi-ml15" name="chilOther"
                               <#if costIncludeOutsideVO.chilCostIncl!='children_self'>disabled="disabled"</#if> data-validate="true" maxlength="250" required>${costIncludeOutsideVO.chilOther}</textarea>
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
                        <div class="gi-abroad-other-checkbox">
                            <input type="checkbox" class="JS_checkbox_switch JS_abroad_other_judge_ctrl" name="costIncludeOther" value="Y" <#if costIncludeOutsideVO.costIncludeOther=='Y'>checked</#if> />
                  
                        <div class="gi-abroad-others" data-validate-extend="true" data-maxlength="200" data-tiplength="150">
                        <#if costIncludeOutsideVO.costIncludeOtherInput?? & costIncludeOutsideVO.costIncludeOtherInput?size &gt; 0>
                          <#list costIncludeOutsideVO.costIncludeOtherInput as outinput>
                            <div class="gi-abroad-other">
                                <input type="text" class="input-text gi-w500 JS_checkbox_disabled" data-validate="true"
                                       required maxlength="500" name="costIncludeOtherInput" <#if costIncludeOutsideVO.costIncludeOther!='Y'>disabled</#if> value="${outinput}"/>
                            
                             <#if outinput_index gt 0>
                                <a href="javascript:" class="gi-del gi-abroad-other-del">删除</a>
                             </#if>
                            </div>
                           </#list>
                        <#else>
                            <div class="gi-abroad-other">
                                <input type="text" class="input-text gi-w500 JS_checkbox_disabled" data-validate="true"
                                       required maxlength="500" name="costIncludeOtherInput" <#if costIncludeOutsideVO.costIncludeOther!='Y'>disabled</#if> />
                            </div>
                        </#if>
                            <div class="clearfix gi-w500 gi-abroad-other-add">
                                <a href="javascript:" class="fr JS_abroad_other_add_btn">增加一条</a>
                            </div>

                        </div>
                    </div>
                </div>
            </dd>
        </dl>
     
                    </div>
                     <!--费用包含 国外 结束-->

                    <p>
                                                                     费用不包含说明：
                    </p>
                    <!--费用不包含 国外 开始-->
                    <div class="gi-form JS_inner_not_include_abroad">
      

        <dl class="clearfix">
            <dt>
                单人房差：
            </dt>
            <dd class="JS_radio_box">
                <div class="JS_single_room_area">
                    <div class="JS_radio_switch_box">

                        <p>
                            <label>
                                <input type="radio"  name="singleDiff" <#if costExcludeOutsideVO.singleDiff=='single'>checked<#elseif costExcludeOutsideVO.singleDiff==null>checked</#if> value="single" class="JS_radio_switch"/>
                                单人房差（房差说明详见：预定须知－－出行警示及说明第1条）
                            </label>
                        </p>

                        <div class="JS_checkbox_switch_box clearfix gi-other-box gi-ml20">
                            <div class="fl"><input type="checkbox"  name="singleDiffSec" value="Y" <#if  costExcludeOutsideVO.singleDiffSec=='Y'>checked</#if>   <#if costExcludeOutsideVO.singleDiff??&costExcludeOutsideVO.singleDiff!='single'>disabled</#if> 
                                                   class="JS_checkbox_switch JS_radio_disabled JS_other_judge_ctrl"/>
                            </div>
                            <div class="fl JS_single_room_box">
                            <div class="JS_single_rooms" data-validate-extend="true" data-maxlength="500" data-tiplength="450">
                         <#if costExcludeOutsideVO.singleDiffType?? & costExcludeOutsideVO.singleDiffType?size &gt; 0>
                            <#list costExcludeOutsideVO.singleDiffType as singType>
                               <p class="JS_single_room">
                                <input type="text" class="input-text gi-w250 JS_checkbox_disabled placeholder"
                                       data-placeholder="输入房间类型或出游日期"   name="singleDiffType" <#if  costExcludeOutsideVO.singleDiffSec!='Y'>disabled="disabled"</#if> 
                                       data-validate="true" required maxlength="100" value="${singType}" />
                                房差
                                <input type="text" class="input-text gi-w75 JS_checkbox_disabled" <#if  costExcludeOutsideVO.singleDiffSec!='Y'>disabled="disabled"</#if> 
                                       name="singleDiffPrice" value="${costExcludeOutsideVO.singleDiffPrice[singType_index]}"
                                       data-validate="true" digits="true" required maxlength="10"/>
                                元/人
                             <#if singType_index gt 0>
                                 <a href="javascript:" class="gi-del JS_single_room_add_del">删除</a>
                             </#if>
                             </p>
                            </#list>
                         <#else>
                             <p class="JS_single_room">
                                <input type="text" class="input-text gi-w250 JS_checkbox_disabled placeholder"
                                       data-placeholder="输入房间类型或出游日期"  disabled="disabled"  name="singleDiffType"
                                       data-validate="true" required maxlength="100" value="输入房间类型或出游日期"/>
                                房差
                                <input type="text" class="input-text gi-w75 JS_checkbox_disabled"
                                       disabled="disabled"   name="singleDiffPrice"
                                       data-validate="true" digits="true" required maxlength="10"/>
                                元/人
                            </p>
                          </#if>
                                <div class="JS_single_rooms">
                                    <div class="JS_single_room_add">
                                        <a href="javascript:" class="JS_single_room_add_btn">增加一条</a>
                                    </div>
                                </div>
                            </div>
                            </div>
                        </div>
                    </div>
                </div>
                <p>
                            <label>
                                <input type="radio"  name="singleDiff" <#if costExcludeOutsideVO.singleDiff=='single_two'>checked</#if> value="single_two" class="JS_radio_switch"/>
                                本产品报价是按照2人入住1间房计算的价格，如您的订单产生单房，将安排您与其他客人拼房入住。要求享受单房，请在后续附加产品页面中选择单人房差选项；
                            </label>
                        </p>
                <p><label>
                        <span class="JS_radio_switch_box">
                            <input type="radio" name="singleDiff" value="single_self"  <#if  costExcludeOutsideVO.singleDiff=='single_self'>checked</#if>  class="JS_radio_switch"/>
                            <input type="text" class="input-text gi-w500 JS_radio_disabled placeholder" data-placeholder="自定义"
                                   <#if  costExcludeOutsideVO.singleDiff!='single_self'>disabled="disabled"</#if> data-validate="true"  name="singleDiffInput" value="${costExcludeOutsideVO.singleDiffInput!'自定义'}"  maxlength="500" required/>
                        </span>
                    </label></p>
            </dd>
        </dl>
        <dl class="clearfix JS_cost_exclude_visa">
            <dt>
        签证/签注：
            </dt>
            <dd>

           <div class="visa_outside_value">
            <#if costIncludeOutsideVO.visa==0>
           本产品不含个人旅游签证及申请签证中准备相关材料所需的制作、手续费，如所需的公证书、认证费 及其他额外费用，请在指定日期前自行办理好签证并递交我方；
            <#elseif costIncludeOutsideVO.visa==1>
         本产品不含落地签证费用${costIncludeOutsideVO.visaPrice}/人（请提前携带好相应数量的现金），并请各位贵宾自行携带护照原件、照片(${costIncludeOutsideVO.visaMaterial})，落地签表格请在入境国海关领取； 
            <#elseif costIncludeOutsideVO.visa==3|costIncludeOutsideVO.visa==4|costIncludeOutsideVO.visa==2>
            本产品申请签证中准备相关材料所需的制作、手续费，如所需的公证书、认证费 及其他额外费用；
            <#elseif costIncludeOutsideVO.visa==5>
           港澳通行证：本产品不含港澳通行证及相关签注的制作、手续费，请在指定日期前自行办理好相关证件并递交我方；
            <#elseif costIncludeOutsideVO.visa==6>
            入台手续：台湾通行证、签注和入台证请提前自行办理（赴台湾必须要有两证一签注：台湾通行证、签注和入台证），本产品不含台湾通行证、签注和入台证的制作、手续费，请在指定日期前自行办理好相关证件并递交我方          
            <#elseif costIncludeOutsideVO.visa==7>
            入台手续：台湾通行证和相关签注请提前自行办理（赴台湾必须要有两证一签注：台湾通行证、签注和入台证，通行证和签注必须要提前自行办理，入台证由我处办理），本产品不含台湾通行证和相关签注的制作、手续费，请在指定日期前自行办理好相关证件并递交我方
            </#if>
           </div>
            </dd>
        </dl>
                
        <dl class="clearfix">
        	<dt>
        		离境税：
        	</dt>
        	<div>
                <input type="checkbox" name="passengerDuty" value="Y" <#if costExcludeOutsideVO.passengerDuty=='Y'>checked</#if> />本产品不含返程机场离境税
            </div>
        <dl/>

        <dl class="clearfix">
            <dt>
                其他 ：
            </dt>
            <dd class="JS_checkbox_switch_box gi-other-box clearfix">
                <div class="gi-ni-abroad-other-checkbox fl gi-mr5">
                    <input type="checkbox"  name="costOther"  value="Y"  <#if  costExcludeOutsideVO.costOther=='Y'>checked</#if>    class="JS_checkbox_switch JS_ni_abroad_other_judge_ctrl"/>
                </div>
                <div class="gi-ni-abroad-others fl" data-validate-extend="true" data-maxlength="500" data-tiplength="450">
                <#if costExcludeOutsideVO.costOtherInput??& costExcludeOutsideVO.costOtherInput?size &gt; 0>
                  <#list  costExcludeOutsideVO.costOtherInput as outsideInput>
                     <div class="gi-ni-abroad-other">
                        <input type="text" class="input-text JS_checkbox_disabled placeholder gi-w450" 
                               data-placeholder="其他"   name="costOtherInput" <#if costExcludeOutsideVO.costOther!='Y'>disabled="disabled"</#if> 
                               data-validate="true" maxlength="500"  value="${outsideInput}" required/>
                       <#if outsideInput_index gt 0>
                         <a href="javascript:" class="gi-del gi-ni-abroad-other-del">删除</a>
                       </#if>
                     </div>
                  </#list>
                <#else>

                    <div class="gi-ni-abroad-other">
                        <input type="text" class="input-text JS_checkbox_disabled placeholder gi-w450" 
                               data-placeholder="其他" disabled="disabled" name="costOtherInput" value="其他"
                               data-validate="true" maxlength="500" required/>
                    </div>
                </#if>
                    <div class="gi-ni-abroad-other-add">
                        <a href="javascript:" class="gi-ni-abroad-other-add-btn">增加一条</a>
                    </div>
                </div>
            </dd>
        </dl>

                    </div>
                    <!--费用不包含 国外 结束-->

                    <div class="gi-ctrl clearfix">
                        <div class="fr">
                            <a class="gi-button gi-mr15 JS_button_save" href="javascript:;">保存</a>
                        </div>
                    </div>
 
            </div>
            <!--线路行程 结束-->
 </form>
        </div>
    </div>
</div>

<!--脚本模板使用 开始-->
<div class="JS_template">

</div>
<!--脚本模板使用 结束-->

<!--内层模板 开始-->
<div class="JS_template_inner">
    <!--单人房差-->
    <p class="JS_single_room">

        <input type="text" class="input-text gi-w250 JS_checkbox_disabled placeholder"
               data-placeholder="输入房间类型或出游日期"  name="singleDiffType" 
               data-validate="true" required maxlength="100"/>房差
        <input type="text" class="input-text gi-w75 JS_checkbox_disabled"  name="singleDiffPrice" 
               data-validate="true" digits="true" required maxlength="10"/>元/人
        <a href="javascript:" class="gi-del JS_single_room_add_del">删除</a>

    </p>
    <!--单人房差-->


   <!--其他 国外  开始-->
    <div class="gi-abroad-other">
        <input type="text" class="input-text gi-w500 JS_checkbox_disabled" value="" data-validate="true" required
               maxlength="500" name="costIncludeOtherInput" />
        <a href="javascript:" class="gi-del gi-abroad-other-del">删除</a>
    </div>
    <!--其他  国外结束--> 

    <!--住宿 国外 开始-->
    <div class="gi-abroad-stay">
        <input class="input-text JS_checkbox_disabled JS_radio_disabled placeholder" type="text" data-placeholder="输入目的地名称" value="输入目的地名称"
               data-validate="true" name="stayDest"
               required maxlength="10"/>
        <input class="input-text JS_checkbox_disabled JS_radio_disabled placeholder" type="text" data-placeholder="输入酒店名称" value="输入酒店名称"
               data-validate="true"  name="stayHotel" 
               required maxlength="90"/>
        <select class="JS_checkbox_disabled JS_radio_disabled"  name="staySel" >
            <option data-placeholder="双人标准间" selected="selected"  value="DOU_STA_ROOM" >双人标准间</option>
            <option data-placeholder="双人大床房"  value="TWIN_BED" >双人大床房</option>
            <option data-placeholder="双人标准间或大床房"  value="DOU_STA_OR_TWIN_BED" >双人标准间或大床房</option>
            <option data-placeholder="双人标准间或单人间"  value="DOU_STA_OR_SINGLE_ROOM" >双人标准间或单人间</option>
        </select>
        <a href="javascript:" class="gi-del gi-abroad-stay-del-btn">删除</a>
    </div>
    <!--住宿 国外 结束-->

    <!--不包含 国外其他 开始-->
    <div class="gi-ni-abroad-other">
        <input type="text" class="input-text JS_checkbox_disabled gi-w450" value=""  name="costOtherInput"
               data-validate="true" maxlength="500" required/>
        <a href="javascript:" class="gi-del gi-ni-abroad-other-del">删除</a>
    </div>
    <!--不包含国外 其他 结束-->

</div>
<!--内层模板 结束-->
<!--jQuery文件-->
<script src="http://pic.lvmama.com/min/index.php?f=/js/new_v/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>

<!--新增脚本文件-->
<script src="http://pic.lvmama.com/js/backstage/vst-group-input.js"></script>
<script src="http://pic.lvmama.com/js/backstage/vst-validate.js"></script>
<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>
<script  type="text/javascript" >
/**
 * jQuery validator 验证
 * name 不能重复
 */

	//页面关联则不可修改
	var $document = $(document);
     $(document).ready(function (){
	     if($("#noEditFlag").val() == "true"){
	     	$document.unbind("click");
	       	$("input[type='radio']").attr("disabled",true);
	       	$("input[type='checkbox']").attr("disabled",true);
	       	$("input").attr("readonly",true);
	       	$("select").prop("disabled", true);
//	       	$("div.gi-header a").removeAttr("href");
       	}

       	$("#toEdit").click(function () {
       	if($("#modelVersion").val() == "true"){
       		var url = "/vst_admin/dujia/group/route/cost/editProdRouteCost.do?lineRouteId=${lineRouteId}&productId=${productId}&productType=${productType}";
       	}else{
       		var url = "/vst_admin/prod/prodLineRoute/editprodroutecost.do?lineRouteId=${lineRouteId}&productId=${productId}";
       	}
      		var editDialog = new xDialog(url,{},{title:"编辑费用说明",iframe:true, width:1000, height:450});
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
                if($('input[name="chilPriStan"]:checked').val()=="equal_people"){
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

        if(isValidate){
            addRouteCostOut($this);
        }else {
            alertObj = $.saveAlert({
                "width": 250,
                "type": "danger",
                "text": "请完成必填填写项并确认填写正确"
            });
        }

    });

    //保存
    function addRouteCostOut($this) {

        //判断导游自定义
        if($("input:radio[name='tourGuideSer']:checked").val()!='guide_self'){
            $("#tourGuideSerOther").val("");
        }

        //判断当前保存状态
        if ($this.data("saving")) {
            return;
        }
        //改变保存按钮状态
        changeSaveButtonStatus(true);

      $.ajax({
            url: "/vst_admin/dujia/group/route/cost/saveCostOut.do",
            data: $(".costOutsideForm").serialize(),
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
                console.log("Call addRouteCostOut method occurs error");
                $.alert('网络服务异常, 请稍后重试');
            }
       });
    }

    //初始化签证效果
    var visaValue=$(".JS_visa_select").val() ;
    var visaContent="";
     if(visaValue==0){
       visaContent="本产品不含个人旅游签证及申请签证中准备相关材料所需的制作、手续费，如所需的公证书、认证费 及其他额外费用，请在指定日期前自行办理好签证并递交我方。";
     }else if(visaValue==1){
       visaContent=" 本产品不含落地签证费用${costIncludeOutsideVO.visaPrice}/人（请提前携带好相应数量的现金），并请各位贵宾自行携带护照原件、照片(${costIncludeOutsideVO.visaMaterial})，落地签表格请在入境国海关领取。";
     }else if (visaValue==3||visaValue==4||visaValue==2){
       visaContent=" 本产品申请签证中准备相关材料所需的制作、手续费，如所需的公证书、认证费 及其他额外费用。";
     }else if (visaValue==5){
       visaContent=" 港澳通行证：本产品不含港澳通行证及相关签注的制作、手续费，请在指定日期前自行办理好相关证件并递交我方。";
     }else if (visaValue==6){
       visaContent="入台手续：台湾通行证、签注和入台证请提前自行办理（赴台湾必须要有两证一签注：台湾通行证、签注和入台证），本产品不含台湾通行证、签注和入台证的制作、手续费，请在指定日期前自行办理好相关证件并递交我方。";
     }else if (visaValue==7){
       visaContent="入台手续：台湾通行证和相关签注请提前自行办理（赴台湾必须要有两证一签注：台湾通行证、签注和入台证，通行证和签注必须要提前自行办理，入台证由我处办理），本产品不含台湾通行证和相关签注的制作、手续费，请在指定日期前自行办理好相关证件并递交我方。";
     }
     $(".visa_outside_value").html(visaContent);


    //签证效果联动
    $document.on("change", ".JS_visa_select", function () {
        var $this = $(this);
        var selectValue = $this.val();
        var visaContent="";
        $(".JS_cost_exclude_visa").show();

        if(selectValue==0){
          visaContent="本产品不含个人旅游签证及申请签证中准备相关材料所需的制作、手续费，如所需的公证书、认证费 及其他额外费用，请在指定日期前自行办理好签证并递交我方。";
        }else if(selectValue==1){
          visaContent=" 本产品不含落地签证费用${costIncludeOutsideVO.visaPrice}/人（请提前携带好相应数量的现金），并请各位贵宾自行携带护照原件、照片(${costIncludeOutsideVO.visaMaterial})，落地签表格请在入境国海关领取。";
        }else if (selectValue==3||selectValue==4||selectValue==2){
          visaContent=" 本产品申请签证中准备相关材料所需的制作、手续费，如所需的公证书、认证费 及其他额外费用。";
        }else if (selectValue==5){
          visaContent=" 港澳通行证：本产品不含港澳通行证及相关签注的制作、手续费，请在指定日期前自行办理好相关证件并递交我方。";
        }else if (selectValue==6){
          visaContent="入台手续：台湾通行证、签注和入台证请提前自行办理（赴台湾必须要有两证一签注：台湾通行证、签注和入台证），本产品不含台湾通行证、签注和入台证的制作、手续费，请在指定日期前自行办理好相关证件并递交我方。";
        }else if (selectValue==7){
          visaContent="入台手续：台湾通行证和相关签注请提前自行办理（赴台湾必须要有两证一签注：台湾通行证、签注和入台证，通行证和签注必须要提前自行办理，入台证由我处办理），本产品不含台湾通行证和相关签注的制作、手续费，请在指定日期前自行办理好相关证件并递交我方。";
        }else if (selectValue==8){
            $(".JS_cost_exclude_visa").hide();
        }
        $(".visa_outside_value").html(visaContent);
     });

    //改变 保存按钮的状态（isLoading：true 保存前 false 保存结束后）
    function changeSaveButtonStatus(isLoading) {
        var $form = $(".costOutsideForm");
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
	$(".JS_visa_select").trigger("change");

	function isRemoveSaveButton(){
		if($("#isView",parent.document).val()=='Y' || $("#isView",parent.top.document).val()=='Y'){
			//移除保存,增加一条，删除按钮
			$("a[class*=JS_button_save],a[class*=gi-abroad-stay-add-btn],a[class*=gi-abroad-stay-del-btn],a[class*=gi-abroad-other-del],a[class*=JS_abroad_other_add_btn],a[class*=JS_single_room_add_btn],a[class*=JS_single_room_add_del],a[class*=gi-ni-abroad-other-add-btn],a[class*=gi-ni-abroad-other-del]").remove();
		}
	}

    $("input[name='tourGuideSerCheck1']").click(function(){
        if($("input[name='tourGuideSerCheck1']:checked").length>1){
            $(this).parents("label").siblings().find("input").removeAttr("checked");
        }
    });

    $("input[name='tourGuideSerCheck2']").click(function(){
        if($("input[name='tourGuideSerCheck2']:checked").length>1){
            $(this).parents("label").siblings().find("input").removeAttr("checked");
        }
    });
</script>

<script>

    //判断导游自定义
    if($("input:radio[name='tourGuideSer']:checked").val()!='guide_self'){
        $("#tourGuideSerOther").val("");
    }

    $("input[name='tourGuideSer']").change(function(){

        //判断导游自定义
        if($("input:radio[name='tourGuideSer']:checked").val()!='guide_self'){
            $("#tourGuideSerOther").val("");
        }
    });


</script>
</body>
</html>
