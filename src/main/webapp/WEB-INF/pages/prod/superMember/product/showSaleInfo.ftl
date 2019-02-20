<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <#include "/base/head_meta.ftl"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css">
    <style>
        td {
            font-size: 13px;
            height: 45px;
        }
    </style>
</head>
<body>
<div class="iframe_header">
    <ul class="iframe_nav">
        <li><a href="#">虚拟卡-付费会员</a> &gt;</li>
        <li class="active">添加产品</li>
    </ul>
</div>
<div class="iframe_content mt10">
    <div class="tiptext tip-warning"><span class="tip-icon tip-icon-warning"></span>注：产品创建后，不能变更所属的品类</div>
    <form action="/vst_admin/superMember/prod/product/saveSaleInfo.do" method="post" id="dataForm">
        <input type="hidden" id="productId" name="productId" readonly value="${prodProduct.productId}">
        <input type="hidden" name="senisitiveFlag" value="N">
        <div class="p_box box_info p_line">
            <div class="box_content">
                <table class="e_table form-inline">
                    <tbody>
          <#assign bizCatePropGroup=bizCatePropGroupList />
          <#assign bizCategoryProp=bizCatePropGroup[0].bizCategoryPropList />
                    <tr>
                        <td class="e_label" width="200px"><i class="cc1">*</i>产品有效期设置：</td>
                    </tr>
                    <tr>
                        <td class="e_label">
                            <input type="radio" name="prodProductPropList[0].propValue"
                                   <#if propMap?? && propMap['prod_expire_date_type'] == 'AFTER_BUY_DATE'>checked</#if>
                                   value="AFTER_BUY_DATE">购买有效期
              	<#if (prodPropMap['1351'])??>
              		<input type="hidden" name="prodProductPropList[0].prodPropId"
                           value="${prodPropMap['1351'].prodPropId!''}"/>
                </#if>
                            <input type="hidden" name="prodProductPropList[0].propId"
                                   value="${bizCategoryProp[0].propId!''}"/>
                            <input type="hidden" name="prodProductPropList[0].bizCategoryProp.propCode"
                                   value="${bizCategoryProp[0].propCode!''}"/>
                        </td>
                        <td>
                            <input type="text" class="w60" value="付款成功后" disabled="disabled">
                            <span>—</span>
                            <input type="text" name="prodProductPropList[1].propValue" class="w45 validInput"
                                   value="${propMap['after_buy_expire_date_num']!''}" required>
              	<#if (prodPropMap['1352'])??>
              		<input type="hidden" name="prodProductPropList[1].prodPropId"
                           value="${prodPropMap['1352'].prodPropId!''}"/>
                </#if>
                            <input type="hidden" name="prodProductPropList[1].propId"
                                   value="${bizCategoryProp[1].propId!''}"/>
                            <input type="hidden" name="prodProductPropList[1].bizCategoryProp.propCode"
                                   value="${bizCategoryProp[1].propCode!''}"/>
                            <select name="prodProductPropList[2].propValue" style="width: 50px;" class="validInput">
                                <option value="YEAR"
                                        <#if propMap?? && propMap['after_buy_expire_date_type'] == 'YEAR'>selected</#if>>
                                    年
                                </option>
                                <option value="MONTH"
                                        <#if propMap?? && propMap['after_buy_expire_date_type'] == 'MONTH'>selected</#if>>
                                    月
                                </option>
                                <option value="DAY"
                                        <#if propMap?? && propMap['after_buy_expire_date_type'] == 'DAY'>selected</#if>>
                                    日
                                </option>
                            </select>
                <#if (prodPropMap['1353'])??>
                	<input type="hidden" name="prodProductPropList[2].prodPropId"
                           value="${prodPropMap['1353'].prodPropId!''}"/>
                </#if>
                            <input type="hidden" name="prodProductPropList[2].propId"
                                   value="${bizCategoryProp[2].propId!''}"/>
                            <input type="hidden" name="prodProductPropList[2].bizCategoryProp.propCode"
                                   value="${bizCategoryProp[2].propCode!''}"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label">
                            <input type="radio" name="prodProductPropList[0].propValue"
                                   <#if propMap?? && propMap['prod_expire_date_type'] == 'DESIGNATED_DATE'>checked</#if>
                                   value="DESIGNATED_DATE">指定有效期
                        </td>
                        <td>
                            <input type="text" name="prodProductPropList[3].propValue" required
                                   value="${propMap['designated_expire_start_date']!''}" errorele="selectDate"
                                   class="Wdate validInput"
                                   id="d4321"
                                   onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss',readOnly:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'d4322\',{d:0});}'})">
              	<#if (prodPropMap['1354'])??>
              		<input type="hidden" name="prodProductPropList[3].prodPropId"
                           value="${prodPropMap['1354'].prodPropId!''}"/>
                </#if>
                            <input type="hidden" name="prodProductPropList[3].propId"
                                   value="${bizCategoryProp[3].propId!''}"/>
                            <input type="hidden" name="prodProductPropList[3].bizCategoryProp.propCode"
                                   value="${bizCategoryProp[3].propCode!''}"/>
                            <span>-</span>
                            <input type="text" name="prodProductPropList[4].propValue" required
                                   value="${propMap['designated_expire_end_date']!''}" errorele="selectDate"
                                   class="Wdate validInput"
                                   id="d4322"
                                   onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'d4321\',{y:20});}',readOnly:true,minDate:'#F{$dp.$D(\'d4321\',{d:0});}'})">
                <#if (prodPropMap['1355'])??>
                	<input type="hidden" name="prodProductPropList[4].prodPropId"
                           value="${prodPropMap['1355'].prodPropId!''}"/>
                </#if>
                            <input type="hidden" name="prodProductPropList[4].propId"
                                   value="${bizCategoryProp[4].propId!''}"/>
                            <input type="hidden" name="prodProductPropList[4].bizCategoryProp.propCode"
                                   value="${bizCategoryProp[4].propCode!''}"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label"><i class="cc1">*</i>销售有效期设置：</td>
                    </tr>
                    <tr>
                        <td colspan="2" style="padding-left: 130px">
                            <input type="text" name="prodProductPropList[5].propValue" required
                                   value="${propMap['sale_expire_start_date']!''}" errorele="selectDate" class="Wdate"
                                   id="d4323"
                                   onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss',readOnly:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'d4324\',{d:0});}'})">
           		<#if (prodPropMap['1356'])??>
           			<input type="hidden" name="prodProductPropList[5].prodPropId"
                           value="${prodPropMap['1356'].prodPropId!''}"/>
                </#if>
                            <input type="hidden" name="prodProductPropList[5].propId"
                                   value="${bizCategoryProp[5].propId!''}"/>
                            <input type="hidden" name="prodProductPropList[5].bizCategoryProp.propCode"
                                   value="${bizCategoryProp[5].propCode!''}"/>
                            <span>-</span>
                            <input type="text" name="prodProductPropList[6].propValue" required
                                   value="${propMap['sale_expire_end_date']!''}" errorele="selectDate" class="Wdate"
                                   id="d4324"
                                   onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'d4323\',{y:20});}',readOnly:true,minDate:'#F{$dp.$D(\'d4323\',{d:0});}'})">
            	<#if (prodPropMap['1357'])??>
            		<input type="hidden" name="prodProductPropList[6].prodPropId"
                           value="${prodPropMap['1357'].prodPropId!''}"/>
                </#if>
                            <input type="hidden" name="prodProductPropList[6].propId"
                                   value="${bizCategoryProp[6].propId!''}"/>
                            <input type="hidden" name="prodProductPropList[6].bizCategoryProp.propCode"
                                   value="${bizCategoryProp[6].propCode!''}"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label" style="padding-right:20px"><i class="cc1">*</i>最大预定数量：</td>
                        <td>
                            <select name="prodProductPropList[7].propValue" style="width: 60px">
                                <#list 1..10 as num>
                                    <option value="${num}"
                                        <#if propMap?? && propMap['max_advance_quantity'] == num>selected</#if>>
                                        ${num}
                                    </option>
                                </#list>
                            </select>
                <#if (prodPropMap['1358'])??>
                	<input type="hidden" name="prodProductPropList[7].prodPropId"
                           value="${prodPropMap['1358'].prodPropId!''}"/>
                </#if>
                            <input type="hidden" name="prodProductPropList[7].propId"
                                   value="${bizCategoryProp[7].propId!''}"/>
                            <input type="hidden" name="prodProductPropList[7].bizCategoryProp.propCode"
                                   value="${bizCategoryProp[7].propCode!''}"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label" style="padding-right:45px"><i class="cc1">*</i>退款说明：</td>
                        <input type="hidden" name="refundId" <#if prodRefund??>value="${prodRefund.refundId!''}"</#if>>
                    </tr>
                    <tr>
                        <td colspan="2" style="padding-left: 130px">
                            <input type="radio" name="cancelStrategy" value="UNRETREATANDCHANGE"
                                   <#if prodRefund?? && prodRefund.cancelStrategy == 'UNRETREATANDCHANGE'>checked</#if>>本产品一经预定不可退改
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="padding-left: 130px">
                            <input type="radio" name="cancelStrategy" value="RETREATANDCHANGE"
                                   <#if prodRefund?? && prodRefund.cancelStrategy == 'RETREATANDCHANGE'>checked</#if>>可退改，购买产品
                            <input type="text" name="prodRefundRules[0].cancelTime" class="w35 validInput" required
                                   <#if prodRefundRule??>value="${prodRefundRule.cancelTime!''}"</#if>>天内
                            <input type="text" name="prodRefundRules[0].applyType" class="validInput" required
                                   <#if prodRefundRule??>value="${prodRefundRule.applyType!''}"</#if>>
                            <input type="hidden" name="prodRefundRules[0].ruleId" <#if prodRefundRule??>value="${prodRefundRule.ruleId!''}"</#if>>
                            <input type="hidden" name="prodRefundRules[0].refundId" <#if prodRefundRule??>value="${prodRefundRule.refundId!''}"</#if>>
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
<div class="fl operate" style="margin-left:150px;">
    <a class="btn btn_cc1" id="save">保存</a>
</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
    var loading;

    $(document).ready(function () {
        $("input[name='prodProductPropList[0].propValue']").not("input:checked").closest("tr").find(".validInput").each(function () {
            $(this).attr("disabled", "disabled");
        });
        $("input[name='cancelStrategy']").not("input:checked").closest("td").find(".validInput").each(function () {
            $(this).attr("disabled", "disabled");
        });
    });

    $("input[name='prodProductPropList[0].propValue']").click(function () {
        $("input[name='prodProductPropList[0].propValue']").not("input:checked").closest("tr").find(".validInput").each(function () {
            $(this).attr("disabled", "disabled");
        });
        $("input[name='prodProductPropList[0].propValue']:checked").closest("tr").find(".validInput").each(function () {
            $(this).removeAttr("disabled");
        });
    });

    $("input[name='cancelStrategy']").click(function () {
        $("input[name='cancelStrategy']").not("input:checked").closest("td").find(".validInput").each(function () {
            $(this).attr("disabled", "disabled");
        });
        $("input[name='cancelStrategy']:checked").closest("td").find(".validInput").each(function () {
            $(this).removeAttr("disabled");
        });
    });


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
        return this.optional(element) || (length >= param[0] && length <= param[1]);
    }, $.validator.format("请确保输入的值在{0}-{1}个字节之间(一个中文字算2个字节)"));
    /**
     * 验证正整数
     */
    jQuery.validator.addMethod("isInteger", function (value, element) {
        var num = /^[1-9]\d*|0$/;
        return this.optional(element) || (num.test(value));
    }, "请填写整数");

    //验证规则
    var fomeRules = {
        rules: {
            'prodProductPropList[1].propValue': {
                max: 9999,
                min: 1
            },
            'prodRefundRules[0].cancelTime': {
                isInteger: true
            },
            'prodRefundRules[0].refundContent': {
                byteRangeLength: [1, 50]
            }
        },
        messages: {
            'prodProductPropList[1].propValue': '请输入1~9999中的数字',
            'prodRefundRules[0].refundContent': '请输入1~50个字符',
            'prodRefundRules[0].cancelTime': '请输入合法数字'
        }
    };

    $("#save").click(function () {
        if ($("input[name='prodProductPropList[0].propValue']:checked").length == 0) {
            alert("未设置产品有效期");
            return false;
        }
        if ($("input[name='cancelStrategy']:checked").length == 0) {
            alert("未设置退改规则");
            return false;
        }
        if (!$("#dataForm").validate(fomeRules).form()) {
            return false;
        }

        var msg = '确认保存吗 ？';
        if (refreshSensitiveWord($("input[type='text'],textarea"))) {
            $("input[name=senisitiveFlag]").val("Y");
            msg = '内容含有敏感词,是否继续?'
        } else {
            $("input[name=senisitiveFlag]").val("N");
        }
        $.confirm(msg, function () {
            //遮罩层
            loading = pandora.loading("正在努力保存中...");
            $.ajax({
                url: "/vst_admin/supermember/prod/product/saveSaleInfo.do",
                type: "post",
                dataType: 'json',
                data: $("#dataForm").serialize(),
                success: function (result) {
                    loading.close();
                    if (result.code == "success") {
                        pandora.dialog({
                            wrapClass: "dialog-mini",
                            content: result.message,
                            mask: true,
                            okValue: "确定",
                            ok: function () {
                                $("#saleInfoBtn",window.parent.document).parent("li").trigger("click");
                            }
                        });
                    } else {
                        $.alert(result.message);
                    }
                },
                error: function () {
                    loading.close();
                }
            });
        }, function () {
        });

    });

</script>