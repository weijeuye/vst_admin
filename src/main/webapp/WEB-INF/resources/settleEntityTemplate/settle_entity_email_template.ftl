<#if days==0>
您好，以下合同中的结算对象已经到期，已将其置为无效状态,请及时处理。如已处理，请忽略本邮件。
<#elseif days==1>
您好，以下合同中的结算对象即将到期，请立刻对合同中的结算对象或商品作出相应处理。如已处理，请忽略本邮件。
<#elseif days==7>
您好，以下合同中的结算对象还有7天即将到期，请立刻对合同中的结算对象或商品作出相应处理。如已处理，请忽略本邮件。
<#else>
您好，以下合同中的结算对象还有${days}天即将到期，请立刻对合同中的结算对象或商品作出相应处理。如已处理，请忽略本邮件。
</#if>
<table style='border-collapse: collapse;border-spacing: 0;'>
    <tr>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>结算对象ID</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>结算对象CODE</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>结算对象名称</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>结算对象有效期至</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>供应商名称</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>合同编号</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>合同名称</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>合同截至日期</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>产品经理姓名</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>经办人姓名</td>
    </tr>
<#list suppSettleEntityList as item>
    <tr>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.id?if_exists}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.code?if_exists}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.name?if_exists}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.expiryDate?string('yyyy-MM-dd')}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.supplierName?if_exists}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.contractNo?if_exists}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.contractName?if_exists}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.contractEndTime?if_exists}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.managerName?if_exists}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.operatorName?if_exists}</td>
    </tr>
</#list>
</table>

<#--
结算对象ID

结算对象名称

结算对象有效期至

供应商名称

合同编号

合同名称

产品经理姓名

经办人姓名
-->