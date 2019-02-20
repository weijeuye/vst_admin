<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>线路行程（行程明细）</title>
    <link href="/vst_admin/css/ui-common.css" rel="stylesheet"/>
    <link href="/vst_admin/css/ui-components.css" rel="stylesheet"/>
    <link href="/vst_admin/css/iframe.css" rel="stylesheet"/>
    <link href="/vst_admin/css/dialog.css" rel="stylesheet"/>
    <link rel="stylesheet" href="/vst_admin/css/calendar.css" type="text/css"/>
    <script src="http://pic.lvmama.com/min/index.php?f=/js/new_v/jquery-1.7.2.min.js"></script>
    
    <!--新增样式表-->
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/group-input.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/vst-group-input.css"/>

</head>
<body>
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
                <a href="/vst_admin/prod/prodLineRoute/showUpdateRoute.do?productId=${prodProduct.productId}">返回行程</a>
            </div>
            <!--线路行程 开始-->
            <div class="gi-form">
            
             <form class="prodLineRouteDetailForm" action="#" method="post">
             <input type="hidden" name="lineRouteId" value="${prodLineRoute.lineRouteId}" />
             <input type="hidden" name="productId" value="${prodProduct.productId}" />
                <div class="JS_days">
                 <#if prodLineRouteDeatilList?? && prodLineRouteDeatilList?size &gt; 0>
                     <#list prodLineRouteDeatilList as r>
                       <#include "/dujia/group/route/routeDetail.ftl"/>
                     </#list>
                 </#if>
                </div>
             </form>
             
                <div class="clearfix">
                    <p class="fr gi-mr20">
                        <a href="javascript:" class="JS_add_day">增加一天行程</a>
                    </p>
                </div>

                <div class="gi-ctrl clearfix">
                    <div class="fr">
                        <a href="javascript:" class="gi-button gi-mr15 JS_button_save">保存</a>
                    </div>
                </div>
            </div>
            <!--线路行程 结束-->
        </div>
    </div>
</div>

<!--脚本模板使用 开始-->
<div class="JS_template">

    <!--Day 模板-->
   <div class="JS_day">
        <div class="gi-inner-dl clearfix">
           <div class="lineRouteDetailHiddenDiv" style="display:none;">
                <input type="hidden" name="prodLineRouteDetailList[{{index}}].detailId">
                <input type="hidden" name="prodLineRouteDetailList[{{index}}].nDay" value="" class="JS_day_num_input">
                <#-- 通过js中方法buildRouteDetailTitle()将多个地点拼接为title -->
                <input type="hidden" name="prodLineRouteDetailList[{{index}}].title" value="" class="JS_title" >
            </div>
            <div class="gi-inner-dt">第 <em class="JS_day_num">1</em> 天　</div>
            <div class="gi-inner-dd gi-destinations JS_destinations">
                <div class="gi-destination JS_destination">
                    <input type="text" class="input-text gi-w100 placeholder notDashTest" maxlength="20" data-placeholder="输入地点" value="输入地点" data-validate="true" required/>
                    <b>-</b>
                </div>
                <div class="gi-destination JS_destination">
                    <input type="text" class="input-text gi-w100 placeholder notDashTest" maxlength="20" data-placeholder="输入地点" value="输入地点" data-validate="true" required/>
                    <b style="display: none;">-</b>
                    <a href="javascript:" class="gi-del JS_del_destination">删除</a>
                </div>
                <div class="gi-destination gi-destination-add JS_destination_add">
                    <a href="javascript:" class="JS_add_destination">添加目的地</a>
                </div>
            </div>
        </div>
        <div class="gi-inner-dl clearfix">
            <div class="gi-inner-dt">行程描述：</div>

            <div class="gi-inner-dd"><textarea class="gi-w500 gi-h150" cols="30" rows="10" name="prodLineRouteDetailList[{{index}}].content" maxlength="2000"></textarea></div>
        </div>
        <div class="gi-inner-dl clearfix">
            <div class="gi-inner-dt">住宿：</div>
            <div class="gi-inner-dd JS_radio_box">

                <p>
                    <span class="JS_radio_switch_box">
                        <label>
                           <#-- 值360是对应老页面中的选择酒店列表下拉信息中的 其他 项（新页面中已将其去掉，行程明细表中无直接存储 含、不含住宿 的字段，间接通过stayType存储） -->
                            <input type="radio" class="JS_radio_switch" checked="checked" name="prodLineRouteDetailList[{{index}}].stayType" value="360" />
                            含住宿
                        </label>

                        <input class="input-text gi-w400 JS_radio_disabled" type="text" data-placeholder="输入参考酒店" value="输入参考酒店"
                               required="required" data-validate="true" maxlength="200" name="prodLineRouteDetailList[{{index}}].stayDesc"  />

                    </span>
                </p>

                <p>

                    <label>
                        <input type="radio" name="prodLineRouteDetailList[{{index}}].stayType" value="" class="JS_radio_switch"/>
                        不含住宿
                    </label>

                </p>
            </div>
        </div>
        <div class="gi-inner-dl clearfix">
            <div class="gi-inner-dt">用餐：</div>
            <div class="gi-inner-dd JS_dinner_box">
                <span class="JS_checkbox_switch_box JS_dinner_checkbox_box gi-mr35">
                    <label>
                        <input type="checkbox" name="prodLineRouteDetailList[{{index}}].breakfastFlag" value="Y" class="JS_checkbox_switch JS_dinner_checkbox" />
                        早餐
                    </label>
                    <input class="input-text gi-w80 JS_checkbox_disabled JS_dinner_input" required name="prodLineRouteDetailList[{{index}}].breakfastDesc"
                           data-validate="true" type="text"  value="敬请自理"
                            disabled maxlength="100"/>
                </span>

                <span class="JS_checkbox_switch_box JS_dinner_checkbox_box gi-mr35">
                    <label>
                        <input type="checkbox" name="prodLineRouteDetailList[{{index}}].lunchFlag" value="Y" class="JS_checkbox_switch JS_dinner_checkbox"/>
                        午餐
                    </label>
                    <input class="input-text gi-w80 JS_checkbox_disabled JS_dinner_input" required  value="敬请自理"
                           data-validate="true" type="text"  name="prodLineRouteDetailList[{{index}}].lunchDesc"
                           disabled maxlength="100"/>
                </span>

                <span class="JS_checkbox_switch_box JS_dinner_checkbox_box">
                    <label>
                        <input type="checkbox" name="prodLineRouteDetailList[{{index}}].dinnerFlag" value="Y" class="JS_checkbox_switch JS_dinner_checkbox"/>
                        晚餐
                    </label>
                    <input class="input-text gi-w80 JS_checkbox_disabled JS_dinner_input" required  value="敬请自理"
                           data-validate="true" type="text" name="prodLineRouteDetailList[{{index}}].dinnerDesc"
                           disabled maxlength="100"/>
                </span>

            </div>
        </div>
        <div class="gi-inner-dl clearfix">
            <div class="gi-inner-dt">交通：</div>

            <div class="gi-inner-dd">
                <label class="gi-pr15"><input type="checkbox" name="prodLineRouteDetailList[{{index}}].trafficType" value="PLANE"  />
                    飞机</label>

                <label class="gi-pr15">
                    <input type="checkbox" name="prodLineRouteDetailList[{{index}}].trafficType" value="TRAIN"  />
                    火车
                </label>

                <label class="gi-pr15">
                    <input type="checkbox" name="prodLineRouteDetailList[{{index}}].trafficType" value="BARS" />
                    巴士</label>

                <label class="gi-pr15">
                    <input type="checkbox" name="prodLineRouteDetailList[{{index}}].trafficType" value="BOAT" />
                   轮船
                </label>

                <span class="JS_checkbox_switch_box">
                <label>
                    <input type="checkbox" name="prodLineRouteDetailList[{{index}}].trafficType" value="OTHERS" class="JS_checkbox_switch"/>
                    其他
                </label>
                <input class="input-text gi-w200 JS_checkbox_disabled" disabled="disabled" type="text" name="prodLineRouteDetailList[{{index}}].trafficOther"
                       maxlength="100"/>
                </span>
            </div>

        </div>
        <div class="clearfix">
            <p class="fr gi-mr20">
                <a href="javascript:" class="gi-del JS_del_day">删除</a>
            </p>
        </div>
        <div class="gi-hr"></div>

    </div>
   
</div>
<!--脚本模板使用 结束-->

<!--内层模板 开始-->
<div class="JS_template_inner">
   <!--目的地模板 开始-->
    <div class="gi-destination JS_destination">
        <input class="input-text gi-w100 placeholder notDashTest" type="text" maxlength="20" data-placeholder="输入地点" value="输入地点"  data-validate="true" required />
        <a href="javascript:" class="gi-del JS_del_destination">删除</a>
        <b>-</b>
    </div>
    <!--目的地模板 结束-->
</div>
<!--内层模板 结束-->

<!-- 引入基本的js -->
<#include "/base/foot.ftl"/>
<!--引入新增脚本文件-->
<script src="/vst_admin/js/vst-group-input.js"></script>

<script>
/**
 * jQuery validator 验证
 * name 不能重复
 */
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
    
    //内容不能是-(dash)
    jQuery.validator.addMethod("notDashTest", function (value, element) {
        var $ele = $(element);
        var val = $ele.val();
        var illegalReg = /[\-]/;
        return !illegalReg.test(val);
    }, "禁止输入横杠&quot;-&quot;");
    jQuery.validator.addClassRules("notDashTest", {
        notDashTest: true
    });

    var $document = $(document);
    //保存
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

            $input.each(function (index) {
                var $required = $input[index];
                var ret = validate.element($required);
                if (!ret) {
                    isValidate = false;
                }
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
            if (refreshSensitiveWord($("textarea"))) {
              $.confirm("内容含有敏感词,是否继续?", function() {
                  saveLineRoute();
              });
            } else {
                saveLineRoute();
            }
        } else {
            alertObj = $.saveAlert({"width": 250,"type": "danger","text": "请完成必填填写项并确认填写正确"});
        }

    });

    //构建行程明细中的title
    function buildRouteDetailTitle($form) {
        var result = {};
        result.message = "";
        result.tip = false;

        $JS_days = $form.find(".JS_days>.JS_day");
        if ($JS_days.length <= 0) {
            return;
        }

        $.each($JS_days, function(index, JS_day) {
            $JS_day = $(JS_day);
            $JS_destinations = $JS_day.find(".JS_destinations>.JS_destination");
            if ($JS_destinations.length <= 0) {
                return true;
            }

            $JS_title = $JS_day.find(".lineRouteDetailHiddenDiv>.JS_title");
            var title = "";
            $.each($JS_destinations, function(index, JS_destination) {
                $JS_destination = $(JS_destination);
                $dest_input = $JS_destination.find("input[type='text']");
                title += $dest_input.val() + "—";
            });

            //删除字符串中最后一个'—'号
            if (title != "") {
                title = title.substring(0, title.length-1);
            } else {
               result.tip = true;
               result.message = "行程明细中地点信息不能为空";
            }
            $JS_title.val(title);
        });

        return result;
    }

     function saveLineRoute(){
        //获得当前的FORM
        $form = $(".prodLineRouteDetailForm");
 
        //处理行程明细中的title（输入的多个地点信息）拼接为title字段
        var result = buildRouteDetailTitle($form);
        if (result.tip) {
            $.alert(result.message);
            return;
        }

        //校验行程中的行程天数与行程明细是否一致，不一致给出提示
        var routeNum = $form.find("select[name='routeNum']").val();
        var stayNum = $form.find("select[name='stayNum']").val();
        var routeDeailNum = $form.find(".JS_days>.JS_day").length;
        if (routeNum != routeDeailNum) {
            var tipMessage = "实际输入行程天数为"+routeDeailNum+"天"+stayNum+"晚，与下拉框日期不符，是否确定？";
           // $.confirm(tipMessage, function() {
                sendAjaxSaveRouteDetail($form);
          //  });
        } else {
            sendAjaxSaveRouteDetail($form);
        }
    }

    //发送ajax保存行程信息
    function sendAjaxSaveRouteDetail($form) {
        $.ajax({
            url: "/vst_admin/dujia/group/route/addProdLineRouteDetail.do",
            data: $(".prodLineRouteDetailForm").serialize(),
            type: "POST",
            dataType: "JSON",
            success: function(result) {
                if(result.code=="success"){
                    alertObj = $.saveAlert({
                          "width": 150,
                          "type": "success",
                          "text": "保存成功"
                    });

                    //跳转到行程列表页面
                    $("#saveRouteFlag",window.parent.document).val('true');
                    $("#route",parent.document).parent("li").trigger("click");   
                }
            }
        });
    }

    //公共方法：判断参数为空
    function isEmpty(value) {
        if (typeof(value) == 'undefined' || value == null || value == "") {
            return true;
        } else {
            return false;
        }
    }

    //初始化行程明细
    var dayLength=$(".JS_days").find(".JS_day").length;
    if(dayLength==0){
       $(".JS_add_day").click();
    }

    refreshSensitiveWord($("textarea"));
})();

</script>
</body>
</html>
