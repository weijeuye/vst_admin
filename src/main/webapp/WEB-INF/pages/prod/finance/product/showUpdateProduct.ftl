<!DOCTYPE html>
<html>
<head>

  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <script type="text/javascript" src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/ui-common.css" type="text/css"/>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/ui-components.css" type="text/css"/>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/iframe.css" type="text/css"/>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/dialog.css" type="text/css"/>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/easyui.css" type="text/css"/>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/button.css" type="text/css"/>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/base.css" type="text/css"/>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/normalize.css" type="text/css"/>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/calendar.css" type="text/css"/>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/jquery.jsonSuggest.css" type="text/css"/>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/jquery.ui.autocomplete.css" type="text/css"/>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/jquery.ui.theme.css" type="text/css"/>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/contentManage/kindEditorConf.css" type="text/css"/>
  <style>
    td.e_label {
      vertical-align: top;
    }

    input.error, .error {
      border-color: #f00;
    }

    .tgQyjType-ins {
      display: none;
      margin-left: 20px;
      background: #eee;
      padding: 10px;
      width: 676px;
      margin-top: 10px;
    }

    .btn.btn-addNewRule {
      display: none;
      border-color: #29e;
      color: #29e !important;
      background: #fff;
      margin-top: 10px;
    }

    .dialog-msg.dialog-blue {
      width: auto;
      background-color: #4a4a4a;
      border: none;
      color: #fff;
      font-size: 16px;
      font-family: "Microsoft Yahei"
    }

    .dialog-msg .dialog-body {
      background-color: #4a4a4a;
    }

    .tgJgWrap {
      position: relative;
      width: 698px;
      margin-top: 20px;
      border-top: 1px solid #ddd;
      padding: 20px 0 0 20px;
    }

    .e_error {
      margin-left: 0;
    }

    .tgJgWrap .tgQyjType-ins {
      margin-left: 0;
    }

    i.error {
      padding-top: 0;
    }

    textarea.error {
      padding: 4px 6px;
    }

    input.error {
    }

    .firstTgRuleBox {
      margin-top: 10px;
    }

    input[type="radio"], input[type="checkbox"] {
      margin-top: 0;
    }

    .tgRuleBox-del {
      position: absolute;
      right: 0;
      top: 8px;
      padding-left: 20px;
      display: inline-block;
      height: 16px;
      line-height: 16px;
      background: url(http://pic.lvmama.com/img/backstage/vst/del.png) no-repeat;
      color: #29e;
      font-size: 14px;
      cursor: pointer;
    }
  </style>
</head>
<body>
<div class="iframe_header">
  <ul class="iframe_nav">
    <li><a href="#">金融</a> &gt;</li>
    <li><a href="#">产品维护</a> &gt;</li>
    <li class="active">添加产品</li>
  </ul>
</div>
<div class="iframe_content mt10">
  <div class="tiptext tip-warning"><span class="tip-icon tip-icon-warning"></span>注：产品创建后，不能变更所属的品类</div>
  <form action="/vst_admin/finance/product/updateProduct.do" method="post" id="dataForm">
    <input type="hidden" name="senisitiveFlag" value="N">
    <input type="hidden" id="userName" value="${userName}">
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
            <td class="e_label" width="150"><i class="cc1">*</i>产品ID：</td>
            <td>
              <input type="text" id="productId" name="productId" readonly value="${prodProduct.productId}">
            </td>
          </tr>
          <tr>
            <td class="e_label"><i class="cc1">*</i>产品名称：</td>
            <td><label><input type="text" class="w35" style="width:700px" name="productName" id="productName"
                              value="${prodProduct.productName}" required="true" maxlength="70">&nbsp;<span
              style="color:grey">2~140个字符，请勿使用下列字符，如“《》！@*”</span></label>
              <div id="productNameError"></div>
            </td>
          </tr>
          <tr>
            <td class="e_label"><i class="cc1">*</i>推荐级别：</td>
            <td>
              <label><select name="recommendLevel" required>
                <option value="5" <#if prodProduct.recommendLevel == '5'>selected</#if> >5</option>
                <option value="4" <#if prodProduct.recommendLevel == '4'>selected</#if> >4</option>
                <option value="3" <#if prodProduct.recommendLevel == '3'>selected</#if> >3</option>
                <option value="2" <#if prodProduct.recommendLevel == '2'>selected</#if> >2</option>
                <option value="1" <#if prodProduct.recommendLevel == '1'>selected</#if> >1</option>
              </select></label>
            </td>
          </tr>
          <tr id="buTr">
            <td class="e_label"><i class="cc1">*</i>BU：</td>
            <td colspan="2">
              <select name="bu" id="bu" required="required">
			    	<option value="">请选择</option>
			    	<#list buList as list>
                         <option value=${list.code!''} <#if prodProduct.bu == list.code>selected</#if> >${list.cnName!''}</option>
                    </#list>
			   </select>
            </td>
          </tr>
          <tr>
            <td class="e_label"><i class="cc1">*</i>内容维护人员：</td>
            <td>
              <input type="text" class="w35 searchInput" name="managerName" id="managerName" required value="${prodProduct.managerName}"/>
              <input type="hidden" name="managerId" id="managerId" value="${prodProduct.managerId }"/>
              <ul class="jsonSuggest ui-autocomplete ui-menu ui-widget ui-widget-content ui-corner-all" role="listbox"
                  style="top: 485px; left: 175px; width: 364px; z-index: 999; height: auto; display: none;"></ul>
              <input type="hidden" name="managerId" id="managerId" required="" value="5167">
              <span id="tips" style="display:none; color:red;">注：该处信息仅供参考，如需修改请至商品基础设置下进行维护</span>
              <div id="managerNameError"></div>
            </td>
          </tr>
          
<#assign bizCatePropGroup=bizCatePropGroupList />
<#assign bizCategoryProp=bizCatePropGroup[0].bizCategoryPropList />
          <tr>
            <td class="e_label">产品有效期：</td>
            <td>
              	<input type="text" name="prodProductPropList[0].propValue" value="${propMap['prod_effect_start_date']!''}" errorele="selectDate" class="Wdate" id="d4321"
                     onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss',readOnly:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'d4322\',{d:0});}'})">
              	<#if (prodPropMap['1330'])??>
              		<input type="hidden" name="prodProductPropList[0].prodPropId" value="${prodPropMap['1330'].prodPropId!''}" />
              	</#if>
              	<input type="hidden" name="prodProductPropList[0].propId" value="${bizCategoryProp[0].propId!''}"/>
                <input type="hidden" name="prodProductPropList[0].bizCategoryProp.propCode" value="${bizCategoryProp[0].propCode!''}"/>
              <span>-</span>
              	<input type="text" name="prodProductPropList[1].propValue" value="${propMap['prod_effect_end_date']!''}" errorele="selectDate" class="Wdate" id="d4322"
                     onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'d4321\',{y:20});}',readOnly:true,minDate:'#F{$dp.$D(\'d4321\',{d:0});}'})">
                <#if (prodPropMap['1331'])??>
                	<input type="hidden" name="prodProductPropList[1].prodPropId" value="${prodPropMap['1331'].prodPropId!''}" />
                </#if>
                <input type="hidden" name="prodProductPropList[1].propId" value="${bizCategoryProp[1].propId!''}"/>
                <input type="hidden" name="prodProductPropList[1].bizCategoryProp.propCode" value="${bizCategoryProp[1].propCode!''}"/>
            </td>
          </tr>
          <tr>
            <td class="e_label">销售有效期：</td>
            <td>
              <input type="text" name="prodProductPropList[2].propValue" value="${propMap['sale_effect_start_date']!''}" errorele="selectDate" class="Wdate" id="d4323"
                     onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss',readOnly:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'d4324\',{d:0});}'})">
           		<#if (prodPropMap['1332'])??>
           			<input type="hidden" name="prodProductPropList[2].prodPropId" value="${prodPropMap['1332'].prodPropId!''}" />
           		</#if>
           		<input type="hidden" name="prodProductPropList[2].propId" value="${bizCategoryProp[2].propId!''}"/>
                <input type="hidden" name="prodProductPropList[2].bizCategoryProp.propCode" value="${bizCategoryProp[2].propCode!''}"/>
              <span>-</span>
              <input type="text" name="prodProductPropList[3].propValue" value="${propMap['sale_effect_end_date']!''}" errorele="selectDate" class="Wdate" id="d4324"
                     onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'d4323\',{y:20});}',readOnly:true,minDate:'#F{$dp.$D(\'d4323\',{d:0});}'})">
            	<#if (prodPropMap['1333'])??>
            		<input type="hidden" name="prodProductPropList[3].prodPropId" value="${prodPropMap['1333'].prodPropId!''}" />
            	</#if>
            	<input type="hidden" name="prodProductPropList[3].propId" value="${bizCategoryProp[3].propId!''}"/>
                <input type="hidden" name="prodProductPropList[3].bizCategoryProp.propCode" value="${bizCategoryProp[3].propCode!''}"/>
            </td>
          </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div class="p_box box_info p_line">
      <table class="e_table form-inline">
        <tbody>
        <tr>
          <td class="e_label" width="150"><i class="cc1">*</i>项目简介：</td>
          <td>
            <textarea class="w35 textWidth" style="width:700px; height:50px;" required="" 
                      name="prodProductPropList[4].propValue" maxlength="400">${propMap['prod_description']!''}</textarea>
                <#if (prodPropMap['1334'])??>
          			<input type="hidden" name="prodProductPropList[4].prodPropId" value="${prodPropMap['1334'].prodPropId!''}" />
          		</#if>
          		<input type="hidden" name="prodProductPropList[4].propId" value="${bizCategoryProp[4].propId!''}"/>
                <input type="hidden" name="prodProductPropList[4].bizCategoryProp.propCode" value="${bizCategoryProp[4].propCode!''}"/>
            <span style="color:grey">请输入10-400个字符</span>
            <div id="productDesError"></div>
          </td>
        </tr>
        <tr>
          <td class="e_label" width="150">重要提示：</td>
          <td>
            <textarea class="w35 textWidth" name="prodProductPropList[5].propValue" 
            	 	style="width:700px; height:50px;" maxlength="400">${propMap['important_notices']!''}</textarea>
            	<#if (prodPropMap['1335'])??>
            		<input type="hidden" name="prodProductPropList[5].prodPropId" value="${prodPropMap['1335'].prodPropId!''}" />
            	</#if>
            	<input type="hidden" name="prodProductPropList[5].propId" value="${bizCategoryProp[5].propId!''}"/>
                <input type="hidden" name="prodProductPropList[5].bizCategoryProp.propCode" value="${bizCategoryProp[5].propCode!''}"/>
            <span style="color:grey">请输入10-400个字符</span>
          </td>
        </tr>
        </tbody>
      </table>
    </div>

    <div class="p_box box_info p_line">
      <table class="e_table form-inline">
        <tbody>
        <tr>
          <td class="e_label" width="150">预订须知：</td>
          <td>
            <textarea class="w35 textWidth" name="prodProductPropList[6].propValue" 
            		style="width:700px; height:50px;" maxlength="2000">${propMap['book_notices']!''}</textarea>
            	<#if (prodPropMap['1336'])??>
            		<input type="hidden" name="prodProductPropList[6].prodPropId" value="${prodPropMap['1336'].prodPropId!''}" />
            	</#if>
            	<input type="hidden" name="prodProductPropList[6].propId" value="${bizCategoryProp[6].propId!''}"/>
                <input type="hidden" name="prodProductPropList[6].bizCategoryProp.propCode" value="${bizCategoryProp[6].propCode!''}"/>
            <span style="color:grey">请输入10-2000个字符</span>
          </td>
        </tr>        
        
        <tr>
          <td class="e_label"><i class="cc1">*</i>退改说明：</td>
          <td>          	
            <label><input type="hidden" required="" name="cancelStrategy" value="MANUALCHANGE"> 人工退改</label>
            <input type="hidden" name="ruleId" value="${ruleId!''}">
            <br/>
            <div class="js_rgtgInput" style="display: inline-block;">
              <textarea class="w35 textWidth" name="ruleContent" required="" style="width:700px; height:50px;">${ruleContent!''}</textarea>
              <span style="color: grey">请输入2-3000个字符</span>
              <p id="tgRgtgError"></p>
            </div>
            <div class="errorBox" id="tgTypeError"></div>
            <!--
            <div class="tgRuleBox firstTgRuleBox">
              <label><input type="radio" required="" name="cancelStrategy" value="RETREATANDCHANGE"></label> 自支付日
              <select class="js_ruleSelect" name="prodRefundRuleList[0].ruleType" style="width: 100px;">
                <option value="">请选择</option>
                <option value="LESSEQ">小于等于</option>
                <option value="BETWEEN">介于</option>
                <option value="GREATEREQ">大于等于</option>
              </select>
              <input type="text" style="width: 50px;" class="js_tgStart" name="prodRefundRuleList[0].startDays" placeholder="含"
                     maxlength="4"><span class="js_tgBeside" style="display: none"> 至 <input type="text"
                                                                                             class="js_tgEnd"
                                                                                             name="prodRefundRuleList[0].endDays"
                                                                                             required=""
                                                                                             style="width: 50px;"
                                                                                             placeholder="含"
                                                                                             maxlength="4"></span>
              日发起退款，
              <label><input type="radio" class="js_tgRadio" name="prodRefundRuleList[0].returnFlag" value="Y"> 是</label>
              <label><input type="radio" class="js_tgRadio" name="prodRefundRuleList[0].returnFlag" value="N"> 否</label>
              需要退还权益金
              <div class="tgQyjType-ins">
                <h4>支付方式：现金付款</h4>
                <p class="js_tgQyjType_y">已消费的部分需要从消费金中扣除，如消费金不足抵扣已消费的金额，需要使用现金补齐</p>
                <p class="js_tgQyjType_n">1、权益金不可退 <br>2、用户未使用，则直接退款消费金。已使用消费金的，扣除已使用部分，剩余部分做退款处理。</p>
                <h4>支付方式：信贷付款</h4>
                <p class="js_tgQyjType_y">已消费的部分需使用现金补齐，未使用部分退还银行。</p>
                <p class="js_tgQyjType_n">1、权益金不可退 <br>2、用户未使用，则直接退还银行。已使用消费金部分，需用户先还款，消费金由驴妈妈退还银行。</p>
              </div>
              <span class="tgQyjTypeError"></span>
            </div>

            <div class="errorBox" id="tgTypeError"></div>

            <a href="javascript:" class="btn btn-addNewRule js_addNewRule">+新增规则</a>
            -->
          </td>
        </tr>
        
        <tr>
          <td class="e_label">客户服务：</td>
          <td>
            <textarea class="w35 textWidth" name="prodProductPropList[7].propValue"  
            		style="width:700px; height:50px;" maxlength="2000">${propMap['custom_service']!''}</textarea>
            	<#if (prodPropMap['1337'])??>
            	<input type="hidden" name="prodProductPropList[7].prodPropId" value="${prodPropMap['1337'].prodPropId!''}" />
            	</#if>
            	<input type="hidden" name="prodProductPropList[7].propId" value="${bizCategoryProp[7].propId!''}"/>
                <input type="hidden" name="prodProductPropList[7].bizCategoryProp.propCode" value="${bizCategoryProp[7].propCode!''}"/>
          </td>
        </tr>
        </tbody>
      </table>
    </div>


    <div class="p_box box_info">
    </div>
  </form>
</div>
<div class="fl operate" style="margin:20px;"><a class="btn btn_cc1" id="save">保存</a><a class="btn btn_cc1"
                                                                                       id="saveAndNext">保存并维护下一步</a>
</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
    var loading;

    //JQuery 自定义验证
    jQuery.validator.addMethod("isCharCheck", function (value, element) {
        var chars = /^([\u4e00-\u9fa5]|[a-zA-Z0-9]|[\+-]|[\u0020])+$/;//验证特殊字符
        return this.optional(element) || (chars.test(value));
    }, "不可为空或者特殊字符");

    // 中文字两个字节
    jQuery.validator.addMethod("byteRangeLength", function (value, element, param) {
        var length = value.length;
        for (var i = 0; i < value.length; i++) {
            if (value.charCodeAt(i) > 127) {
                length++;
            }
        }
        return this.optional(element) || ( length >= param[0] && length <= param[1] );
    }, $.validator.format("请确保输入的值在{0}-{1}个字节之间(一个中文字算2个字节)"));
    
    vst_pet_util.superUserSuggest("#managerName", "input[name=managerId]");

    //退改说明
    var $document = $(document);
    var oDAddNewProduct = {
        rgtgInput: $('.js_rgtgInput'), // 退改选项
        tgBeside: $('.firstTgRuleBox .js_tgBeside'), // 第一个介与
        tgSelect: $('.firstTgRuleBox .js_tgSelect'), // 第一个自支付日选择
        tgQyjType: $('input[name=tgQyjType]'), // 是否需要退还权益金
        tgQyjTypeIns: $('.tgQyjType-ins'), // 是否需要退还权益金说明
        //tgQyjTypeY: $('.js_tgQyjType_y'),
        //tgQyjTypeN: $('.js_tgQyjType_n'),
        tgSelectStart: $('input[name=tgSelectStart]'),
        tgSelectEnd: $('input[name=tgSelectEnd]'),
        addNewRule: $('.js_addNewRule'),
        nTgRule: 0, //退改规则
        pendRuleHtml: [
            '<div class="tgJgWrap tgRuleBox">',
            '<span class="tgRuleBox-del">删除</span>',
            '	 自支付日 <select class="js_ruleSelect" name="prodRefundRuleList[1].ruleType" style="width: 100px;">',
            '		<option value="">请选择</option>',
            '		<option value="LESSEQ">小于等于</option>',
            '		<option value="BETWEEN">介于</option>',
            '		<option value="GREATEREQ">大于等于</option></select>',
            '	<input type="text" style="width: 50px;" class="js_tgStart" name="prodRefundRuleList[1].startDays" placeholder="含" maxlength="4">',
            '	<span class="js_tgBeside" style="display: none">至',
            '		<input type="text" name="prodRefundRuleList[1].endDays" class="js_tgEnd" style="width: 50px;" placeholder="含" maxlength="4"></span>日发起退款，',
            '	<label>',
            '		<input type="radio" class="js_tgRadio" name="prodRefundRuleList[1].returnFlag" value="Y"> 是</label>',
            '	<label>',
            '		<input type="radio" class="js_tgRadio" name="prodRefundRuleList[1].returnFlag" value="N"> 否</label> 需要退还权益金',
            '	<div class="tgQyjType-ins">',
            '		<h4>支付方式：现金付款</h4>',
            '		<p class="js_tgQyjType_y">已消费的部分需要从消费金中扣除，如消费金不足抵扣已消费的金额，需要使用现金补齐</p>',
            '		<p class="js_tgQyjType_n">1、权益金不可退',
            '			<br>2、用户未使用，则直接退款消费金。已使用消费金的，扣除已使用部分，剩余部分做退款处理。</p>',
            '		<h4>支付方式：信贷付款</h4>',
            '		<p class="js_tgQyjType_y">已消费的部分需使用现金补齐，未使用部分退还银行。</p>',
            '		<p class="js_tgQyjType_n">1、权益金不可退',
            '			<br>2、用户未使用，则直接退还银行。已使用消费金部分，需用户先还款，消费金由驴妈妈退还银行。</p></div>',
            '	<span class="tgQyjTypeError"></span>',
            '</div>'
        ].join("")
    }

    //验证规则
    var fomeRules = {
        rules: {
            productName: {
            	required: true,
                isCharCheck: true,
                byteRangeLength: [2, 140],
            },
            'prodProductPropList[4].propValue': {
            	required: true,
                byteRangeLength: [10, 400],
            },
            'prodProductPropList[5].propValue': {
                byteRangeLength: [10, 400],
            },
            'prodProductPropList[6].propValue': {
                byteRangeLength: [10, 2000],
            },
            ruleContent: {
                required: true,
                byteRangeLength: [2, 3000],
            }
        },
        messages: {
            productName: '请输入2~140个字符且不可为空或者特殊字符',
            'prodProductPropList[4].propValue': '请输入10-400个字符',
            'prodProductPropList[5].propValue': '请输入10-400个字符',
            'prodProductPropList[6].propValue': '请输入10-2000个字符',
            ruleContent: '请输入2~3000个字符',
            tgType: '请选择退改说明',
            returnFlag: '请选择需要退还权益金',
            tgSelectEnd: '请选择需要退还权益金',
        }
    };

    $document.on('change', "input[name=tgType]", function () {
        if ($(this).val() == 'Y') {
            // 人工退改
            oDAddNewProduct.rgtgInput.show();
            // oDAddNewProduct.tgQyjType.removeAttr('required');
            // oDAddNewProduct.tgSelect.removeAttr('required');
            // oDAddNewProduct.tgSelectStart.removeAttr('required');
            oDAddNewProduct.addNewRule.hide();
        } else {

            oDAddNewProduct.rgtgInput.hide();
            // oDAddNewProduct.returnFlag.attr('required',true);
            // oDAddNewProduct.tgSelect.attr('required',true);
            // oDAddNewProduct.tgSelectStart.attr('required',true);
            oDAddNewProduct.addNewRule.css('display', 'inline-block');
        }
    });
    $document.on('change', '.js_ruleSelect', function () {
        var $this = $(this),
            $tgBeside = $this.siblings('.js_tgBeside');
        $this.val() == '介于' ? $tgBeside.show() : $tgBeside.hide();
    });
    $document.on('change', '.js_tgRadio', function () {
        var $this = $(this),
            $tgQyjTypeIns = $(this).parent().siblings('.tgQyjType-ins'),
            $tgQyjTypeY = $tgQyjTypeIns.find('.js_tgQyjType_y'),
            $tgQyjTypeN = $tgQyjTypeIns.find('.js_tgQyjType_n');
        $tgQyjTypeIns.show();
        if ($(this).val() == 'Y') {
            $tgQyjTypeY.show();
            $tgQyjTypeN.hide();
        } else {
            $tgQyjTypeY.hide();
            $tgQyjTypeN.show();
        }
    });

    // 退改规则新增检验
    function tgRuleErrorNum() {
        if ($('input[name=tgType]:checked').val() == 'Y') {
            return false;
        }
        oDAddNewProduct.nTgRule = 0;
        $('.tgRuleBox').each(function () {
            var $tgRuleBox = $(this);
            if (!$tgRuleBox.find('.js_ruleSelect').val() || !$tgRuleBox.find('.js_tgStart').val().replace(/^\s+|\s+$/g,"") || !$tgRuleBox.find('.js_tgRadio:checked').val()) {
                $.msg("请填写完整的退改信息", 2000);
                oDAddNewProduct.nTgRule++;
                return false;
            } else if (!$tgRuleBox.find('.js_ruleSelect').val() == '介于' && !$tgRuleBox.find('.js_tgEnd').replace(/^\s+|\s+$/g,"").val()) {
                $.msg("请填写完整的退改信息", 2000);
                oDAddNewProduct.nTgRule++;
                return false;
            }
        });
        return oDAddNewProduct.nTgRule;
    }

    //新增规则
    $('.js_addNewRule').on('click', function (event) {
        tgRuleErrorNum();
        if (oDAddNewProduct.nTgRule > 0) {
            return false;
        }
		//$(#refundIndex).val(index);
        var idlen = $('.tgJgWrap').length + 1,
            newHtml = oDAddNewProduct.pendRuleHtml;
        newHtml = newHtml.replace(/tgSelect"/mg, 'tgJgWrap' + idlen + '"');
        newHtml = newHtml.replace(/tgSelectStart/mg, 'tgSelectStart' + idlen);
        newHtml = newHtml.replace(/tgSelectEnd/mg, 'tgSelectEnd' + idlen);
        newHtml = newHtml.replace(/tgQyjType"/mg, 'tgQyjType' + idlen + '"');
        $(this).before(newHtml);
    });

    //删除规则
    $document.on('click', '.tgRuleBox-del', function () {
        $(this).parents('.tgJgWrap').remove();
    });


    $("#save").click(function () {
        $.each($("input[autoValue='true']"), function (i, n) {
            if ($(n).val() == "") {
                $(n).val($(n).attr('placeholder'));
            }
        });

        if (!$("#dataForm").validate(fomeRules).form()) {
            return false;
        }
        // 检验新增规则是否填全
        if (tgRuleErrorNum() > 0) {
            return false;
        }
        
        var msg = '确认保存吗 ？';
        if(refreshSensitiveWord($("input[type='text'],textarea"))){
            $("input[name=senisitiveFlag]").val("Y");
            msg = '内容含有敏感词,是否继续?'
        }else {
            $("input[name=senisitiveFlag]").val("N");
        }
        $.confirm(msg,function(){
        	//遮罩层
            loading = pandora.loading("正在努力保存中...");
            $.ajax({
                url: "/vst_admin/finance/prod/product/updateProduct.do",
                type: "post",
                dataType: 'json',
                data: $("#dataForm").serialize(),
                success: function (result) {
                    loading.close();
                    if (result.code == "success") {
                        //为子窗口设置productId
                        $("input[name='productId']").val(result.attributes.productId);
                        //为父窗口设置productId
                        $("#productId", window.parent.document).val(result.attributes.productId);
                        $("#productName", window.parent.document).val(result.attributes.productName);
                        $("#categoryName", window.parent.document).val(result.attributes.categoryName);
                        
                        pandora.dialog({wrapClass: "dialog-mini", content:result.message, mask:true,okValue:"确定",ok:function(){
                            parent.checkAndJump();
                            if(parent.refreshProdFundLabel) {
                                parent.refreshProdFundLabel();
                            }

                        }});
                    } else {
                        loading.close();
                        $.alert(result.message);
                        $("#save").show();
                        $("#saveAndNext").show();
                    }
                },
                error: function () {
                    loading.close();
                    $("#save").show();
                    $("#saveAndNext").show();
                }
            });
        }, function () {
            $("#save").show();
            $("#saveAndNext").show();
        });

    });

    $("#saveAndNext").click(function () {
        $.each($("input[autoValue='true']"), function (i, n) {
            if ($(n).val() == "") {
                $(n).val($(n).attr('placeholder'));
            }
        });

        if (!$("#dataForm").validate(fomeRules).form()) {
            return false;
        }
        // 检验新增规则是否填全
        if (tgRuleErrorNum() > 0) {
            return false;
        }
        
        var msg = '确认保存吗 ？';
        if(refreshSensitiveWord($("input[type='text'],textarea"))){
            $("input[name=senisitiveFlag]").val("Y");
            msg = '内容含有敏感词,是否继续?'
        }else {
            $("input[name=senisitiveFlag]").val("N");
        }
        $.confirm(msg, function () {
            //遮罩层
            loading = top.pandora.loading("正在努力保存中...");
            $.ajax({
                url: "/vst_admin/finance/prod/product/updateProduct.do",
                type: "post",
                dataType: 'json',
                data: $("#dataForm").serialize(),
                success: function (result) {
                    loading.close();
                    if (result.code == "success") {
                        //为子窗口设置productId
                        $("input[name='productId']").val(result.attributes.productId);
                        //为父窗口设置productId
                        $("#productId", window.parent.document).val(result.attributes.productId);
                        $("#productName", window.parent.document).val(result.attributes.productName);
                        $("#categoryName", window.parent.document).val(result.attributes.categoryName);

                        pandora.dialog({
                            wrapClass: "dialog-mini", content: result.message, okValue: "确定", ok: function () {
                                var categoryId = $("#categoryId").val();
                                var productId = result.attributes.productId;
                                window.location = "/vst_admin/pub/comphoto/findComPhotoList.do?objectId="+productId+"&parentId="+productId+"&objectType=PRODUCT_ID&logType=PROD_PRODUCT_PRODUCT_CHANGE&imgLimitType=LIMIT_3_2_3L";
                                $("#showPhoto",parent.document).parent("li").trigger("click");
                            }
                        });
                        var categoryName = result.attributes.categoryName;
                        $(".pg_title", parent.document).html("修改产品" + "&nbsp;&nbsp;&nbsp;&nbsp;" + "产品名称：" + $("input[name='productName']").val() + "   " + "品类:" + categoryName + "   " + "产品ID：" + $("input[name='productId']").val());
                    } else {
                        loading.close();
                        $.alert(result.message);
                        $("#save").show();
                        $("#saveAndNext").show();
                    }
                },
                error: function () {
                    loading.close();
                    $("#save").show();
                    $("#saveAndNext").show();
                }
            });
        }, function () {
            $("#save").show();
            $("#saveAndNext").show();
        });
    });

</script>