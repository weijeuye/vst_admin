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
    <li><a href="#">超级会员</a> &gt;</li>
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
                              value="${prodProduct.productName}" required="true" maxlength="50">&nbsp;<span
              style="color:grey">2~50个字符，请勿使用下列字符，如“《》！@*”</span></label>
              <div id="productNameError"></div>
            </td>
          </tr>
          
          
<#assign bizCatePropGroup=bizCatePropGroupList />
<#assign bizCategoryProp=bizCatePropGroup[0].bizCategoryPropList />
          <tr>
          	<td class="e_label" width="150"><i class="cc1">*</i>产品说明：</td>
          	<td>
            	<textarea class="w35 textWidth" style="width:700px; height:100px;" required="" 
                      name="prodProductPropList[0].propValue" maxlength="500">${propMap['prod_description']!''}</textarea>
                <#if (prodPropMap['1350'])??>
          			<input type="hidden" name="prodProductPropList[0].prodPropId" value="${prodPropMap['1350'].prodPropId!''}" />
          		</#if>
          		<input type="hidden" name="prodProductPropList[0].propId" value="${bizCategoryProp[0].propId!''}"/>
                <input type="hidden" name="prodProductPropList[0].bizCategoryProp.propCode" value="${bizCategoryProp[0].propCode!''}"/>
            	<span style="color:grey">请输入10-500个字符</span>
            	<div id="productDesError"></div>
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

    //验证规则
    var fomeRules = {
        rules: {
            productName: {
            	required: true,
                isCharCheck: true,
                byteRangeLength: [2, 100],
            },
            'prodProductPropList[0].propValue': {
            	required: true,
                byteRangeLength: [10, 1000],
            }
        },
        messages: {
            productName: '请输入2~50个字符且不可为空或者特殊字符',
            'prodProductPropList[0].propValue': '请输入10-500个字符',
        }
    };

    $("#save").click(function () {
        $.each($("input[autoValue='true']"), function (i, n) {
            if ($(n).val() == "") {
                $(n).val($(n).attr('placeholder'));
            }
        });

        if (!$("#dataForm").validate(fomeRules).form()) {
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
                url: "/vst_admin/supermember/prod/product/updateProduct.do",
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
                url: "/vst_admin/supermember/prod/product/updateProduct.do",
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
                                window.location = "/vst_admin/pub/comphoto/findComPhotoList.do?objectId="+productId+"&parentId="+productId+"&objectType=PRODUCT_ID&logType=PROD_PRODUCT_PRODUCT_CHANGE";
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