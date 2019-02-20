	<tr>
        <td class="e_label" width="250" width="250" width="250"><i class="cc1">*</i>是否需要游玩人信息：</td>
        <td style="text-align:left;">
        	<input type="radio" name="needTravFlag" <#if bizOrderRequired.needTravFlag=='Y'>checked</#if> value="Y">&nbsp;是
        	<input type="radio" name="needTravFlag" <#if bizOrderRequired.needTravFlag=='N'>checked</#if> value="N">&nbsp;否
        </td>
    </tr>
    <tr>
        <td class="e_label" width="250"><i class="cc1">*</i>填写数量：1笔订单需要游玩人信息</td>
        <td style="text-align:left;">
        	<#list orderRequiredTravNumMap?keys as key>
        		<#if key!='TRAV_NUM_NO' && key!='TRAV_NUM_CONF'>
        			<input type="radio" name="travNumType" <#if key==bizOrderRequired.travNumType>checked</#if> value="${key!''}">&nbsp;${orderRequiredTravNumMap[key]!''}
        			<#if key == 'TRAV_NUM_ALL'>注，代表该品类基于“数量关联”有几个游玩人就需要填写几个</#if><#if key == 'TRAV_NUM_ONE'>注，代表该品类只需要一个游玩人即可</#if>
        		    <br/>
        		</#if>
        	</#list>
        </td>
    </tr>
    <tr class="js-check-box">
         <td class="e_label" width="250"><i class="cc1">*</i>姓名：</td>
         <td style="text-align:left;">需要&nbsp;&nbsp;</td>
    </tr>
    <tr>
    	<td class="e_label" width="250"><i class="cc1">*</i>手机号：</td>
        <td style="text-align:left;">
        	<select id="phoneNumType" name="phoneNumType" value="${bizOrderRequired.phoneNumType!''}" required=true>
        		<#list orderRequiredTravNumMap?keys as key>
        			<#if key!='TRAV_NUM_NO' && key!='TRAV_NUM_CONF'>
	                	<#if key == bizOrderRequired.phoneNumType>
	                		<option value="${key!''}" selected="selected">${orderRequiredTravNumMap[key]!''}</option>
	               		<#else>
	               			<#if key == 'TRAV_NUM_ONE'>
	               				<option value="${key!''}" selected="selected">${orderRequiredTravNumMap[key]!''}</option>
	               			<#else>
	               				<option value="${key!''}">${orderRequiredTravNumMap[key]!''}</option>
	               			</#if>
	               		</#if>
               		</#if>
               	</#list>
        	</select>
        </td>
    </tr> 
    <input type="hidden" name="idFlag" value="${bizOrderRequired.idFlag!''}">
    <tr>
    	<td class="e_label" width="250">身份证：</td>
        <td style="text-align:left;">
        	<select id="idNumType" name="idNumType" value="${bizOrderRequired.idNumType!''}" >
        		<!-- 选择的是身份证数量 -->
            	 <#list orderRequiredTravNumMap?keys as key>
            	 	<#if key != 'TRAV_NUM_CONF'>
	                	<#if key == bizOrderRequired.idNumType>
	                		<option value="${key!''}" selected="selected">${orderRequiredTravNumMap[key]!''}</option>
	               		<#else>
	               			<#if key == 'TRAV_NUM_NO'>
	               				<option value="${key!''}" selected="selected">${orderRequiredTravNumMap[key]!''}</option>
	               			<#else>
	               				<option value="${key!''}">${orderRequiredTravNumMap[key]!''}</option>
	               			</#if>
	               		</#if>
               		</#if>
               	</#list>
        	</select>
        </td>
    </tr>
    <tr>
        <td class="e_label" width="250">email：</td>
        <td style="text-align:left;">
        	<select id="emailType" name="emailType" value="${bizOrderRequired.emailType!''}" >
        		<#list orderRequiredTravNumMap?keys as key>
        			<#if key != 'TRAV_NUM_CONF'>
	                	<#if key == bizOrderRequired.emailType>
	                		<option value="${key!''}" selected="selected">${orderRequiredTravNumMap[key]!''}</option>
	               		<#else>
	               			<#if key == 'TRAV_NUM_NO'>
	               				<option value="${key!''}" selected="selected">${orderRequiredTravNumMap[key]!''}</option>
	               			<#else>
	               				<option value="${key!''}">${orderRequiredTravNumMap[key]!''}</option>
	               			</#if>
	               		</#if>
               		</#if>
               	</#list>
        	</select>
        </td>
    </tr>