<tr>
    <td colspan=3>有效期：</td>
</tr>
<tr>
    <td class="p_label"><i class="cc1">*</i>有效期：</td>
    <td colspan=2>指定游玩日
        <select name="days" style="width:70px" required>
            <option value="1">1(当)</option>
            <#list 2..365 as i>
                <option value="${i}">${i}</option>
            </#list>
        </select>天内有效
    </td>
</tr>


<tr>
    <td class="p_label">使用次数：</td>
    <td colspan=2>
        <input type="text" name="useInsTruction" value="有效期内可入园1次" onFocus="if(value==defaultValue){value='';this.style.color='#000'}" onBlur="if(!value){value=defaultValue;this.style.color='#999'}" style="width:260px;color:#999999">
    </td>
</tr>