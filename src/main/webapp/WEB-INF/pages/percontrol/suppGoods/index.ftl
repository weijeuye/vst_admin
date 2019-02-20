
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>绑定资源预控商品</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/bind-resource-control-product.css"/>
    <link rel="stylesheet" href="${rc.contextPath}/css/dialog.css"/>
	<link rel="stylesheet" href="/lvmm_log/css/iframe.css"/>
	
</head>
<body class="bind-resource-control-product">
<h2  class="title">&nbsp&nbsp&nbsp绑定资源预控商品 ${policyName}</h2>
<div class="filter">
        <form class="filter-form" method="post" action='/vst_admin/refund/showPreRefundSuppGoodsList.do' id="searchForm">
            <div class="row">
                <div class="col w200">
                    <div class="form-group">
                        <label>
                            &nbsp&nbsp&nbsp产品ID：
                            <input id="productId" class="form-control w120" type="text" name="productName"
                        </label>
                    </div>
                </div>
                <div class="col w200">
                    <div class="form-group">
                        <label>
                           	商品ID：
                            <input id="suppGoodsId" class="form-control w120" type="text" name="productId"
                                    number="true" >
                        </label>
                    </div>
                </div>
            <a class="btn btn-primary JS_btn_select" id="search_button_suppgoods">查询</a>&nbsp
	           
          </div>
        </form>
        
    </div>
<div class="everything">

    
    <div class="tab-box main">
        <input type="hidden" id="budgetFlag" value="false">
        <div class="clearfix">
            <ul class="nav-tabs header-left">
                <li class="active" onclick="Budget.convertTab(${supplier.supplierId},1,false,${policyId})">未绑定商品</li>
                <li onclick="Budget.convertTab(${supplier.supplierId},1,true,${policyId})">已绑定商品</li>
            </ul>
            <div class="header-right">
                <div class="col supplier-name" supplier-id=${supplier.supplierId} policy-id=${policyId}>
                    <label>
                        供应商：${supplier.supplierName}
                    </label>
                </div>
                
            </div>
        </div>

        <div class="tab-content">
            <div class="tab-pane active unbind-product clearfix">
                <#include "/percontrol/suppGoods/suppGoods.ftl">
            </div>
            <div class="tab-pane bound-product clearfix">
            </div>
       

        <a class="btn" href="/vst_admin/goods/recontrol/find/resPrecontrolPolicyList.do?permId=4412">返回</a>
       
    </div>

</div>

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/bind-resource-control-product.js"></script>
<script src="${rc.contextPath}/js/budget.js"></script>

<script src="${rc.contextPath}/js/pandora-dialog.js"></script>
<script src="${rc.contextPath}/js/lvmama-dialog.js"></script>
<script src="${rc.contextPath}/js/log.js"></script>
<script src="${rc.contextPath}/js/My97DatePicker/WdatePicker.js"></script>
<script>
    //TODO 开发维护

    //查看已生成订单
    $(function () {
        var $document = $(document);
        var $template = $(".template");
        $document.on("click", ".JS_btn_view_order", viewOrderHandler);
      
        function viewOrderHandler() {
            var $this = $(this);
            var suppGoodsId = $(this).attr("goods-id");
            var policyId = $(this).attr("policy-id");
            //TODO 替换真实链接地址
            var url = "/vst_admin/percontrol/suppGoods/getSuppGoodsBudgetOrder.do?suppGoodsId="+suppGoodsId+"&policyId="+policyId;
            var dialogViewOrder = backstage.dialog({
                width: 775,
                height: 450,
                title: "查看已生成订单",
                iframe: true,
                url: url
            });
        }
        
  });
</script>
</body>
</html>
