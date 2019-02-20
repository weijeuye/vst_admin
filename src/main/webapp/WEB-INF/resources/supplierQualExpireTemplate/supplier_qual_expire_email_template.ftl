您好，以下供应商资质${days}天即将到期。请及时处理，任一资质一旦到期，供应商状态将自动变为无效，供应商的全部合同均被废弃，请重视，如已确认，请忽略本邮件。
<table style='border-collapse: collapse;border-spacing: 0;'>
    <tr>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>供应商名称</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>供应商ID</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>资质编号</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>资质副本</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>资质到期日期</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;'>产品经理姓名</td>
    </tr>
<#list suppQualExpireList as item>
    <tr>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.supplierName!""}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.supplierId!""}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.qualId!""}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${item.qualTypeName!""}</td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'><#if item.endTime??>${item.endTime?string('yyyy-MM-dd')}</#if></td>
        <td style='border:#000 solid 1px;line-height: 18px;padding: 3px 5px;color:#1F497D;'>${managerName!""}</td>
    </tr>
</#list>
</table>