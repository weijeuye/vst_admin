<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>产品条款国内</title>

    <link href="/vst_admin/css/ui-common.css" rel="stylesheet"/>
    <link href="/vst_admin/css/ui-components.css" rel="stylesheet"/>
    <link href="/vst_admin/css/iframe.css" rel="stylesheet"/>
    <link href="/vst_admin/css/dialog.css" rel="stylesheet"/>

    <!--新增样式表-->
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/vst-line-travel.css"/>
    <style>
    	.gi-otherTravel-others { float:left}
		.gi-otherTravel { margin-bottom:10px;}
    </style>

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

             <form class="productSuggInnerForm" action="#" method="post">
                <!--出行警示 开始-->
                <p class="pdi-title">出行警示及说明：</p>
                <div class="group-input gi-cxjs">
                    <div class="gi-form gi-cxjs-form">
                        <#-- 存放隐藏域 DIV -->
                        <div class="travelAlertInnerHiddenDiv" style="display:none;">
                            <input type="hidden" name="travleProdDescId" value="${travleProductDescription.prodDescId}"/>
                            <input type="hidden" name="categoryId" value="${categoryId}"/>
                            <input type="hidden" name="productId" value="${prodProduct.productId}"/>
                            <input type="hidden" name="productType" value="${prodProduct.productType}"/>
                        </div>

                        <dl class="clearfix">
                            <dt>
                                预定限制：
                            </dt>
                            <dd class="gi-checkbox-group js-checkbox-group">
                            	<div class="clearfix">
                            	<label>证件(国籍)限制：</label>
                            	</div>
                            	
                            	<div class="clearfix">
                                <label>
                                	<#assign is_certificates_item_001_selected = (travelAlertInnerSelfTourVO.certificates?? && travelAlertInnerSelfTourVO.certificates?seq_contains("001"))?string('Y','N') />
                                    <input type="checkbox" name="certificates" value="001" <#if is_certificates_item_001_selected == 'Y'>checked="checked"</#if>/>
                                    <em>本产品不接受
                                    	<input type="text" name="certificatesTxt1" value="${travelAlertInnerSelfTourVO.certificatesTxt1!''}" class="gi-w50 js-input" style="width:200px;"  <#if is_certificates_item_001_selected == 'N'>disabled</#if>  data-validate="true"  required  placeholder="可在这里注明具体证件及国籍" />
                                    	客人预订，敬请谅解！</em>
                                </label>
                                </div>
                                
                            	<div class="clearfix">
                                <label>
                                	<#assign is_certificates_item_002_selected = (travelAlertInnerSelfTourVO.certificates?? && travelAlertInnerSelfTourVO.certificates?seq_contains("002"))?string('Y','N') />
                                    <input type="checkbox" name="certificates" value="002" <#if is_certificates_item_002_selected == 'Y'>checked="checked"</#if>/>
                                    <em>本产品适用于持
                                    	<input type="text" name="certificatesTxt2" value="${travelAlertInnerSelfTourVO.certificatesTxt2!''}" class="gi-w50 js-input" style="width:200px;" <#if is_certificates_item_002_selected == 'N'>disabled</#if>  data-validate="true" required  placeholder="可在这里注明具体证件及国籍" />
                                    	客人预订。</em>
                                </label>
                                </div>
                                
                            	<div class="clearfix">
                                <label>
                                    <input type="checkbox" name="certificates" value="003" <#if travelAlertInnerSelfTourVO.certificates?? && travelAlertInnerSelfTourVO.certificates?seq_contains("003")>checked="checked"</#if>/>
                                    <em>本产品不接受非大陆籍客人预订，敬请谅解！</em>
                                </label>
                                </div>
                                
                            	<div class="clearfix">
                                <label>
                                    <input type="checkbox" name="certificates" value="004" <#if travelAlertInnerSelfTourVO.certificates?? && travelAlertInnerSelfTourVO.certificates?seq_contains("004")>checked="checked"</#if>/>
                                    <em>我司为您提供的是火车实名制客票，故请在提交订单时务必提供完整的身份信息（目前仅接受中华人民共和国居民二代身份证、港澳居民来往内地通行证、台湾居民来往大陆通行证和护照四种证件）。火车票不保证连号，敬请谅解！</em>
                                </label>
                                </div>
                                
                            	<div class="clearfix">
                                <label>
                                    <input type="checkbox" name="certificates" value="005" <#if travelAlertInnerSelfTourVO.certificates?? && travelAlertInnerSelfTourVO.certificates?seq_contains("005")>checked="checked"</#if>/>
                                    <em>外宾不可进入！港澳台胞不可进入！通行证由驴妈妈代为办理，中国公民提供2代身份证，儿童需要提供户口本。</em>
                                </label>
                                </div>
                                
                            	<div class="clearfix">
                                <label>
                                    <input type="checkbox" name="certificates" value="006" <#if travelAlertInnerSelfTourVO.certificates?? && travelAlertInnerSelfTourVO.certificates?seq_contains("006")>checked="checked"</#if>/>
                                    <em>台胞及外宾不可进入！通行证由驴妈妈代为办理，中国公民提供2代身份证，儿童需要提供户口本。</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                            	<label>年龄限制：</label>
                            	</div>
                                
                                <div class="clearfix">
                                <label>
                                    <#assign is_age_limit_item_001_selected = (travelAlertInnerSelfTourVO.ageLimit?? && travelAlertInnerSelfTourVO.ageLimit?seq_contains("001"))?string('Y','N') />
                                    <input type="checkbox" name="ageLimit" value="001" <#if is_age_limit_item_001_selected == 'Y'>checked="checked"</#if> class="JS_checkbox_switch"/>
                                    <em>
                                        <input type="text" name="ageLimitAge1" value="${travelAlertInnerSelfTourVO.ageLimitAge1!''}" class="gi-w50 js-input" <#if is_age_limit_item_001_selected == 'N'>disabled</#if> maxlength="4" data-validate="true" required digits="true"/>
                                      	岁以下未成年人需要至少一名家长或成年旅客全程陪同。
                                    </em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <#assign is_age_limit_item_002_selected = (travelAlertInnerSelfTourVO.ageLimit?? && travelAlertInnerSelfTourVO.ageLimit?seq_contains("002"))?string('Y','N') />
                                    <input type="checkbox" name="ageLimit" value="002" <#if is_age_limit_item_002_selected == 'Y'>checked="checked"</#if> class="JS_checkbox_switch"/>
                                    <em>
                                        <input type="text" name="ageLimitAge2" value="${travelAlertInnerSelfTourVO.ageLimitAge2!''}" class="gi-w50 js-input" <#if is_age_limit_item_002_selected == 'N'>disabled</#if> maxlength="4" data-validate="true" required digits="true"/>
                                      	周岁（含）以上老年人预订出行需确保身体健康适宜旅游，并有
                                      	<input type="text" name="ageLimitAge3" value="${travelAlertInnerSelfTourVO.ageLimitAge3!''}" class="gi-w50 js-input" <#if is_age_limit_item_002_selected == 'N'>disabled</#if> maxlength="4" data-validate="true" required digits="true"/>
                                      	周岁以上家属或朋友（因服务能力所限无法接待及限制接待的人除外）全程陪同出行。
                                    </em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <#assign is_age_limit_item_003_selected = (travelAlertInnerSelfTourVO.ageLimit?? && travelAlertInnerSelfTourVO.ageLimit?seq_contains("003"))?string('Y','N') />
                                    <input type="checkbox" name="ageLimit" value="003" <#if is_age_limit_item_003_selected == 'Y'>checked="checked"</#if> class="JS_checkbox_switch"/>
                                    <em>儿童：身高0.8米（含）以上必须占座，票价与成人同价；身高不足0.8米（不含），且无需占座，无需提交人数。 </em>
                                </label>
                                </div>

                            </dd>
                        </dl>
                        
                        
                        <dl class="clearfix">
                            <dt>
                             	  说明&须知
                            </dt>
                            <dd class="gi-checkbox-group js-checkbox-group">
                            	 <div class="clearfix">
                                <label>预订说明：</label>
                                </div>
                                
                            	<div class="clearfix">
                                <label>
                                    <#assign is_book_infor_item_001_selected = (travelAlertInnerSelfTourVO.bookInfor?? && travelAlertInnerSelfTourVO.bookInfor?seq_contains("001"))?string('Y','N') />
                                    <input type="checkbox" name="bookInfor" value="001" <#if is_book_infor_item_001_selected == 'Y'>checked="checked"</#if> class="JS_checkbox_switch"/>
                                    <em>请您在预订时务必提供准确、完整的信息（姓名、性别、证件号码、国籍、联系方式、是否成人或儿童等），以免产生预订错误，影响出行。如因客人提供错误个人信息而造成损失，我社不承担任何责任。  </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="bookInfor" value="002" <#if travelAlertInnerSelfTourVO.bookInfor?? && travelAlertInnerSelfTourVO.bookInfor?seq_contains("002")>checked="checked"</#if>/>
                                    <em>儿童门票不接受预订，请自行在景区购买。</em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="bookInfor" value="003" <#if travelAlertInnerSelfTourVO.bookInfor?? && travelAlertInnerSelfTourVO.bookInfor?seq_contains("003")>checked="checked"</#if>/>
                                    <em>铁道部规定所有火车票均需通过12306网站上进行身份核验，通过核验后方可购票。驴妈妈特别提醒您注意，出行人应确保其提供的身份证号及姓名真实有效且能够通过核验，若造成核验无法通过的，驴妈妈除全额退还订单费用外，不再承担其他责任；如因出行人提供虚假信息导致无法通过核验的，因此产生的损失应由出行人承担。</em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="bookInfor" value="004" <#if travelAlertInnerSelfTourVO.bookInfor?? && travelAlertInnerSelfTourVO.bookInfor?seq_contains("004")>checked="checked"</#if>/>
                                    <em>我司为您提供的是火车票实名制客票，故请在提交订单时务必提供完整的身份信息（目前仅接受中华人民共和国居民二代身份证、港澳居民来往内地通行证、台湾居民来往大陆通行证和护照四种证件）。</em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="bookInfor" value="005" <#if travelAlertInnerSelfTourVO.bookInfor?? && travelAlertInnerSelfTourVO.bookInfor?seq_contains("005")>checked="checked"</#if>/>
                                    <em>铁道部规定实名制车票办理退票和签转时，必须保证票（火车票）证（身份证原件）一致方可办理。故订单成交后，如需退订，请按以下条款执行:<br>
										&nbsp;1）如果电子客票未换取纸制票，请及时联系我司，由我司为您办理火车票退改签手续，同时根据预订须知条款收取相应的业务损失费用。<br>
										&nbsp;2）如果电子客票已经换取纸制票，请您自行前往火车站售票窗口办理火车票退改签手续，并将退票凭证原件或复印件提供给我司，我司将在核实退票款到帐后的7-14个工作日内将火车票退票款退还给您，同时根据预订须知条款收取相应的业务损失费用。<br>
										&nbsp;3）如您收到了驴妈妈或驴妈妈合作商寄送给您的纸质车票，请您自行前往火车站售票窗口办理火车票退改签手续，我们将在订单退订金额中扣除火车票相应费用。具体退订规则参考铁路部门相关退票规定。
										</em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label>
                                 	<#assign is_book_infor_item_006_selected = (travelAlertInnerSelfTourVO.bookInfor?? && travelAlertInnerSelfTourVO.bookInfor?seq_contains("006"))?string('Y','N') />
                                    <input type="checkbox" name="bookInfor" value="006" <#if is_book_infor_item_006_selected == 'Y'>checked="checked"</#if>/>
                                    <em>请您在下订单时，在附加信息中提供
                                    	<input type="text" name="bookArea" value="${travelAlertInnerSelfTourVO.bookArea!''}" class="gi-w50 js-input" <#if is_book_infor_item_006_selected == 'N'>disabled</#if>  data-validate="true" required/>
                                     	信息，以便工作人员安排您预订的项目。
                                    </em>
                                </label>
                                </div>
                                
                                 <div class="clearfix">
                                <label>出行须知： </label>
                                </div>
                                
                            	<div class="clearfix">
                                <label>
                                	<#assign is_travel_notes_item_001_selected = (travelAlertInnerSelfTourVO.travelNotes?? && travelAlertInnerSelfTourVO.travelNotes?seq_contains("001"))?string('Y','N') />
                                    <input type="checkbox" name="travelNotes" value="001" <#if is_travel_notes_item_001_selected == 'Y'>checked="checked"</#if>/>
                                    <em>最晚在出行前1天，导游或我司工作人员会短信联系您，告知导游、司机联系方式及其他具体出行事宜，请保持手机畅通。如您在
                                    	<input type="text" name="travelNotesDay1" value="${travelAlertInnerSelfTourVO.travelNotesDay1!''}" class="gi-w50 js-input" <#if is_travel_notes_item_001_selected == 'N'>disabled</#if>  data-validate="true" required/>
                                     	之前仍未接到通知，请速来电咨询
                                    	<input type="text" name="travelNotesTxt1" value="${travelAlertInnerSelfTourVO.travelNotesTxt1!''}" class="gi-w50 js-input" style="width:200px;" <#if is_travel_notes_item_001_selected == 'N'>disabled</#if>  data-validate="true" required/>
                                    	。
                                    </em>
                                </label>
                                </div>
                                
								<div class="clearfix">
                                <label>
                                    <input type="checkbox" name="travelNotes" value="002" <#if travelAlertInnerSelfTourVO.travelNotes?? && travelAlertInnerSelfTourVO.travelNotes?seq_contains("002")>checked="checked"</#if>/>
                                    <em>请凭驴妈妈订单号和出行人姓名至指定地点准时上车，根据导游通知的座位号对号入座。私自携带儿童产生的超载罚款及其他责任由游客承担。</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                 <label>
                                 	<#assign is_travel_notes_item_003_selected = (travelAlertInnerSelfTourVO.travelNotes?? && travelAlertInnerSelfTourVO.travelNotes?seq_contains("003"))?string('Y','N') />
                                    <input type="checkbox" name="travelNotes" value="003" <#if is_travel_notes_item_003_selected == 'Y'>checked="checked"</#if>/>
                                    <em>我处将按实际人数安排合适车型，并安排巴士座位，上车请对号入座。车牌号、座位号以及导游联系方式将在出行前一天
                                    	<input type="text" name="travelNotesHour3_1" value="${travelAlertInnerSelfTourVO.travelNotesHour3_1!''}" class="gi-w50 js-input" <#if is_travel_notes_item_003_selected == 'N'>disabled</#if>  data-validate="true" required/>
                                     	前以短信形式通知，敬请留意；如果您在出行前一天
                                    	<input type="text" name="travelNotesHour3_2" value="${travelAlertInnerSelfTourVO.travelNotesHour3_2!''}" class="gi-w50 js-input" <#if is_travel_notes_item_003_selected == 'N'>disabled</#if>  data-validate="true" required/>
                                    	前还没有收到短信，请速来电咨询。
                                    </em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="travelNotes" value="004" <#if travelAlertInnerSelfTourVO.travelNotes?? && travelAlertInnerSelfTourVO.travelNotes?seq_contains("004")>checked="checked"</#if>/>
                                    <em>在旅游旺季或者其他一些特殊情况下，为了保证您的行程游览不受影响，行程的出发时间可能会提早（具体出发时间以导游通知为准），导致您不能正常享用酒店早餐。我们建议您跟酒店协调打包早餐或者自备早餐，敬请谅解。</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="travelNotes" value="005" <#if travelAlertInnerSelfTourVO.travelNotes?? && travelAlertInnerSelfTourVO.travelNotes?seq_contains("005")>checked="checked"</#if>/>
                                    <em>出行期间请随身携带本人的有效身份证原件，未满16周岁者请携带户口本原件；超过16周岁的游客若没有办理身份证，请在户口所在地开出相关身份证明，以免影响登机或酒店入住。出行前请务必检查自己证件的有效期。</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="travelNotes" value="006" <#if travelAlertInnerSelfTourVO.travelNotes?? && travelAlertInnerSelfTourVO.travelNotes?seq_contains("006")>checked="checked"</#if>/>
                                    <em>使用同行成年人或儿童本人有效身份证件信息购买儿童票的，须提供该同行成年人或儿童本人的有效身份证件原件和订单号码；如儿童未办理居民身份证，而使用居民户口簿所载儿童的身份证号码购买儿童票的，可将居民户口簿原件或车站铁路公安制证口开具的临时身份证明作为有效身份证件，凭以换票。</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="travelNotes" value="007" <#if travelAlertInnerSelfTourVO.travelNotes?? && travelAlertInnerSelfTourVO.travelNotes?seq_contains("007")>checked="checked"</#if>/>
                                    <em>凡电子客票如无法正常换取纸质客票时，请持电子客票号及证件到值班经理窗口办理换票。</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="travelNotes" value="008" <#if travelAlertInnerSelfTourVO.travelNotes?? && travelAlertInnerSelfTourVO.travelNotes?seq_contains("008")>checked="checked"</#if>/>
                                    <em>购票时使用有效二代居民身份证信息的，可以凭二代居民身份证原件，直接通过车站自动检票机办理进、出站检票手续；以下几种情况需要凭购票时所使用的有效身份证件原件和预订成功后收到的电子客票订单号至车站售票窗口或者铁路客票代售点（需收取5元/张手续费）换取普通纸制车票：<br>
                                    	&nbsp;1）使用二代居民身份证以外的其他有效身份证件购票的。<br>
										&nbsp;2）使用同行成年人有效身份证件信息购买儿童票的。<br>
										&nbsp;3）乘车站或下车站不具备二代居民身份证检票条件的。<br>
										&nbsp;4）二代居民身份证无法在自动检票机上识读的。<br>
										&nbsp;5）需车票报销凭证的。<br>
										&nbsp;6）乘车人按所购车票的乘车日期、车次在中途站进站乘车的。
									</em>
                                </label>
                                </div>
                                 
                                <div class="clearfix">
                                <label>
                                	<#assign is_travel_notes_item_009_selected = (travelAlertInnerSelfTourVO.travelNotes?? && travelAlertInnerSelfTourVO.travelNotes?seq_contains("009"))?string('Y','N') />
                                    <input type="checkbox" name="travelNotes" value="009" <#if is_travel_notes_item_009_selected == 'Y'>checked="checked"</#if> />
                                    <em>为了不耽误您的行程，请您在航班起飞前
                                    <input type="text" name="travelNotesHour9" value="${travelAlertInnerSelfTourVO.travelNotesHour9!''}" class="gi-w50 js-input" <#if is_travel_notes_item_009_selected == 'N'>disabled</#if> maxlength="10" data-validate="true" required/>
                            		        分钟到达机场办理登机手续。
                            		</em>
                                </label>
                                </div>
                                 
                                <div class="clearfix">
                                <label>
                                	<#assign is_travel_notes_item_010_selected = (travelAlertInnerSelfTourVO.travelNotes?? && travelAlertInnerSelfTourVO.travelNotes?seq_contains("010"))?string('Y','N') />
                                    <input type="checkbox" name="travelNotes" value="010" <#if is_travel_notes_item_010_selected == 'Y'>checked="checked"</#if>/>
                                    <em>行程中所包含的
                                    <input type="text" name="travelNotesTxt10" value="${travelAlertInnerSelfTourVO.travelNotesTxt10!''}" class="gi-w50 js-input" style="width:200px;" <#if is_travel_notes_item_010_selected == 'N'>disabled</#if>  data-validate="true" required/>
                                  	  如因天气或海浪原因无法上岛，可与其他景点互换，也可按成本退还客人。因客流集中上岛人数较多，团队上岛可能会排队等候，因等待而延误岛上游览时间，游客需谅解并配合。因排队引发的投诉旅行社将不予受理。
                                    </em>
                                </label>
                                </div>
                                 
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="travelNotes" value="011" <#if travelAlertInnerSelfTourVO.travelNotes?? && travelAlertInnerSelfTourVO.travelNotes?seq_contains("011")>checked="checked"</#if>/>
                                    <em>目的地可能有部分私人经营的娱乐、消费场所，此类组织多数无合法经营资质，存在各种隐患。为了您的安全和健康考虑，驴妈妈提醒您，谨慎消费。</em>
                                </label>
                                </div>
                                 
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="travelNotes" value="012" <#if travelAlertInnerSelfTourVO.travelNotes?? && travelAlertInnerSelfTourVO.travelNotes?seq_contains("012")>checked="checked"</#if>/>
                                    <em>在旅游行程中，个别景点景区、餐厅、休息区等场所存在商场等购物场所，上述场所非旅行社安排的指定购物场所。驴妈妈提醒旅游者根据自身需要，理性消费并索要必要票据。如产生消费争议，请自行承担相关责任义务，由此带来的不便，敬请谅解！</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="travelNotes" value="013" <#if travelAlertInnerSelfTourVO.travelNotes?? && travelAlertInnerSelfTourVO.travelNotes?seq_contains("013")>checked="checked"</#if>/>
                                    <em>为确保锂电池的安全运输，避免发生不安全事件，我们友情提醒您，民航局将对旅客携带锂电池乘机进行严格检查。</em>
                                </label>
                                </div>
                                 
                                <div class="clearfix">
                                <label>航班变动声明: </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="flightDesc" value="001" <#if travelAlertInnerSelfTourVO.flightDesc?? && travelAlertInnerSelfTourVO.flightDesc?seq_contains("001")>checked="checked"</#if>/>
                                    <em>如因意外事件及不可抗力，包括但不限于，航空公司运力调配、航权审核、机场临时关闭、天气原因、航空管制等，导致航班取消或延期的，旅行社将尽最大努力协助您办理变更事宜，如产生差价，多退少补。</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>产品说明: </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="productDesc" value="001" <#if travelAlertInnerSelfTourVO.productDesc?? && travelAlertInnerSelfTourVO.productDesc?seq_contains("001")>checked="checked"</#if>/>
                                    <em>如遇路况原因等突发情况需要变更各集合时间的，届时以导游或随车人员公布为准。</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="productDesc" value="002" <#if travelAlertInnerSelfTourVO.productDesc?? && travelAlertInnerSelfTourVO.productDesc?seq_contains("002")>checked="checked"</#if>/>
                                    <em>行程中的赠送项目，如因交通、天气等不可抗因素导致不能赠送的、或因您个人原因不能参观的，费用不退，敬请谅解。</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                	<#assign is_product_desc_item_003_selected = (travelAlertInnerSelfTourVO.productDesc?? && travelAlertInnerSelfTourVO.productDesc?seq_contains("003"))?string('Y','N') />
                                    <input type="checkbox" name="productDesc" value="003" <#if is_product_desc_item_003_selected =='Y'>checked="checked"</#if>/>
                                    <em>本行程免费接送地点：
                                    <input type="text" name="productSend" value="${travelAlertInnerSelfTourVO.productSend!''}" class="gi-w50 js-input" style="width:500px;"   <#if is_product_desc_item_003_selected == 'N'>disabled</#if>  data-validate="true" required/>
                                    </em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="productDesc" value="004" <#if travelAlertInnerSelfTourVO.productDesc?? && travelAlertInnerSelfTourVO.productDesc?seq_contains("004")>checked="checked"</#if>/>
                                    <em>团队行程中，非自由活动期间，如您选择中途离团，未完成部分将被视为您自行放弃，仅退还未产生的门票及用餐费用。</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                	<#assign is_product_desc_item_005_selected = (travelAlertInnerSelfTourVO.productDesc?? && travelAlertInnerSelfTourVO.productDesc?seq_contains("005"))?string('Y','N') />
                                    <input type="checkbox" name="productDesc" value="005" <#if is_product_desc_item_005_selected =='Y'>checked="checked"</#if>/>
                                    <em>持老年证、军官证、学生证等优惠证件的游客可享受景区门票优惠政策，具体以出行当日景区公布政策为准。请具备条件的游客携带好相关证件，届时由导游统一安排，按打包行程中客人已享的优惠价格，现场退还差价
                                    <input type="text" name="productDiff" value="${travelAlertInnerSelfTourVO.productDiff!''}" class="gi-w50 js-input"  <#if is_product_desc_item_005_selected == 'N'>disabled</#if>  data-validate="true" required/>
                                    </em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="productDesc" value="006" <#if travelAlertInnerSelfTourVO.productDesc?? && travelAlertInnerSelfTourVO.productDesc?seq_contains("006")>checked="checked"</#if>/>
                                    <em>本产品门票为团队优惠联票，持老年证、军官证、学生证等优惠证件的人群均不再享受门票优惠。</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="productDesc" value="007" <#if travelAlertInnerSelfTourVO.productDesc?? && travelAlertInnerSelfTourVO.productDesc?seq_contains("007")>checked="checked"</#if>/>
                                    <em>团队行程火车票无法指定铺位、座席，均为随机分配，不能保证连号。车票按实际出票为准，不补退差价。如对铺位、席位有特殊要求，请您上车后自行与其他旅客或乘务人员协调解决，敬请谅解。</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>其他: </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="otherTextTag" value="001" <#if travelAlertInnerSelfTourVO.otherTextTag?? && travelAlertInnerSelfTourVO.otherTextTag?seq_contains("001")>checked="checked"</#if>/>
                                    <em>持军官证、老年证、学生证的游客可享受景区门票优惠政策，具体以出行当日景区公布政策为准，请具备条件的游客携带好相关证件并提前交给导游，届时由导游统一安排，按打包行程中客人已享的优惠价格，现场退还差价。</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="otherTextTag" value="002" <#if travelAlertInnerSelfTourVO.otherTextTag?? && travelAlertInnerSelfTourVO.otherTextTag?seq_contains("002")>checked="checked"</#if>/>
                                    <em>持各类证件游客不再享受景区门票优惠政策。</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="otherTextTag" value="003" <#if travelAlertInnerSelfTourVO.otherTextTag?? && travelAlertInnerSelfTourVO.otherTextTag?seq_contains("003")>checked="checked"</#if>/>
                                    <em>儿童门票不接受预订，请自行在景区购买。</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="otherTextTag" value="004" <#if travelAlertInnerSelfTourVO.otherTextTag?? && travelAlertInnerSelfTourVO.otherTextTag?seq_contains("004")>checked="checked"</#if>/>
                                    <em>根据《铁路旅客运输规程》及《铁路旅客运输办理细则》等有关规定，卧铺火车票无法指定铺位，随机分配上、中、下铺。车票按实际出票铺位为准，不补退差价。如对铺位、席位有特殊要求，请您上车后自行与其他旅客或乘务人员协调解决，敬请谅解。</em>
                                </label>
                                </div>
                                
                                <div class="clearfix">
                                 <div class="JS_checkbox_switch_box gi-otherTravel-box">
                                	<#assign is_other_text_tag_item_other_selected = (travelAlertInnerSelfTourVO.otherTextTag?? && travelAlertInnerSelfTourVO.otherTextTag?seq_contains("000"))?string('Y','N') />
                                	
                                    <div class="gi-other-checkbox">
                                        <input type="checkbox" class="JS_checkbox_switch JS_otherTravel_judge_ctrl" name="otherTextTag" 
                                        value="000"  <#if is_other_text_tag_item_other_selected =='Y'>checked="checked"</#if> />
                                    </div>

                                    <div class="gi-otherTravel-others" data-validate-extend="true" data-maxlength="200" data-tiplength="150">
                                        
                                        <#if travelAlertInnerSelfTourVO.otherTextInput?? && travelAlertInnerSelfTourVO.otherTextInput?size &gt; 0>
				                                        <#list travelAlertInnerSelfTourVO.otherTextInput as item>
				                                            <div class="gi-otherTravel">
				                                                <input type="text" name="otherTextInput" value="${item}" class="input-text gi-w500 JS_checkbox_disabled"
				                                                       data-validate="true"
				                                	                       required maxlength="500"/>
				                                                <#if item_index &gt; 0>
				                                                <a href="javascript:" class="gi-del gi-otherTravel-del">删除</a>
				                                                </#if>
				                                            </div>
				                                         </#list>
				                         <#else>
				                                        <div class="gi-otherTravel">
				                                            <input type="text" name="otherTextInput" value="" class="input-text gi-w500 JS_checkbox_disabled"
				                                                   data-validate="true"
				                                                   required maxlength="500" disabled/>
				                                        </div>
				                           </#if>

                                        <div class="clearfix gi-w500 gi-otherTravel-add">
                                            <a href="javascript:" class="fr JS_otherTravel_add_btn">增加一条</a>
                                        </div>

                                    </div>
                                </div>
                               </div>
                                
                            </dd>
                        </dl>
                        
                    </div>
                </div>
                <!--出行警示 结束-->
				
               <!--退改说明 开始-->
                <p class="pdi-title">退改说明：</p>
                <div class="gi-form lt-tgsm">
                    <#-- 隐藏域存放DIV -->
                    <div class="refundExplainInnerHiddenDiv" style="display:none;">
                        <input type="hidden" name="refundProdDescId" value="${refundProductDescription.prodDescId}"/>
                    </div>
                    
                    <div class="clearfix">
                        <p class="lte_title">退改说明：</p>
                        <div class="lte_content">
                            <div class="lte_check_list">
                                <div class="lte_check clearfix">
                                    <label class="lte_check_label">
                                        <input type="checkbox" name="refundExplain" value="001" class="lte_checkbox" <#if refundExplainInnerVO.refundExplain?? && refundExplainInnerVO.refundExplain?seq_contains("001")>checked="checked"</#if>><em>旅游者在行程开始前7日以内提出解除合同或者按照本合同第十二条第2款约定由旅行社在行程开始前解除合同的，按下列标准扣除必要的费用</em>
                                    </label>
                                </div>
                                <div class="lte_check clearfix">
                                    <label class="lte_check_label">
                                        <input type="checkbox" name="refundExplain" value="002" class="lte_checkbox" <#if refundExplainInnerVO.refundExplain?? && refundExplainInnerVO.refundExplain?seq_contains("002")>checked="checked"</#if>><em>行程开始前6日至4日，按旅游费用总额的20%</em>
                                    </label>
                                </div>
                                <div class="lte_check clearfix">
                                    <label class="lte_check_label">
                                        <input type="checkbox" name="refundExplain" value="003" class="lte_checkbox" <#if refundExplainInnerVO.refundExplain?? && refundExplainInnerVO.refundExplain?seq_contains("003")>checked="checked"</#if>><em>行程开始前3日至1日，按旅游费用总额的40%；</em>
                                    </label>
                                </div>
                                <div class="lte_check clearfix">
                                    <label class="lte_check_label">
                                        <input type="checkbox" name="refundExplain" value="004" class="lte_checkbox" <#if refundExplainInnerVO.refundExplain?? && refundExplainInnerVO.refundExplain?seq_contains("004")>checked="checked"</#if>><em>行程开始当日，按旅游费用总额的60%</em>
                                    </label>
                                </div>
                                <div class="lte_check clearfix">
                                    <label class="lte_check_label">
                                        <input type="checkbox" name="refundExplain" value="005" class="lte_checkbox" <#if refundExplainInnerVO.refundExplain?? && refundExplainInnerVO.refundExplain?seq_contains("005")>checked="checked"</#if>><em>如按上述比例支付的业务损失费不足以赔偿组团社的实际损失，旅游者应当按实际损失对组团社予以赔偿，但最高额不应当超过旅游费用总额</em>
                                    </label>
                                </div>
                                <div class="lte_check clearfix">
                                    <label class="lte_check_label">
                                        <input type="checkbox" name="refundExplain" value="006" class="lte_checkbox" <#if refundExplainInnerVO.refundExplain?? && refundExplainInnerVO.refundExplain?seq_contains("006")>checked="checked"</#if>><em>游客转让：出行前，在符合办理团队签证或签注期限或其他条件许可情况下，旅游者可以向组团社书面提出将其自身在本合同中的权利和义务转让给符合出游条件的第三人；并且由第三人与组团社重新签订合同；因此增加的费用由旅游者或第三人承担，减少的费用由组团社退还旅游者</em>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="clearfix">
                        <p class="lte_title">其他 ：</p>
                        <div class="lte_content">
                            <div class="JS_checkbox_switch_box gi-other-box">
                                <div class="gi-other-checkbox">
                                    <input type="checkbox" name="refundExplain" value="000"  class="JS_checkbox_switch JS_other_judge_ctrl" <#if refundExplainInnerVO.refundExplain?? && refundExplainInnerVO.refundExplain?seq_contains("000")>checked="checked"</#if>/>
                                </div>

                                <div class="gi-others" data-validate-extend="true" data-maxlength="200" data-tiplength="150">
                                    <#if refundExplainInnerVO.refundExplainInput?? && refundExplainInnerVO.refundExplainInput?size &gt; 0>
                                        <#list refundExplainInnerVO.refundExplainInput as item>
                                            <div class="gi-other">
                                                <input type="text" name="refundExplainInput" value="${item}" class="input-text gi-w600 JS_checkbox_disabled"
                                                       data-validate="true"
                                                       required maxlength="500"/>
                                                <#if item_index &gt; 0>
                                                <a href="javascript:" class="gi-del gi-other-del">删除</a>
                                                </#if>
                                            </div>
                                         </#list>
                                    <#else>
                                        <div class="gi-other">
                                            <input type="text" name="refundExplainInput" value="其它" class="input-text gi-w500 JS_checkbox_disabled"
                                                   data-validate="true"
                                                   required maxlength="500" disabled/>
                                        </div>
                                    </#if>
                                    <div class="clearfix gi-w500 gi-other-add"> 
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

<!--/弹出层END-->

<!-- 模态窗口 开始-->
<!--遮罩 开始-->
<div class="gi-modal-overlay"></div>
<!--遮罩 结束-->


<div class="JS_template_inner">

    <!--其他 开始-->
    <div class="gi-other">
        <input type="text" name="refundExplainInput" class="input-text gi-w500 JS_checkbox_disabled" value="" data-validate="true" required
               maxlength="500"/>
        <a href="javascript:" class="gi-del gi-other-del">删除</a>
    </div>
    <div class="gi-otherTravel">
        <input type="text" name="otherTextInput" class="input-text gi-w500 JS_checkbox_disabled" value="" data-validate="true" required
               maxlength="500"/>
        <a href="javascript:" class="gi-del gi-otherTravel-del">删除</a>
    </div>
    <!--其他 结束-->

</div>
<script src="http://pic.lvmama.com/min/index.php?f=/js/new_v/jquery-1.7.2.min.js"></script>
<!-- 引入基本的js -->
<#include "/base/foot.ftl"/>

<!--新增脚本文件-->
<!--<script src="http://pic.lvmama.com/js/backstage/vst-product-provision.js"></script>-->
<script src="/vst_admin/js/dujia/vst-product-provision.js"></script>

<script>
(function() {
		

    //初始化页面默认选中项
    initPageChecked();

    var $document = $(document);
    $document.on("click", ".JS_button_save", function () {
        
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
            changeSaveButtonStatus(true);
            
            //ajax保存出行警示（国内）VO数据
            saveTravelAlertInner();
        } else {
            alertObj = $.saveAlert({
                "width": 250,
                "type": "danger",
                "text": "请完成必填填写项并确认填写正确"
            });
        }

    });
    
})();



// 保存出行警示（国内）信息
function saveTravelAlertInner() {

    $.ajax({
        url : "/vst_admin/dujia/group/product/saveOrUpdateProductSuggInnerForSelfTour.do",
        data : $(".productSuggInnerForm").serialize(),
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
            console.log("Call saveOrUpdateProductSuggInner method occurs error");
            $.saveAlert({"width": 250,"type": "danger","text": "网络服务异常, 请稍后重试"});
        }
    });
}


//改变 保存、保存并下一步 按钮的状态（isLoading：true 保存前 false 保存结束后）
    function changeSaveButtonStatus(isLoading) {
        var $form = $(".productSuggInnerForm");
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
    var travleProdDescId = $(".travelAlertInnerHiddenDiv>input[name='travleProdDescId']").val();
    //如果prodDescId为空，表示页面是新增页面需要初始化页面默认选中项
    if (isEmpty(travleProdDescId)) {
        $(".gi-color-green").css("display", "inline");
        $("input[type='checkbox']").attr("checked", "checked");
        $("input[type='checkbox'][name='roomDiff']").removeAttr("checked");
        $("input[type='checkbox'][value='other']").removeAttr("checked");
        $("input[name='otherTextTag'][value='000']").removeAttr("checked");
        $("input[type='checkbox']").closest("label").find("input[type='text']").removeAttr("disabled");
    }
    var refundProdDescId = $(".refundExplainInnerHiddenDiv>input[name='refundProdDescId']").val();
    //如果prodDescId为空，表示页面是新增页面需要初始化页面默认选中项
    if (isEmpty(refundProdDescId)) {
        $("input[name='refundExplain']").attr("checked", "checked");
        $("input[name='refundExplain'][value='000']").removeAttr("checked");
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
        $("a[class*=JS_button_save],a[class*=JS_other_add_btn],a[class*=gi-other-del]").remove();
    }
}
</script>
</body>
</html>

