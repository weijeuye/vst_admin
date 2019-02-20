<#-- 行前须知map字段分解 -->
<#if travelAlertInnerVO.travelNotes??>
<#list travelAlertInnerVO.travelNotes?keys as key>
    <#if key == "travel_note">
       <#assign travel_note = 'Y' />
       <#assign travel_note_value = travelAlertInnerVO.travelNotes["travel_note"] />
       <#assign is_travel_note_all_selected = (travel_note_value == "001,002,003")?string('Y','N') />
    </#if>
</#list>
</#if>

<#-- 出行说明map字段分解 -->
<#if travelAlertInnerVO.travelDesc??>
<#list travelAlertInnerVO.travelDesc?keys as key>
    <#if key == "travel_desc">
       <#assign travel_desc = 'Y' />
       <#assign travel_desc_value = travelAlertInnerVO.travelDesc["travel_desc"] />
       <#assign is_travel_desc_all_selected = (travel_desc_value == "001,002,003,004,005,006,007,008,009,010")?string('Y','N') />
    </#if>
</#list>
</#if>

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
    	.gi-otherTravel-others,.gi-otherReserve-others { float:left}
		.gi-otherTravel,.gi-otherReserve { margin-bottom:10px;}
        .em_points{margin-left:20px;font-family: 'Microsoft YaHei', sans-serif;font-size: 14px;}
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
                            <dt>行前须知 ：</dt>
                            <dd class="gi-notice-status">
                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="travelNotes['travel_note']" value="${travel_note_value!''}" class="JS_checkbox_switch gi-notice-checkbox" <#if travel_note == 'Y'>checked="checked"</#if> />
                                    行前须知条款
                                    <span class="gi-color-green" style="<#if is_travel_note_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">
                                        (已全选)
                                    </span>
                                    <span class="gi-color-red hide" style="<#if is_travel_note_all_selected == 'N'>display: inline;<#else>display: none;</#if>">
                                        (未全选)
                                    </span>
                                    <#-- data-class值存放了对应模态窗口的主DIV的class值 -->
                                    <a href="javascript:" class="gi-notice-show-modal-btn JS_checkbox_hidden" data-class="gi-modal-notice">
                                        查看编辑范围
                                    </a>
                                </label>
                                </div>
                            </dd>
                        </dl>

                        <dl class="clearfix">
                            <dt>
                                预订须知 ：
                            </dt>
                            <dd class="gi-checkbox-group js-checkbox-group">
                                <div class="clearfix">
                                <label>
                                    <#assign is_book_infor_item_001_selected = (travelAlertInnerVO.bookInfor?? && travelAlertInnerVO.bookInfor?seq_contains("001"))?string('Y','N') />
                                    <input type="checkbox" id="bookInfoDis1" name="bookInfor" value="001" 
                                    <#if prodProduct.producTourtType == 'MULTIDAYTOUR'>
                                    	<#if travelAlertInnerVO.bookInfor?? && travelAlertInnerVO.bookInfor?seq_contains("001")>checked="checked"</#if>
                                    <#else>
                                    	checked="checked" disabled
                                    </#if> class="JS_checkbox_switch"/>
                                    <em>旅游者如系
                                        <input type="text" name="bookInforAge1" value="${travelAlertInnerVO.bookInforAge1!'60'}" class="gi-w50 js-input"  maxlength="4" data-validate="true" required digits="true"/>
                                        岁以上（含 
                                        <input type="text" name="bookInforAge2" value="${travelAlertInnerVO.bookInforAge2!'60'}" class="gi-w50 js-input"  maxlength="4" data-validate="true" required digits="true"/>
                                        岁）人员出游的，本人需充分考虑自身健康状况能够完成本次旅游活动，谨慎出游，建议要有亲友陪同出游，如因旅游者自身身体原因引发疾病或其他损害由旅游者本人承担相关责任。未满18周岁的旅游者请由家属陪同参团。
                                    </em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" id="bookInfoDis2" name="bookInfor" value="002" checked="checked" disabled />
                                    <em>游客必须保证自身身体健康良好的前提下，参加旅行社安排的旅游行程，不得欺骗隐瞒，若因游客身体不适而发生任何意外，旅行社不承担责任</em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="bookInfor" value="003" <#if travelAlertInnerVO.bookInfor?? && travelAlertInnerVO.bookInfor?seq_contains("003")>checked="checked"</#if>/>
                                    <em>单房差：报价是按照2人入住1间房计算的价格，如出现单男或单女情况，  本公司将于出发前通知是否可以拼房或加床并支付附加费，如未能拼房，就需支付单人房附加费，享用单人房间。</em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="bookInfor" value="004" <#if travelAlertInnerVO.bookInfor?? && travelAlertInnerVO.bookInfor?seq_contains("004")>checked="checked"</#if>/>
                                    <em>旅游线路产品，已将相关景点进行优惠打包，因此不可重复享受优惠（如特殊证件、优惠门票等），特别情况下涉及退费也仅退回优惠后的门票费用；任何费用一律不现退，统一在回程后，由驴妈妈旅游网退还至游客的驴妈妈账户</em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="bookInfor" value="005" <#if travelAlertInnerVO.bookInfor?? && travelAlertInnerVO.bookInfor?seq_contains("005")>checked="checked"</#if>/>
                                    <em>为确保游客的游程顺利，当日游程的前后顺序可能需要依据当时情况统一调整；行程内车程及游览时间仅供参考，以实际情况为准！如遇路况原因等突发情况需要变更各集合时间的，以导游员届时公布为准。</em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label>
                                    <input type="checkbox" name="bookInfor" value="006" <#if travelAlertInnerVO.bookInfor?? && travelAlertInnerVO.bookInfor?seq_contains("006")>checked="checked"</#if>/>
                                    <em>为您及您孩子的健康安全，0.8米以上小孩需单独占座，请携带小孩的旅客报名时，向旅社告知您的小孩是否需要占座，否则旅社可能会以安全为由，拒绝接待您的小孩参与本次旅游活动，谢谢配合。</em>
                                </label>
                                </div>

                                <div class="clearfix">
                                <label>
                                    <#assign is_book_infor_item_007_selected = (travelAlertInnerVO.bookInfor?? && travelAlertInnerVO.bookInfor?seq_contains("007"))?string('Y','N') />
                                    <input type="checkbox" name="bookInfor" value="007" class="JS_checkbox_switch" <#if is_book_infor_item_007_selected == 'Y'>checked="checked"</#if>/>
                                    <em>本产品仅针对
                                        <input type="text" name="bookInforAge3" value="${travelAlertInnerVO.bookInforAge3!''}" class="gi-w50 js-input" <#if is_book_infor_item_007_selected == 'N'>disabled</#if> maxlength="10" data-validate="true" required/>
                                        周岁用户，每单
                                        <input type="text" name="bookInforPeoStart" value="${travelAlertInnerVO.bookInforPeoStart!''}" class="gi-w50 js-input" <#if is_book_infor_item_007_selected == 'N'>disabled</#if> maxlength="10" data-validate="true" required digits="true"/>
                                        人起订，最多
                                        <input type="text" name="bookInforPeoMax" value="${travelAlertInnerVO.bookInforPeoMax!''}" class="gi-w50 js-input" <#if is_book_infor_item_007_selected == 'N'>disabled</#if> maxlength="10" data-validate="true" required digits="true"/>
                                        人；单男单女单组全男无法安排接待，敬请谅解！云南属于少数民族地区，因此其接待资质有限，对于外籍和港、澳、台同胞，记者，导游，旅游从业人员都无法接待，建议您选择其他方向。少数民族地区风俗习惯不同，因此对于
                                        <p><input type="text" name="area" value="${travelAlertInnerVO.area!'云贵川、重庆、广东广西、深圳、海南、焦作、驻马店、南洋、周口、温州、青海、新疆等少数民族'}" class="gi-w600 js-input" <#if is_book_infor_item_007_selected == 'N'>disabled</#if> maxlength="100" data-validate="true" required/></p>
                                        区域客人，建议您选择其他方向，以免引起不必要冲突；此线路行程相对紧凑，加之云南地处高原，对于老年人、小朋友和患有高血压心脏病游客建议选择其他线路。
                                    </em>
                                </label>
                                </div>
                            </dd>
                        </dl>
                        
                        
                        <dl class="clearfix">
                            <dt>
                                出行说明 ：
                            </dt>
                            <dd class="gi-explanation-status">
                            
                            
                                <div class="clearfix">
                                <label class="JS_checkbox_switch_box">
                                    <input type="checkbox" name="travelDesc['travel_desc']" value="<#if travel_desc_value??>${travel_desc_value}</#if>" class="JS_checkbox_switch gi-explanation-checkbox" <#if travel_desc == 'Y'>checked="checked"</#if>/>
                                    出行说明条款
                                    <span class="gi-color-green" style="<#if is_travel_desc_all_selected == 'Y'>display: inline;<#else>display: none;</#if>">
                                        (已全选)
                                    </span>
                                    <span class="gi-color-red hide" style="<#if is_travel_desc_all_selected == 'N'>display: inline;<#else>display: none;</#if>">
                                        (未全选)
                                    </span>
                                    <#-- data-class值存放了对应模态窗口的主DIV的class值 -->
                                    <a href="javascript:" class="gi-explanation-show-modal-btn JS_checkbox_hidden" data-class="gi-modal-explanation">
                                        查看编辑范围
                                    </a>
                                </label>
                                </div>

                            </dd>
                        </dl>
                        
                         <dl class="clearfix">
                            <dt>
                                其他 ：
                            </dt>
                            <dd class="lte_content">
                                <div class="JS_checkbox_switch_box gi-otherTravel-box">
                                	<#assign is_book_infor_item_other_selected = (travelAlertInnerVO.otherTextTagChange?? && travelAlertInnerVO.otherTextTagChange?seq_contains("other"))?string('Y','N') />
                                	
                                    <div class="gi-other-checkbox">
                                        <input type="checkbox" class="JS_checkbox_switch JS_otherTravel_judge_ctrl" name="otherTextTagChange" 
                                        value="other" <#if is_book_infor_item_other_selected =='Y'>checked="checked"</#if> />
                                    </div>

                                    <div class="gi-otherTravel-others" data-validate-extend="true" data-maxlength="200" data-tiplength="150">
                                       
                                        
                                        
                                        <#if travelAlertInnerVO.otherTextInput?? && travelAlertInnerVO.otherTextInput?size &gt; 0>
				                                        <#list travelAlertInnerVO.otherTextInput as item>
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
				                                            <input type="text" name="otherTextInput" value="其它" class="input-text gi-w500 JS_checkbox_disabled"
				                                                   data-validate="true"
				                                                   required maxlength="500" disabled/>
				                                        </div>
				                           </#if>

                                        <div class="clearfix gi-w500 gi-otherTravel-add">
                                            <a href="javascript:" class="fr JS_otherTravel_add_btn">增加一条</a>
                                        </div>

                                    </div>
                                </div>
                            </dd>
                        </dl>
                        
                        
                   <!--      <dl>
                        	<dt>其他:</dt>
                        	<dd class="gi-explanation-status">
                        			<div class="clearfix">
				                        <p class="lte_title"></p>
				                        <div class="lte_content">
				                            <div class="JS_checkbox_switch_box gi-other-box">
				                                <div class="gi-other-checkbox">
				                                    <input type="checkbox" name="otherTextTagChange" value="other"  class="JS_checkbox_switch JS_other_judge_ctrl" <#if refundExplainInnerVO.refundExplain?? && refundExplainInnerVO.refundExplain?seq_contains("other")>checked="checked"</#if>/>
				                                </div>
				
				                                <div class="gi-others">
				                                    <#if travelAlertInnerVO.otherTextInput?? && travelAlertInnerVO.otherTextInput?size &gt; 0>
				                                        <#list travelAlertInnerVO.otherTextInput as item>
				                                            <div class="gi-other">
				                                                <input type="text" name="otherTextInput" value="${item}" class="input-text gi-w600 JS_checkbox_disabled"
				                                                       data-validate="true"
				                                                       required maxlength="500"/>
				                                                <#if item_index &gt; 0>
				                                                <a href="javascript:" class="gi-del gi-other-del">删除</a>
				                                                </#if>
				                                            </div>
				                                         </#list>
				                                    <#else>
				                                        <div class="gi-other">
				                                            <input type="text" name="otherTextInput" value="其它" class="input-text gi-w600 JS_checkbox_disabled"
				                                                   data-validate="true"
				                                                   required maxlength="500" disabled/>
				                                        </div>
				                                    </#if>
				                                    <div class="clearfix gi-w550 gi-other-add"> 
				                                        <a href="javascript:" class="fr JS_other_add_btn">增加一条</a>
				                                    </div>
				
				                                </div>
				                            </div>
				                        </div>
				                    </div>
                        	
                        	
                        	</dd>
                        
                        </dl>-->
                        
                        
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
                                        <input type="checkbox" name="refundExplain" value="007" class="lte_checkbox" <#if refundExplainInnerVO.refundExplain?? && refundExplainInnerVO.refundExplain?seq_contains("007")>checked="checked"</#if>><em>在行程前解除合同的，机（车、船）票费用按实结算。</em>
                                    </label>
                                </div>
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
                 <!--预订限制 开始-->
                 <#if isInnerGroupOrLocal?? && isInnerGroupOrLocal=='Y'>
                 <div style="margin-top:15px;">
                     <label class="pdi-title">出游人预订限制：</label>
                     <em class="em_points">*可在VST>基础设置>国内预定条件配置页面中根据省级目的地维度批量设置产品限制条件</em>
                 </div>
                 <div class="gi-form lt-ydxz" style="width: 850px;">
                     <div class="reserveLimitInnerHiddenDiv" style="display:none;">
                         <input type="hidden" name="reserveLimitProdDescId" value="${reserveLimitDescription.prodDescId}"/>
                     </div>
                     <div class="clearfix">
                         <p class="lte_title">&nbsp;</p>
                         <div class="lte_content">
                             <div class="lte_check_list">
                                 <div class="lte_check clearfix">
                                     <label class="lte_check_label">
                                         <input type="checkbox" name="limitInfor" value="01" class="lte_checkbox" <#if prodReserveLimit.limitInfor?? && prodReserveLimit.limitInfor?seq_contains("01")>checked="checked"</#if> />
                                         <em>出于安全考虑，本产品不支持孕妇预订，建议选择其他出行方式，敬请谅解；</em>
                                     </label>
                                 </div>
                                 <div class="lte_check clearfix">
                                     <label class="lte_check_label">
                                         <input type="checkbox" name="limitInfor" value="02" class="lte_checkbox" <#if prodReserveLimit.limitInfor?? && prodReserveLimit.limitInfor?seq_contains("02")>checked="checked"</#if>>
                                         <em>若出行人中有非大陆籍客人，建议预订前致电客服进行咨询，给您带来的不便敬请谅解；</em>
                                     </label>
                                 </div>
                                 <div class="lte_check clearfix">
                                     <label class="lte_check_label">
                                         <#assign is_limitInfor_03_selected = (prodReserveLimit.limitInfor?? && prodReserveLimit.limitInfor?seq_contains("03"))?string('Y','N') />
                                         <input type="checkbox" name="limitInfor" value="03" class="lte_checkbox" <#if is_limitInfor_03_selected == 'Y'>checked="checked"</#if> />
                                         <em>
                                             若出行人中有
                                             <input type="text" name="ageRangeLower" <#if is_limitInfor_03_selected == 'Y'>value="${prodReserveLimit.ageRangeLower!''}"</#if> class="gi-w50 js-input" <#if is_limitInfor_03_selected == 'N'>disabled</#if> maxlength="10" data-validate="true" required digits="true"/>
                                             周岁以下（含）客人，烦请预订前致电驴妈妈客服咨询是否可以参团，给您带来的不便敬请谅解；
                                         </em>
                                     </label>
                                 </div>
                                 <div class="lte_check clearfix">
                                     <label class="lte_check_label">
                                         <#assign is_limitInfor_04_selected = (prodReserveLimit.limitInfor?? && prodReserveLimit.limitInfor?seq_contains("04"))?string('Y','N') />
                                         <input type="checkbox" name="limitInfor" value="04" class="lte_checkbox" <#if is_limitInfor_04_selected == 'Y'>checked="checked"</#if> />
                                         <em>
                                             若出行人中有
                                             <input type="text" name="ageRangeUpper" <#if is_limitInfor_04_selected == 'Y'>value="${prodReserveLimit.ageRangeUpper!''}"</#if> class="gi-w50 js-input" <#if is_limitInfor_04_selected == 'N'>disabled</#if> maxlength="10" data-validate="true" required digits="true"/>
                                             周岁以上（含）客人，烦请预订前致电驴妈妈客服咨询是否可以参团，给您带来的不便敬请谅解；
                                         </em>
                                     </label>
                                 </div>
                                 <div class="lte_check clearfix">
                                     <label class="lte_check_label">
                                         <#assign is_limitInfor_05_selected = (prodReserveLimit.limitInfor?? && prodReserveLimit.limitInfor?seq_contains("05"))?string('Y','N') />
                                         <input type="checkbox" name="limitInfor" value="05" class="lte_checkbox" <#if is_limitInfor_05_selected == 'Y'>checked="checked"</#if> />
                                         <em>
                                             若出行人中有
                                             <input type="text" name="ageRangeLower" <#if is_limitInfor_05_selected == 'Y'>value="${prodReserveLimit.ageRangeLower!''}"</#if> class="gi-w50 js-input" <#if is_limitInfor_05_selected == 'N'>disabled</#if> maxlength="10" data-validate="true" required digits="true"/>
                                             周岁以下及
                                             <input type="text" name="ageRangeUpper" <#if is_limitInfor_05_selected == 'Y'>value="${prodReserveLimit.ageRangeUpper!''}"</#if> class="gi-w50 js-input" <#if is_limitInfor_05_selected == 'N'>disabled</#if> maxlength="10" data-validate="true" required digits="true"/>
                                             周岁以上（含）客人烦请预订前致电驴妈妈客服咨询是否可以参团，给您带来的不便敬请谅解；
                                         </em>
                                     </label>
                                 </div>
                             </div>
                         </div>
                     </div>
                     <div class="clearfix">
                         <p class="lte_title">&nbsp;</p>
                         <div class="lte_content">
                             <div class="JS_checkbox_switch_box gi-otherReserve-box">
                                 <div class="gi-other-checkbox">
                                     <input type="checkbox" name="limitInfor" value="00"  class="JS_checkbox_switch JS_otherReserve_judge_ctrl" <#if prodReserveLimit.limitInfor?? && prodReserveLimit.limitInfor?seq_contains("00")>checked="checked"</#if>/>
                                 </div>

                                 <div class="gi-otherReserve-others" data-validate-extend="true" data-maxlength="200" data-tiplength="150">
                                    <#if prodReserveLimit.otherLimit?? && prodReserveLimit.otherLimit?size &gt; 0>
                                        <#list prodReserveLimit.otherLimit as item>
                                            <div class="gi-otherReserve">
                                                <input type="text" name="otherLimit" value="${item}" class="input-text gi-w500 JS_checkbox_disabled"
                                                       data-validate="true"
                                                       required maxlength="500"/>
                                                <#if item_index &gt; 0>
                                                <a href="javascript:" class="gi-del gi-otherReserve-del">删除</a>
                                                </#if>
                                            </div>
                                        </#list>
                                    <#else>
                                        <div class="gi-otherReserve">
                                            <input type="text" name="otherLimit" value="其它" class="input-text gi-w500 JS_checkbox_disabled"
                                                   data-validate="true"
                                                   required maxlength="500" disabled/>
                                        </div>
                                    </#if>
                                     <div class="clearfix gi-w500 gi-otherReserve-add">
                                         <a href="javascript:" class="fr JS_otherReserve_add_btn">增加限制条件</a>
                                     </div>
                                 </div>
                             </div>
                         </div>
                     </div>
                 </div>
                 </#if>
                 <!--预订限制 结束-->

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

<!--行前须知条款 开始-->
<div class="gi-modal gi-modal-notice">
    <a href="javascript:" class="gi-modal-close">&times;</a>
    
    <#-- data-key值存放了对应ckeckbox的name值 -->
    <div class="gi-modal-content" data-key="travelNotes['travel_note']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox" />
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>根据国家法律规定，为确保您的游程顺利，请随身携带并自行保管好您的有效身份证明（12岁以下儿童携带户口簿原件或者护照）。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em>此旅游产品为团队游，未经随团领队或导游同意，游客在游览过程中不允许离团（行程中自由活动除外），不便之处敬请谅解。游客个人或结伴未经领队或导游同意私自外出所发生一切意外事故或事件引起的任何责任与后果，均由游客自负，与旅行社无关。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em>为了不耽误您的行程，请您严格按照《出团通知书》要求，在航班起飞前规定时间到达机场集合并办理登机和出入境相关手续。出团通知书会在出发前1天给到客人。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
    <!--行前须知条款 结束-->
</div>
<!--行前须知条款 结束-->

<!--出行说明条款 开始-->
<div class="gi-modal gi-modal-explanation">
    <a href="javascript:" class="gi-modal-close">&times;</a>
    
    <#-- data-key值存放了对应ckeckbox的name值 -->
    <div class="gi-modal-content" data-key="travelDesc['travel_desc']">
        <div class="gi-checkbox-all">
            <label class="clearfix">
                <input class="gi-check-all" type="checkbox"/>
                <em>全选</em>
            </label>
        </div>
        <div class="gi-checkbox-group">
            <label class="clearfix">
                <input type="checkbox" value="001"/>
                <em>旅游者参加高原地区旅游或风险旅游项目（包括但不限于：游泳、浮潜、冲浪、漂流等水上活动以及骑马、攀岩、登山等高风 险的活动）或患有不宜出行旅游的病情（包括但不限于：恶性肿瘤、心血管病、高血压、呼吸系统疾病、癫痫、怀孕、精神疾病、身体残疾、糖尿病、传染性疾病、 慢性疾病健康受损），建议在报名前自行前往医疗机构体检或自行咨询医院专业医生意见，以确保自身身体条件能够完成本次旅游活动。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="002"/>
                <em>若旅游行程内含有购物店，旅游者有权选择是否参加，如旅游者不愿参加，可选择预订 其他旅游产品线路。旅行过程中须经过景区、博物馆等衍生设置的购物店，请您特别注意商品的价格合理性及品质，谨慎选择。在付款前务必仔细检查，确保商品完好无损、配件齐全并具备相应的鉴定证书，明确了解商品售后服务流程；购买后妥善保管相关票据以备维权。一旦出现商品质量问题，我社将积极协助游客处理，但是不承担责任。在行程游览过程中，旅行社将会视旅游者需求及实际情况推荐部分自费项目，如旅游者自愿参加，应与旅行社另行签署书面协议，并不得影响同团其他客人在此期间的活动安排。若自费项目参加人数不满十人，本社保留取消该项目的权利；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="003"/>
                <em>财产安全：现金、证件和贵重物品须随身携带和注意保管（无论是乘坐航空器、火车、船只），切勿放在托运行李内，也不应在游览或娱乐时留置在酒店房间或旅游车上，必要时可寄放到酒店的保险箱（如酒店收取费用，请自理），因保管不妥引起遗失及损坏， 旅行社不承担责任；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="004"/>
                <em>“旅游有风险”建议旅游者根据个人意愿和需要自行投保个人旅游意外保险。根据保险公司的规定，未成年人、成年人、老年人承保、赔付保险金额是不同的，其中未成年人、老年人保险赔付金额会比保单中载明的保险金额低一定比例，敬请留意。对于高风险娱乐项目，旅行社再次特别提醒，务必充分考虑自身身体条件谨慎参加，并强烈建议旅游者投保高风险意外险种；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="005"/>
                <em>为了确保旅游顺利出行，防止旅途中发生人身意外伤害事故，请旅游者在出行前做一次必要的身体检查，游客必须保证自身身体健康良好的前提下，参加旅行社安排的旅游行程，不得欺骗隐瞒，若因游客身体不适而发生任何意外，旅行社不承担责任。在旅游过程中、游客所参加的旅游活动应选择自己能够控制风险的旅游项目，并对自己安全负责。如70岁以上老年人不宜泡温泉，1.4米以下儿童不宜参与漂流项目（尤其皮筏漂流）等，请谨慎选择参与！旅行社不推荐游客参加人身安全不确定的活动，旅行社禁止游客进行江、河、湖、海的游泳活动，游客擅自行动，产生后果，旅行社不承担责任。旅游者参加高原地区旅游或风险旅游项目（包括但不限于：游泳、浮潜、冲浪、漂流等水上活动以及骑马、攀岩、登山等高风险的活动）或患有不宜出行旅游的病情（包括但不限于：恶性肿瘤、心血管病、高血压、呼吸系统疾病、癫痫、怀孕、精神疾病、身体残疾、糖尿病、传染性疾病、慢性疾病健康受损），建议在报名前自行前往医疗机构体检或自行咨询医院专业医生意见，以确保自身身体条件能够完成本次旅游活动，如自身身体条件不适宜出游而参加旅游活动的，在行程中因自身身体条件引发的疾病或其他损害由旅游者本人承担相关责任；旅游者如系60岁以上（含60岁）人员出游的，本人需充分考虑自身健康状况能够完成本次旅游活动，谨慎出游，建议要有亲友陪同出游，如因旅游者自身身体原因引发疾病或其他损害由旅游者本人承担相关责任。上述内容作为乙方给予旅游者的重要出游安全提示，如旅游者仍坚持参加旅游活动，由此造成任何人身意外及不良后果将由旅游者本人承担全部责任。为了获得更为全面的保障，乙方强烈建议旅游者出游时根据个人意愿和需要自行投保人身意外伤害保险等个人险种；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="006"/>
                <em>在自行安排活动期间，旅游者应在自己能够控制风险的范围内活动，旅游者应选择自己能够控制风险的活动项目，并对自己的安全负责。旅游期间或自行安排活动期间请注意人身和财产安全。旅游者因违约、自身过错、自行安排活动期间内的行为或自身疾病引起的人身、财产损失由其自行承担；由此给旅行社或其他服务提供方造成损失的，旅游者应当承担赔偿责任。为了获得更为全面的保障，乙方强烈建议旅游者出游时根据个人意愿和需要自行投保人身意外伤害保险等个人险种；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="007"/>
                <em>产品中描述的旅游行程安排可能因不可抗力、意外事件等不可归责于旅行社的客观原因进行调整或者变更。在旅游行程中，当发生不可抗力、危及旅游者人身、财产安全，或者非旅行社责任造成的意外情形，旅行社不得不调整或者变更旅游合同约定的行程安排时,可以调整或变更行程安排，但是应当在事前向旅游者做出说明；确因客观情况无法在事前说明的，应当在事后做出说明；不可抗力或意外事件等导致本次团队旅游行程变更或取消的，产生的损失费用旅行社不承担任何责任，因此增加的旅游费用由旅游者承担，因此减少的旅游费用退还旅游者；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="008"/>
                <em>不可抗力是指不能预见、不能避免并不能克服的客观情况。不可抗力、意外事件等不可归责于旅行社的客观原因包括但不限于，恶劣天气、自然灾害、战争、罢工、骚乱、飞机故障、航班保护、恐怖事件、政府行为、公共卫生事件等客观原因，造成旅游行程安排的交通服务延误、景区临时关闭、宾馆饭店临时被征用、出境管制、边境关闭、目的地入境政策临时变更、我国政府机构发布橙色及以上旅游预警信息等，均会导致旅游目的无法实现，旅行社不承担违约责任；</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="009"/>
                <em>旅游者在旅游过程中应遵从领队、导游和当地相关人员安排，听从有关人员指导，否则责任由旅游者自行承担。游览、观光过程中应谨慎拍照、摄像，在拍照、摄像 时应注意往来车辆、所处位置进行拍照、摄像是否有危险或是否有禁拍标志，切忌在可能有危险或设有危险标志的地方停留。旅游者在行程中发现自身权益受到侵 害，应及时告知领队、导游以及旅游者的紧急联系人，因没有及时提出而造成的损失由旅游者自负。</em>
            </label>
            <label class="clearfix">
                <input type="checkbox" value="010"/>
                <em>如需开具旅游发票(仅限支付给驴妈妈的订单用户)，请与客服专员确定发票内容与抬头及准确的发票邮寄地址，我司在收到邮寄地址信息后向您寄送发票；为避免因发生不可抗力或意外事项致实际消费额与发票开具的相应数额不符，建议您在游玩归来后两个月内索领取发票。</em>
            </label>
        </div>
        <div class="gi-ctrl clearfix">
            <div class="fr">
                <a href="javascript:" class="gi-button gi-mr15 gi-save-btn">确定</a>
                <a href="javascript:" class="gi-button gi-mr15 gi-cancel-btn">取消</a>
            </div>
        </div>
    </div>
    <!--出行说明条款 结束-->
</div>
<!--出行说明条款 结束-->
<!-- 模态窗口 结束-->


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
    <div class="gi-otherReserve">
        <input type="text" name="otherLimit" class="input-text gi-w500 JS_checkbox_disabled" value="" data-validate="true" required
               maxlength="500"/>
        <a href="javascript:" class="gi-del gi-otherReserve-del">删除</a>
    </div>
    <!--其他 结束-->

</div>
<script src="http://pic.lvmama.com/min/index.php?f=/js/new_v/jquery-1.7.2.min.js"></script>
<!-- 引入基本的js -->
<#include "/base/foot.ftl"/>

<!--新增脚本文件-->
<!--<script src="http://pic.lvmama.com/js/backstage/vst-product-provision.js"></script>-->
<script src="/vst_admin/js/dujia/vst-product-provision.js?version=201801041100"></script>

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
            $("." + classTag + " input[type='checkbox']").removeAttr("checked");
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
})();



// 保存出行警示（国内）信息
function saveTravelAlertInner() {
	$("#bookInfoDis1").removeAttr("disabled");
	$("#bookInfoDis2").removeAttr("disabled");
    $.ajax({
        url : "/vst_admin/dujia/group/product/saveOrUpdateProductSuggInner.do",
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
			$("#bookInfoDis1").attr("disabled","disabled");
			$("#bookInfoDis2").attr("disabled","disabled");
            changeSaveButtonStatus(false);
        },
        error: function() {
            //改变保存按钮状态
            $("#bookInfoDis1").attr("disabled","disabled");
			$("#bookInfoDis2").attr("disabled","disabled");
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
        $("input[type='checkbox']").not(".lt-ydxz input[type='checkbox']").attr("checked", "checked");
        $("input[type='checkbox'][value='007']").removeAttr("checked");
        $("input[type='checkbox'][value='other']").removeAttr("checked");
        $("input[type='checkbox'][value='007']").closest("label").find("input[type='text']").attr("disabled", "disabled");
        $("input[name=\"travelNotes['travel_note']\"").val("001,002,003");
        $("input[name=\"travelDesc['travel_desc']\"").val("001,002,003,004,005,006,007,008,009,010");
        $("input[type='text'][name='bookInforAge1']").removeAttr("disabled");
        $("input[type='text'][name='bookInforAge2']").removeAttr("disabled");
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

$(".lt-ydxz input[name='limitInfor']").bind("click", function () {

    if($(this).attr("checked") == "checked"){
        $(this).siblings("em").find("input[type='text']").removeAttr("disabled");
        var keyNum = $(this).val(),
            keyArray = ["03","04","05"];
        if($.inArray(keyNum, keyArray) != -1){
            var $that = $("input[name='limitInfor'][value='03'], input[name='limitInfor'][value='04'],input[name='limitInfor'][value='05']")
                        .not("input[name='limitInfor'][value="+keyNum+"]");
            $that.removeAttr("checked");
            $that.siblings("em").find("input[type='text']").attr("disabled", "disabled");
        }
    }else {
        $(this).siblings("em").find("input[type='text']").attr("disabled", "disabled");
    }
});
</script>
</body>
</html>

