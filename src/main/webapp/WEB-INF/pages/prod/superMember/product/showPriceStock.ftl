<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <#include "/base/head_meta.ftl"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css">
    <style>
        .sp_div {
            height: 50px;
            padding-top: 20px;
        }

        .sp_lb {
            font-size: 16px;
        }

        .clearfix_dl {
            margin-left: 20px;
            padding-left: 10px;
            padding-top: 10px;
        }

        dd {
            font-size: 13px;
            padding-left: 10px;
            padding-top: 15px;
        }

        dt {
            font-size: 13px;
        }

        input {
            margin-left: 10px;
        }

        .sp_grey {
            color: #a0a6ad;
        }

        .weekTime {
            margin-left: 10px !important;
        }

        .peopleTag_label {
            width: 100px;
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
    <form action="/vst_admin/superMember/prod/product/savePriceStock.do" method="post" id="dataForm">
        <input type="hidden" name="productId" value="${productId!''}">
        <input type="hidden" name="setId" <#if priceSet??>value="${priceSet.setId!''}"</#if>>
        <input type="hidden" name="senisitiveFlag" value="N">
        <div class="p_box box_info p_line">
            <div class="box_content" style="padding-left: 100px">
                <div class="sp_div">
                    <label class="sp_lb">库存设置：</label>
                </div>
                <dl class="clearfix_dl">
                    <dt><i class="cc1">*</i>是否限制销售库存：</dt>
                    <dd>
                        <input type="radio" name="stockFlag" value="N"
                               <#if priceSet?? && priceSet.stockFlag == 'N'>checked</#if> />不限制销售
                    </dd>
                    <dd>
                        <input type="radio" name="stockFlag" value="Y"
                               <#if priceSet?? && priceSet.stockFlag == 'Y'>checked</#if> />每日不超过
                        <input type="text" name="totalStock" value="${totalStock!''}"
                               <#if !(priceSet?? && priceSet.stockFlag == 'Y')>disabled</#if>
                               required/>
                    </dd>
                </dl>
                <dl class="clearfix_dl">
                    <dt><i class="cc1">*</i>价格设置：</dt>
                    <dd class="fix_dd">
                        <input type="radio" name="priceType" value="FIXED_PRICE"
                               <#if priceSet?? && priceSet.priceType == 'FIXED_PRICE'>checked</#if>/>固定售价
                        <div style="padding-top: 10px;padding-left: 30px;">
                            市场价：<input type="text" name="marketPrice"
                                       <#if priceSet?? && priceSet.priceType == 'FIXED_PRICE'>value="${marketPrice!''}"</#if>
                                       <#if !(priceSet?? && priceSet.priceType == 'FIXED_PRICE')>disabled</#if>/>
                        </div>
                        <div style="padding-top: 10px;padding-left: 25px;">
                            <i class="cc1">*</i>销售价：<input type="text" name="salesPrice"
                                                           <#if priceSet?? && priceSet.priceType == 'FIXED_PRICE'>value="${salesPrice!''}"</#if>
                                                           <#if !(priceSet?? && priceSet.priceType == 'FIXED_PRICE')>disabled</#if>
                                                           required/>
                            <span class="sp_grey">实际售价必填</span>
                        </div>
                    </dd>
                    <dd class="promotion_dd">
                        <input type="radio" name="priceType" value="PROMOTED_PRICE"
                               <#if priceSet?? && priceSet.priceType == 'PROMOTED_PRICE'>checked</#if>/>促销售价
                        <input type="hidden" name="promotionType">
                        <input type="hidden" name="peopleTag">
                        <dl class="clearfix_dl">
                            <dt>
                                <input id="peoplePromotion" type="checkbox" class="promotionType"
                                       value="PEOPLE_PROMOTION"
                                       <#if promotion?? && promotion.promotionType?contains('PEOPLE_PROMOTION')>checked</#if>
                                       <#if !(priceSet?? && priceSet.priceType == 'PROMOTED_PRICE')>disabled</#if> />人群促销
                            </dt>
                            <dd>
                                <#list payLabelForProductBOList as payLabel>
                                    <#if payLabel_index%5 == 0>
                                        <div>
                                    </#if>
                                    <label class="peopleTag_label">
                                        <input type="checkbox" class="peopleTag" value="${payLabel.code}"
                                           <#if promotion?? && promotion.peopleTag?? && promotion.peopleTag?contains(payLabel.code)>checked</#if>
                                           <#if !(priceSet?? && priceSet.priceType == 'PROMOTED_PRICE')
                                           || !(promotion?? && promotion.promotionType?contains('PEOPLE_PROMOTION'))>disabled</#if>/>${payLabel.labelName}
                                    </label>
                                    <#if (payLabel_index+1)%5 == 0>
                                        </div>
                                    </#if>
                                </#list>
                            </dd>
                        </dl>
                        <dl class="clearfix_dl">
                            <dt>
                                <input id="timePromotion" type="checkbox" class="promotionType" value="TIME_PROMOTION"
                                       <#if promotion?? && promotion.promotionType?contains('TIME_PROMOTION')>checked</#if>
                                       <#if !(priceSet?? && priceSet.priceType == 'PROMOTED_PRICE')>disabled</#if>/>时间促销
                            </dt>
                            <dd>
                                <input type="radio" name="timeType" value="EVERY_WEEK"
                                       <#if promotion?? && promotion.timeType == 'EVERY_WEEK'>checked</#if>
                                       <#if !(priceSet?? && priceSet.priceType == 'PROMOTED_PRICE')
                                       || !(promotion?? && promotion.promotionType?contains('TIME_PROMOTION'))>disabled</#if>>每周
                                <#list weekTimes as time>
                                    <input type="checkbox" class="promotionTime weekTime" value="${time}"
                                       <#if promotion?? && promotion.weekTime?? && promotion.weekTime?contains(time)>checked</#if>
                                       <#if !(priceSet?? && priceSet.priceType == 'PROMOTED_PRICE')
                                       || !(promotion?? && promotion.promotionType?contains('TIME_PROMOTION'))
                                       || !(promotion?? && promotion.timeType == 'EVERY_WEEK')>disabled</#if>>${time.cnName!''}
                                </#list>
                                <input type="hidden" name="weekTime"/>
                            </dd>
                            <dd>
                                <input type="radio" name="timeType" value="EVERY_MONTH"
                                       <#if promotion?? && promotion.timeType == 'EVERY_MONTH'>checked</#if>
                                       <#if !(priceSet?? && priceSet.priceType == 'PROMOTED_PRICE')
                                       || !(promotion?? && promotion.promotionType?contains('TIME_PROMOTION'))>disabled</#if>>每月
                                <select class="promotionTime" name="monthTime" style="margin-left: 20px;width: 60px;"
                                        <#if !(priceSet?? && priceSet.priceType == 'PROMOTED_PRICE')
                                        || !(promotion?? && promotion.promotionType?contains('TIME_PROMOTION'))
                                        || !(promotion?? && promotion.timeType == 'EVERY_MONTH')>disabled</#if>>
                                    <#list 1..31 as day>
                                        <option value="${day}"
                                                <#if promotion?? && promotion.monthTime == day>selected</#if>>${day}</option>
                                    </#list>
                                </select>
                            </dd>
                            <dd>
                                <input type="radio" name="timeType" value="DESIGNED_TIME"
                                       <#if promotion?? && promotion.timeType == 'DESIGNED_TIME'>checked</#if>
                                       <#if !(priceSet?? && priceSet.priceType == 'PROMOTED_PRICE')
                                       || !(promotion?? && promotion.promotionType?contains('TIME_PROMOTION'))>disabled</#if>>指定时间
                                <input type="text" name="designatedStartDate" required
                                       <#if !(priceSet?? && priceSet.priceType == 'PROMOTED_PRICE')
                                       || !(promotion?? && promotion.promotionType?contains('TIME_PROMOTION'))
                                       || !(promotion?? && promotion.timeType == 'DESIGNED_TIME')>disabled</#if>
                                       <#if promotion??>value="${promotion.designatedStartDate!''}"</#if>
                                       errorele="selectDate"
                                       class="Wdate promotionTime"
                                       id="d4323"
                                       onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss',readOnly:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'d4324\',{d:0});}'})">
                                <span>-</span>
                                <input type="text" name="designatedEndDate" required
                                       <#if !(priceSet?? && priceSet.priceType == 'PROMOTED_PRICE')
                                       || !(promotion?? && promotion.promotionType?contains('TIME_PROMOTION'))
                                       || !(promotion?? && promotion.timeType == 'DESIGNED_TIME')>disabled</#if>
                                       <#if promotion??>value="${promotion.designatedEndDate!''}"</#if>
                                       errorele="selectDate"
                                       class="Wdate promotionTime"
                                       id="d4324"
                                       onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'d4323\',{y:20});}',readOnly:true,minDate:'#F{$dp.$D(\'d4323\',{d:0});}'})">
                            </dd>
                        </dl>
                        <dl class="promotion_dl">
                            <dd style="padding-left: 15px">
                                市场价：<input type="text" name="marketPrice"
                                           <#if priceSet?? && priceSet.priceType == 'PROMOTED_PRICE'>value="${marketPrice!''}"</#if>
                                           <#if !(priceSet?? && priceSet.priceType == 'PROMOTED_PRICE')>disabled</#if>/>
                            </dd>
                            <dd>
                                <i class="cc1">*</i>销售价：<input type="text" name="salesPrice"
                                                               <#if priceSet?? && priceSet.priceType == 'PROMOTED_PRICE'>value="${salesPrice!''}"</#if>
                                                               required
                                                               <#if !(priceSet?? && priceSet.priceType == 'PROMOTED_PRICE')>disabled</#if>/>
                                <span class="sp_grey">非促销用户实际售价必填</span>
                            </dd>
                            <dd>
                                <i class="cc1">*</i>促销价：<input type="text" name="salePrice" value="${salePrice!''}"
                                                               required
                                                               <#if !(priceSet?? && priceSet.priceType == 'PROMOTED_PRICE')>disabled</#if>/>
                                <span class="sp_grey">促销用户实际售价必填</span>
                            </dd>
                            <dd style="margin-left:-33px;">
                                促销标签内容：<input type="text" name="promotionContent"
                                              <#if priceSet??>value="${priceSet.promotionContent!''}"</#if>
                                              <#if !(priceSet?? && priceSet.priceType == 'PROMOTED_PRICE')>disabled</#if>
                                              maxlength="6"/>
                                <span class="sp_grey">0/6</span>
                            </dd>
                        </dl>
                    </dd>
                </dl>
            </div>
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
    });
    $("input[name='stockFlag']").click(function () {
        if ($(this).val() == 'Y') {
            $("input[name='totalStock']").removeAttr("disabled");
        } else {
            $("input[name='totalStock']").attr("disabled", "disabled");
        }
    });
    $("input[name='priceType']").click(function () {
        $dd = $(this).closest("dd");
        if ($(this).val() == "FIXED_PRICE") {
            $dd.find("input").removeAttr("disabled");
            $(".promotion_dd").find("input").not("input[name='priceType']").attr("disabled", "disabled");
            $(".promotion_dd").find("select").attr("disabled", "disabled");
        } else {
            $(".promotion_dd").find(".promotionType").removeAttr("disabled");
            $("input[name='promotionType']").removeAttr("disabled");
            $(".promotion_dd").find(".promotion_dl input").removeAttr("disabled");
            $(".fix_dd").find("input").not("input[name='priceType']").attr("disabled", "disabled");
            if ($("#peoplePromotion").attr("checked")) {
                $(".peopleTag").removeAttr("disabled");
                $("input[name='peopleTag']").removeAttr("disabled");
            }
            if ($("#timePromotion").attr("checked")) {
                $("input[name='timeType']").removeAttr("disabled");
                if ($("input[name='timeType']:checked").val() == "EVERY_WEEK") {
                    $(".weekTime").removeAttr("disabled");
                    $("input[name='weekTime']").removeAttr("disabled");
                } else if ($("input[name='timeType']:checked").val() == "EVERY_MONTH") {
                    $("select[name='monthTime']").removeAttr("disabled");
                } else if ($("input[name='timeType']:checked").val() == "DESIGNED_TIME") {
                    $("input[name='designatedStartDate']").removeAttr("disabled");
                    $("input[name='designatedEndDate']").removeAttr("disabled");
                }
            }
        }
    });

    $(".promotionType").click(function () {
        if ($(this).val() == "PEOPLE_PROMOTION") {
            if ($(this).attr("checked")) {
                $(".peopleTag").removeAttr("disabled");
            } else {
                $(".peopleTag").attr("disabled", "disabled");
            }
        } else {
            if ($(this).attr("checked")) {
                $("input[name='timeType']").removeAttr("disabled");
                if ($("input[name='timeType']:checked").val() == "EVERY_WEEK") {
                    $(".weekTime").removeAttr("disabled");
                } else if ($("input[name='timeType']:checked").val() == "EVERY_MONTH") {
                    $("select[name='monthTime']").removeAttr("disabled");
                } else if ($("input[name='timeType']:checked").val() == "DESIGNED_TIME") {
                    $("input[name='designatedStartDate']").removeAttr("disabled");
                    $("input[name='designatedEndDate']").removeAttr("disabled");
                }
            } else {
                $("input[name='timeType']").attr("disabled", "disabled");
                $(".promotionTime").attr("disabled", "disabled");
            }
        }
    });

    $("input[name='timeType']").click(function () {
        $this = $(this);
        if ($this.val() == "EVERY_WEEK") {
            $(".weekTime").removeAttr("disabled");
            $(".promotionTime").not(".weekTime").attr("disabled", "disabled");
        } else if ($this.val() == "EVERY_MONTH") {
            $("select[name='monthTime']").removeAttr("disabled");
            $(".promotionTime").not("select[name='monthTime']").attr("disabled", "disabled");
        } else {
            $("input[name='designatedStartDate']").removeAttr("disabled");
            $("input[name='designatedEndDate']").removeAttr("disabled");
            $(".promotionTime").not(".Wdate").attr("disabled", "disabled");
        }
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
    /**
     * 验证数字
     */
    jQuery.validator.addMethod("isNumber", function (value, element) {
        var num = /^[0-9]\d*(\.\d{1,2})?$/;
        return this.optional(element) || (num.test(value));
    }, "请填写数字");

    //验证规则
    var fomeRules = {
        rules: {
            'totalStock': {
                isInteger: true
            },
            'marketPrice': {
                isNumber: true
            },
            'salesPrice': {
                isNumber: true
            },
            'salePrice': {
                isNumber: true
            },
        },
        messages: {}
    };

    function structData() {
        var promotionType = "";
        $(".promotionType:checked").each(function () {
            promotionType = promotionType + $(this).val() + ",";
        });
        promotionType = promotionType.substring(0, promotionType.length - 1);
        $("input[name='promotionType']").val(promotionType);
        if ($("#peoplePromotion").attr("checked")) {
            var peopleTag = "";
            $(".peopleTag:checked").each(function () {
                peopleTag = peopleTag + $(this).val() + ",";
            });
            peopleTag = peopleTag.substring(0, peopleTag.length - 1);
            $("input[name='peopleTag']").val(peopleTag);
        } else {
            $("input[name='peopleTag']").val("");
        }
        if ($("#timePromotion").attr("checked") && $("input[name='timeType']:checked").val() == "EVERY_WEEK") {
            var weekTime = "";
            $(".weekTime:checked").each(function () {
                weekTime = weekTime + $(this).val() + ",";
            });
            weekTime = weekTime.substring(0, weekTime.length - 1);
            $("input[name='weekTime']").val(weekTime);
        } else {
            $("input[name='weekTime']").val("");
        }
    }

    $("#save").click(function () {
        if ($("input[name='stockFlag']:checked").length == 0) {
            alert("未设置是否限制库存");
            return false;
        }
        if ($("input[name='priceType']:checked").length == 0) {
            alert("未设置售价类型");
            return false;
        }
        if ($("input[name='priceType']:checked").val() == "PROMOTED_PRICE") {
            if ($(".promotionType:checked").length == 0) {
                alert("未设置促销类型");
                return false;
            }
            if ($("#peoplePromotion").attr("checked")) {
                if ($(".peopleTag:checked").length == 0) {
                    alert("未设置促销人群标签");
                    return false;
                }
            }

            if ($("#timePromotion").attr("checked")) {
                if ($("input[name='timeType']:checked").length == 0) {
                    alert("未设置促销时间类型");
                    return false;
                }
                if ($("input[name='timeType']:checked").val() == "EVERY_WEEK") {
                    if ($(".weekTime:checked").length == 0) {
                        alert("未设置促销时间");
                        return false;
                    }
                }
            }
        }
        if (!$("#dataForm").validate(fomeRules).form()) {
            return false;
        }

        structData();

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
                url: "/vst_admin/supermember/prod/product/savePriceStock.do",
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
                                $("#priceStockBtn", window.parent.document).parent("li").trigger("click");
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