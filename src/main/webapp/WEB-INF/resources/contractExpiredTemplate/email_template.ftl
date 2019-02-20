<#if days==1>
您好，以下供应商合同将于于明天到期，请立刻对合同或商品作相应处理。如已处理，请忽略本邮件。
<#elseif days==7>
您好，以下供应商合同还有7天即将到期，请及时对合同或商品作相应处理，如已处理，请忽略本邮件。
<#else>
您好，以下供应商合同${days}天即将到期，请立刻对合同或商品作相应处理。如已处理，请忽略本邮件。
</#if>
<table style='border-collapse: collapse;border-spacing: 0;'>
    <tr>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>供应商名称</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>合同编号</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>合同名称</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>合同截至日期</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>是否顺延</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>合同顺延日期</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>产品经理姓名</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>经办人姓名</td>
    </tr>
<#list suppContractList as item>
    <tr>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.supplierName?if_exists}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.contractNo?if_exists}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.contractName?if_exists}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'><#if item.endTime??>${item.endTime?string('yyyy-MM-dd')}</#if></td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'><#if item.extensionFlag??>${(item.extensionFlag=='Y')?string("是","否")}</#if></td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'><#if item.extensionTime??>${item.extensionTime?string('yyyy-MM-dd')}</#if></td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${managerName?if_exists}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.operatorName?if_exists}</td>
    </tr>
</#list>
</table>