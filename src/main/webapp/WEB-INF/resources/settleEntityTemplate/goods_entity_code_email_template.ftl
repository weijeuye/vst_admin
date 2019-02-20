
早上好！以下是线上 商品绑定结算对象CODE的情况,请您查阅。
<table style='border-collapse: collapse;border-spacing: 0;'>
    <tr>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>品类ID</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>品类名称</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>总个数</td>
    </tr>
    <#list suppGoodsEntitiesCodeList as item>
        <tr>
            <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.categoryId?if_exists}</td>
            <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.categoryName?if_exists}</td>
            <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.dataCount?if_exists}</td>
        </tr>
    </#list>
</table>
