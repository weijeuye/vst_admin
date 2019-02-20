<style>
    .dialog{position: absolute!important;}
</style>
<table class="table table-border">
    <thead>
    <tr>
        <th width="5%">
        <#if budgetFlag>
        <input type="checkbox" id="bindAllCheckbox" />
        <#else> 
         <input type="checkbox" id="unbindAllCheckbox" />
        </#if>
        </th>
        <th width="8%">产品ID</th>
        <th width="12%">产品名称</th>
        <th width="8%">产品品类</th>
        <th width="8%">商品ID</th>
        <th width="20%">商品名称</th>
        <th width="10%">历史预控日期</th>
        <#if budgetFlag>
            <th width="26%">操作</th>
        </#if>
    </tr>
    </thead>
    <tbody>
    <#list suppGoodsList as suppGoods>
    <tr>
        <td>
       <#if suppGoods.orderItemNum == 0>
        <input type="checkbox" goods-id="${suppGoods.suppGoodsId}" product-id="${suppGoods.productId}"/></td>
        </#if>
        <td>${suppGoods.productId}</td>
        <td>${suppGoods.productName}</td>
        <td>${suppGoods.categoryName}</td>
        <td>${suppGoods.suppGoodsId}</td>
        <td>${suppGoods.suppGoodsName}</td>
        <td><#if suppGoods.lastPushDate??>${suppGoods.lastPushDate?string("yyyy-MM-dd")!''} - ${suppGoods.saleEffectDate?string("yyyy-MM-dd")!''}</#if></td>
        <#if budgetFlag>
            <td>
            
                <a class="JS_btn_view_order" policy-id="${suppGoods.precontrolPolicyId}" goods-id="${suppGoods.suppGoodsId}">
                    查看已生成订单(
                        <span class="text-danger">
                         ${suppGoods.orderItemNum + suppGoods.historyOrderItemNum}
                        </span>
                    )
                </a>
                
                <#--<a class="JS_btn_view_His_order" policy-id="${suppGoods.precontrolPolicyId}" goods-id="${suppGoods.suppGoodsId}">
                	查看已推送订单(
                        <span class="text-danger">
                        ${suppGoods.historyOrderItemNum}
                        </span>
                    	)
                </a>-->
                 
                <#--
                	<a 
                		class='pushHistoryResource'
                		data-precontrolid=${suppGoods.precontrolPolicyId}
                		data-lastpushdate=${suppGoods.lastPushDate?string("yyyy-MM-dd")}
                		data-goodsid = ${suppGoods.suppGoodsId}
                		data-saleeffectdate=${suppGoods.saleEffectDate?string("yyyy-MM-dd")!''}
                	>
                		推送历史资源
                	</a>
                -->
                	<span>
                	<a href="javascript:void(0);" class="showLogDialog" 
                	   param='parentId=${suppGoods.precontrolPolicyId}&objectId=${suppGoods.suppGoodsId}&objectType=RES_PRECONTROL_POLICY_PUSH_HISTORY'>
                	        操作日志
                	</a>
                	</span>
            </td>
        </#if>
    </tr>
    </#list>
    </tbody>
</table>

<#--分页标签-->
${paginationTag}

<div class="footer-right">
    <#if !budgetFlag>
       <!-- 星云系统中维护 -->
       <#-- <a class="btn btn-primary bindingPreControl" >确认绑定</a> -->
     <#else>
        <a class="btn btn-primary unBindingPreControl">批量解绑</a>
    </#if>
</div>