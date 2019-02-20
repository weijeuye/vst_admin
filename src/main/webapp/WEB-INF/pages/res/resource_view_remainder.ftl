<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>查看剩余量</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/resource-view-remainder.css"/>
</head>
<body>

<input type="hidden" class="JS_yeah" name="year" value="${year}"/>
<input type="hidden" class="JS_month" name="month" value="${month}"/>
<input type="hidden" class="JS_productId" name="productId" value="${precontrolPolicyId}" />

<!--查看剩余量 开始-->
<div class="remainder-table" id="JS_table_remainder"></div>
<!--查看剩余量 结束-->

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>

<script>

    //文档加载完后执行
    $(function () {

        var yeah = $(".JS_yeah").val();
        var month = $(".JS_month").val();
        

        //查看剩余量
        var $tableRemainder = $("#JS_table_remainder");
        var TRTemplate = {
            warp: '<div class="ui-calendar"></div>',
            calControl: '<span class="month-prev" {{stylePrev}} title="上一月">‹</span><span class="month-next" {{styleNext}} title="下一月">›</span>',
            calWarp: '<div class="calwarp clearfix">{{content}}</div>',
            calMonth: '<div class="calmonth">{{content}}</div>',
            calTitle: '<div class="caltitle"><span class="mtitle">{{month}}</span></div>',
            calBody: '<div class="calbox">' +
            '<i class="monthbg">{{month}}</i>' +
            '<table cellspacing="0" cellpadding="0" border="0" class="caltable">' +
            '<thead>' +
            '<tr>' +
            '<th class="sun">日</th>' +
            '<th class="mon">一</th>' +
            '<th class="tue">二</th>' +
            '<th class="wed">三</th>' +
            '<th class="thu">四</th>' +
            '<th class="fri">五</th>' +
            '<th class="sat">六</th>' +
            '</tr>' +
            '</thead>' +
            '<tbody>' +
            '{{date}}' +
            '</tbody>' +
            '</table>' +
            '</div>',
            weekWarp: '<tr>{{week}}</tr>',
            day: '<td {{week}} {{dateMap}} >' +
            '<div {{className}}>' +
            '<span class="calday">{{day}}</span>' +
            '<span class="calinfo"></span>' +
            '<div class="fill_data"></div>' +
            '</div>' +
            '</td>'
        };

        //填充日历数据
        function fillData() {
            var that = this;
            /*var month = that.date.getMonth();
            var year = that.date.getFullYear();
            var day = that.date.getDate();

            var specDate = year + "-" + (month + 1) + "-" + day;*/

            //console.log(specDate);

            //TODO 更换真实链接
            var url = "/vst_admin/goods/recontrol/remainder/detail.do";
            var productId=$(".JS_productId").val();

            $.ajax({
                url: url,
                data: {id: productId},
                dataType: "JSON",
                success: function (json) {
                    setData(json);
                },
                error: function () {
                    backstage.alert({
                        "content": "加载数据失败"
                    });
                }
            });

            function setData(data) {
                if (data === undefined) {
                    return;
                }
                data.forEach(function (row) {
                    var type = row.type;
                    var value = row.value;
                    var $td = that.target.find("td[date-map=" + row.date + "]");
                    var content;
                    if (type == "stock") {
                        content = '<span>库存：<span class="text-success">' + value + '</span></span>';
                    } else if (type == "money") {
                        content = '<span>金额：<span class="text-danger">' + value + '</span></span>';
                    }
                    $td.find("div.fill_data").append($(content));
                });
            }

        }

        //初始化查看剩余量日历
        var tableRemainder = pandora.calendar({
            date: new Date(yeah, month-1),
            sourceFn: fillData,
            frequent: true,
            autoRender: true,
            template: TRTemplate,
            target: $tableRemainder,
            control: true,  // 控制翻页按钮是否显示
            showPrev: true, // 控制上个月翻月按钮
            showNext: true, // 控制下个月翻月按钮
            isTodayClick: true,
            completeCallback: function () {
                var $uiCalendar = $tableRemainder.find(".ui-calendar");
                $uiCalendar.css({
                    "width": "auto"
                });
                $tableRemainder.find(".month-prev").show();
                $tableRemainder.find(".month-next").show();
            }
        });

    });

</script>
</body>
</html>
