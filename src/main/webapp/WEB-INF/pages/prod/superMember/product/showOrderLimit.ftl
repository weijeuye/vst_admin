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
    <li><a href="#">超级会员</a> &gt;</li>
    <li><a href="#">销售设置</a> &gt;</li>
    <li class="active">预定设置</li>
  </ul>
</div>
<div class="iframe_content mt10">
  <div class="tiptext tip-warning"><span class="tip-icon tip-icon-warning"></span>注：产品创建后，不能变更所属的品类</div>
  <form action="/vst_admin/supermember/prod/product/saveOrderLimit.do" method="post" id="dataForm">
    <input type="hidden" name="productId" value="${prodProduct.productId}">
    <input type="hidden" id="categoryId" name="bizCategoryId" value="${bizCategory.categoryId}" required>
    <input type="hidden" id="categoryName" name="bizCategory.categoryName" value="${bizCategory.categoryName}" >
    <input type="hidden" name="senisitiveFlag" value="N">
    <div class="p_box box_info p_line">
      <div class="box_content">
        <table class="e_table form-inline">
          <tbody>          
<#assign bizCategoryProp=bizCategoryPropList />
      <tr>
      	<td class="e_label" width="150"><i class="cc1">*</i>限制：</td>
      	<td>
      		<input type="radio" value="N" name="prodProductPropList[0].propValue" required
      			<#if (prodPropMap['1359'])?? && prodPropMap['1359'].propValue =='N'>checked</#if> />不限<span></span>
      		<input type="radio" value="Y" name="prodProductPropList[0].propValue" required
      			<#if (prodPropMap['1359'])?? && prodPropMap['1359'].propValue =='Y'> checked</#if> />限制设置
      		<div id="limitError" style="display:none"><i for="prodProductPropList[0].propValue]" class="error">请设置</i></div>	
      		<input type="hidden" name="prodProductPropList[0].propId" value="${bizCategoryProp[0].propId!''}"/>
            <input type="hidden" name="prodProductPropList[0].bizCategoryProp.propCode" value="${bizCategoryProp[0].propCode!''}"/>
            <#if (prodPropMap['1359'])??>          		
				<input type="hidden" name="prodProductPropList[0].prodPropId" value="${prodPropMap['1359'].prodPropId!''}" />
          	</#if>
      	</td>
      </tr>
	  
	  <tr>
      	<td class="e_label" width="150">预定限制</td>
      	<td></td>
      </tr>
      
      <tr>
      	<td class="e_label" width="150">限制时间：</td>
        <td>          
          	<input type="text" name="prodProductPropList[1].propValue" onkeyup="validateNumber(this)"
          		<#if (prodPropMap['1360'])??>value="${prodPropMap['1360'].propValue!''}"</#if> maxlength="4"/>
          	<input type="hidden" name="prodProductPropList[1].propId" value="${bizCategoryProp[1].propId!''}"/>
          	<input type="hidden" name="prodProductPropList[1].bizCategoryProp.propCode" value="${bizCategoryProp[1].propCode!''}"/>
          	<select name="prodProductPropList[1].addValue">
          		<option value="">--请选择--</option>
          		<option value="day" <#if (prodPropMap['1360'])?? && prodPropMap['1360'].addValue =='day'>selected</#if> >天</option>
          		<option value="month" <#if (prodPropMap['1360'])?? && prodPropMap['1360'].addValue =='month'>selected</#if> >月</option>
          		<option value="year" <#if (prodPropMap['1360'])?? && prodPropMap['1360'].addValue =='year'>selected</#if> >年</option>
           	</select>
           	<#if (prodPropMap['1360'])??>          		
				<input type="hidden" name="prodProductPropList[1].prodPropId" value="${prodPropMap['1360'].prodPropId!''}" />
          	</#if>
      	</td>
      </tr>
      
      <tr>
      	<td class="e_label" width="150">限制维度：</td>
        <td>        
          	<label><input type="checkbox" name="prodProductPropList[2].propValue" 
          	 	<#if (prodPropMap['1361'])?? && (prodPropMap['1361'].propValue)?? && prodPropMap['1361'].propValue?contains("memberid")>checked="checked"</#if>
          	 	 value="memberid">会员ID</label>
        	<label><input type="checkbox" name="prodProductPropList[2].propValue" 
        	 	<#if (prodPropMap['1361'])?? && (prodPropMap['1361'].propValue)?? && prodPropMap['1361'].propValue?contains("phone")>checked="checked"</#if> 
        	 	 value="phone">手机号</label>
        	<div class="errorBox" id="prodProductPropList[2].propValueError"></div>
        	<input type="hidden" name="prodProductPropList[2].propId" value="${bizCategoryProp[2].propId!''}"/>
          	<input type="hidden" name="prodProductPropList[2].bizCategoryProp.propCode" value="${bizCategoryProp[2].propCode!''}"/>
          	<#if (prodPropMap['1361'])??>          		
				<input type="hidden" name="prodProductPropList[2].prodPropId" value="${prodPropMap['1361'].prodPropId!''}" />
          	</#if>
      	</td>
      </tr>
      
      <tr>
      	<td class="e_label" width="150">限制购买数量：</td>
        <td>          
          	<input type="text" name="prodProductPropList[3].propValue" onkeyup="validateNumber(this)"
          		<#if (prodPropMap['1362'])??>value="${prodPropMap['1362'].propValue!''}"</#if>  maxlength="4"/> <span>份</span>
          	<input type="hidden" name="prodProductPropList[3].propId" value="${bizCategoryProp[3].propId!''}"/>
          	<input type="hidden" name="prodProductPropList[3].bizCategoryProp.propCode" value="${bizCategoryProp[3].propCode!''}"/>
          	<#if (prodPropMap['1362'])??>          		
				<input type="hidden" name="prodProductPropList[3].prodPropId" value="${prodPropMap['1362'].prodPropId!''}" />
          	</#if>
      	</td>
      </tr>
          
          </tbody>
        </table>
      </div>
    </div>
    
    <div class="p_box box_info">
    </div>
  </form>
</div>
<div class="fl operate" style="margin:20px;"><a class="btn btn_cc1" id="save">保存</a></div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
	//JQuery 自定义验证
    jQuery.validator.addMethod("isCharCheck", function (value, element) {
        var chars = /^([\u4e00-\u9fa5]|[a-zA-Z0-9]|[\+-]|[\u0020])+$/;//验证特殊字符
        return this.optional(element) || (chars.test(value));
    }, "不可为空或者特殊字符");    
    
    /**
     * 验证是否为数字
     */
    function validateNumber(e) {
        var reg = /^[0-9]+.?[0-9]*$/;
        var value = $(e).val();
        if (!reg.test(value)) {
            alert("输入有误，只能输入数字!");
            $(e).val("");
        }
    }
    
    $(document).ready(function() {
    	//初始化,"限制"的置灰
    	var limitValue = $('input[type=radio][name=prodProductPropList[0].propValue]:checked').val();
    	if (limitValue == 'N') {
            $('input[type=text][name="prodProductPropList[1].propValue"]').prop({'disabled':true,'value':''});
            $('[name="prodProductPropList[1].addValue"]').prop({'disabled':true,'value':''});
            $('input[type=checkbox][name="prodProductPropList[2].propValue"]').prop({'disabled':true,'checked':false});
            $('input[type=text][name="prodProductPropList[3].propValue"]').prop({'disabled':true,'value':''});
        }
        //"限制"的change事件
    	$('input[type=radio][name=prodProductPropList[0].propValue]').change(function() {
    		$("#limitError").css({"display":"none"});
    		setLimit(this.value); 
    	});
	});
	
	//"限制"的change事件,置灰
	function setLimit(limitValue){
    	if (limitValue == 'N') {
            $('input[type=text][name="prodProductPropList[1].propValue"]').prop({'disabled':true,'value':''});
            $('[name="prodProductPropList[1].addValue"]').prop({'disabled':true,'value':''});
            $('input[type=checkbox][name="prodProductPropList[2].propValue"]').prop({'disabled':true,'checked':false});
            $('input[type=text][name="prodProductPropList[3].propValue"]').prop({'disabled':true,'value':''});
        } else {
        	$('input[type=text][name="prodProductPropList[1].propValue"]').prop('disabled', false);
            $('[name="prodProductPropList[1].addValue"]').prop('disabled', false);
            $('input[type=checkbox][name="prodProductPropList[2].propValue"]').prop('disabled', false);
            $('input[type=text][name="prodProductPropList[3].propValue"]').prop('disabled', false);
        }
	}
	
	//验证规则
	var formRules = {
        rules: {
            'prodProductPropList[0].propValue': {
            	required: true,
            }
        },
        messages: {
            'prodProductPropList[0].propValue': '请设置',
        }
    };
	var limitFormRules = {
        rules: {
            'prodProductPropList[1].propValue': {
            	required: true,
            },
            'prodProductPropList[1].addValue': {
            	required: true,
            },
            'prodProductPropList[2].propValue': {
            	required: true,
            },
            'prodProductPropList[3].propValue': {
            	required: true,
            }
        },
        messages: {
            'prodProductPropList[1].propValue': '请输入限制时间',
            'prodProductPropList[1].addValue': '请选择时间单位',
            'prodProductPropList[2].propValue': '请选择限制维度',
            'prodProductPropList[3].propValue': '请输入限制购买数量',
        }
    };
    
	$("#save").click(function () {
        $.each($("input[autoValue='true']"), function (i, n) {
            if ($(n).val() == "") {
                $(n).val($(n).attr('placeholder'));
            }
        });        
        
        //如果选择了"限制设置",检查其他项
        var limitValue = $('input[type=radio][name=prodProductPropList[0].propValue]:checked').val();
        if(!(limitValue =='Y' || limitValue == 'N')){
        	$("#limitError").css({"display":""});
        	return false;
        }
    	if (limitValue == 'Y') {
        	if (!$("#dataForm").validate(limitFormRules).form()) {
            	return false;
        	}
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
                url: "/vst_admin/supermember/prod/product/saveOrderLimit.do",
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
                        $("#suppGoodsId", window.parent.document).val(result.attributes.suppGoodsId);
                        
                        pandora.dialog({wrapClass: "dialog-mini", content:result.message, mask:true,okValue:"确定",ok:function(){
                            ;
                        }});
                    } else {
                        loading.close();
                        $.alert(result.message);
                        $("#save").show();
                    }
                },
                error: function () {
                    loading.close();
                    $("#save").show();
                }
            });
        }, function () {
            $("#save").show();
        });

    });
</script>