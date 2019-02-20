<table class="table table-border text-center">
    <thead>
        <tr>
            <th width="12.5%">订单号</th>
            <th width="12.5%">子订单号</th>
            <th width="12.5%">产品名称</th>
            <th width="12.5%">商品名称</th>
            <th width="12.5%">出游日期</th>
            <th width="12.5%">预定份数</th>
            <th width="12.5%">结算单价</th>
            <th width="12.5%">结算总价</th>
        </tr>
    </thead>
    <tbody>
        <#list suppGoodsOrderList as suppGoodsOrder>
            <tr>
                <td>
                	<a target="_blank" href="/vst_order/order/ordCommon/showOrderDetails.do?orderId=${suppGoodsOrder.orderId}">${suppGoodsOrder.orderId}</a>
                </td>
                <td>
                    <#if suppGoodsOrder.categoryId == 2 || suppGoodsOrder.categoryId == 8>
                        <a target="_blank" href="/vst_order/order/orderShipManage/showChildOrderStatusManage.do?orderItemId=${suppGoodsOrder.orderItemId}&orderType=child">${suppGoodsOrder.orderItemId}</a>
                    <#else>
                        <a target="_blank" href="/vst_order/order/orderManage/showChildOrderStatusManage.do?orderItemId=${suppGoodsOrder.orderItemId}&orderType=child">${suppGoodsOrder.orderItemId}</a>
                    </#if>
                </td>

                <td>${suppGoodsOrder.productName}</td>
                <td>${suppGoodsOrder.suppGoodsName}</td>
                <td>${suppGoodsOrder.visitTimeStr}</td>
                <#if suppGoodsOrder.ordMulPriceRateList?exists &&suppGoodsOrder.ordMulPriceRateList?size gt 0>
                <td>
                 <#list suppGoodsOrder.ordMulPriceRateList as mulPrice>
                 <#if mulPrice.priceType=='SETTLEMENT_ADULT_PRE'>
                                                       成人：${mulPrice.quantity}<br/>
                 </#if>                                      
                 </#list>
                 
                 <#list suppGoodsOrder.ordMulPriceRateList as mulPrice>
                 <#if mulPrice.priceType=='SETTLEMENT_CHILD_PRE'>
                                                      儿童： ${mulPrice.quantity}<br/>
                   </#if>  
                 </#list>
                   </td>
                  <td>
                 <#list suppGoodsOrder.ordMulPriceRateList as mulPrice>
                 <#if mulPrice.priceType=='SETTLEMENT_ADULT_PRE'>
                                                       成人：${mulPrice.price/100}<br/>
                  </#if>  
                 </#list>
                 
                 <#list suppGoodsOrder.ordMulPriceRateList as mulPrice>
                 <#if mulPrice.priceType=='SETTLEMENT_CHILD_PRE'>
                                                      儿童： ${mulPrice.price/100}<br/>
                 </#if>  
                 </#list>
                </td>
                <#else>
                <td>${suppGoodsOrder.buyoutQuantity}</td>
                <td>${suppGoodsOrder.buyoutUnitPrice/100}</td>
                </#if>
                <#if suppGoodsOrder.ordMulPriceRateList?exists &&suppGoodsOrder.ordMulPriceRateList?size gt 0>
                <td>${suppGoodsOrder.total/100}</td>
                <#else>
                 <td>${suppGoodsOrder.buyoutTotalPrice/100}</td>
                </#if>
            </tr>
        </#list>
    </tbody>
</table>

${paginationTag}