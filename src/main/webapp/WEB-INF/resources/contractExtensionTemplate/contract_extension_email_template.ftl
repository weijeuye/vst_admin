您好，以下供应商合同${days}天即将到期，即将自动顺延。请确认，如已确认，请忽略本邮件。
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
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.supplierName!""}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.contractNo!""}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.contractName!""}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'><#if item.endTime??>${item.endTime?string('yyyy-MM-dd')}</#if></td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'><#if item.extensionFlag??>${(item.extensionFlag=='Y')?string("是","否")}</#if></td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'><#if item.extensionTime??>${item.extensionTime?string('yyyy-MM-dd')}</#if></td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${managerName!""}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.operatorName!""}</td>
    </tr>
</#list>
</table>