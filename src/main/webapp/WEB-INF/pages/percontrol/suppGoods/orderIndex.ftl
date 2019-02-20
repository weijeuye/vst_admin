<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>查看已生成订单 ${policy.name}</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/bind-view-order.css"/>
</head>
<body class="bind-view-order">

<div class="order">
    <form>
        <div class="header clearfix">
            <#if policy.controlType == 'amount'>
                <div class="col w170 pl10">预控方式：预控金额</div>
                <#if policy.controlClassification == 'Cycle'>
                    <div class="col w140">预控金额：${policy.amount/100}</div>
                    <div class="col w150">剩余金额：${policy.remainAmount/100}</div>
                </#if>
            <#else>
                <div class="col w170 pl10">预控方式：预控库存</div>
                <#if policy.controlClassification == 'Cycle'>
                    <div class="col w140">预控库存：${policy.amount}</div>
                    <div class="col w150">剩余库存：${policy.remainAmount}</div>
                </#if>
            </#if>

            <div class="col w300">游玩起止时间：${policy.tradeEffectDateStr} - ${policy.tradeExpiryDateStr}</div>
        </div>
        <div id="orderTable">
            <#include "/percontrol/suppGoods/orderList.ftl">
        </div>
    </form>
</div>

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="${rc.contextPath}/js/budget.js"></script>
<script>

</script>
</body>
</html>
