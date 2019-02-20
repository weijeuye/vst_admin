<#assign mis=JspTaglibs["/WEB-INF/pages/tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_header">
    <ul class="iframe_nav">
        <li><a href="#">后台</a> &gt;</li>
        <li><a href="#">下单必填项配置</a></li>
    </ul>
</div>
<div class="iframe_content">
<div class="tiptext tip-warning cc5">
    <p class="pl15">注：被使用定义品类的字段，需要关闭其在产品管理里面该字段创建后可修改额权限</p>
    <p class="pl15">注：删除产品上的属性时，需要看下是否被该处使用</p>      
    </div>
	<form method="post" action='/vst_admin/biz/orderRequired/showOrderRequired.do' id="reuqiredForm">
	<div class="p_box box_info">
	  <input type="hidden" name="reqId" value="${bizOrderRequired.reqId!''}">
		    <table class="s_table">
		    <tbody>
		    <tr>
	       		<td class="s_label">品类：</td>
	            <td class="w18">
	            	<select id="groupCode" name="groupCode" required=true>
	                	 <#list orderRequiredFieldMap?keys as key>
	                		<#if key == bizOrderRequired.groupCode>
	                			<option value="${key!''}" selected="selected">${orderRequiredFieldMap[key]!''}</option>
	                		<#else>
	                			<option value="${key!''}">${orderRequiredFieldMap[key]!''}</option>
	                		</#if>
	                	</#list>
	            	</select>
	            </td>
	            <td class=" operate mt10">
		            <a class="btn btn_cc1" id="btnSearch">查询</a>
		        </td>
	        </tr>
		    </tbody>
		    </table>	
	</div>
	<#if bizOrderRequired.groupCode=="FREEDOM_INNERLINE_N" || bizOrderRequired.groupCode=="GROUP_INNERSHORTLINE" 
	|| bizOrderRequired.groupCode=="HOTELCOMB_INNERLINE" || bizOrderRequired.groupCode=="FREEDOM_INNERLINE_Y" 
	|| bizOrderRequired.groupCode=="LOCAL_INNERLINE" || bizOrderRequired.groupCode=="GROUP_INNERLONGLINE"
	|| bizOrderRequired.groupCode=="GROUP_INNER_BORDER_LINE">
		<div style="text-align: center; font-size: 14px;margin-bottom: 20px;color: red" class="" id="includeContext">应企管要求，国内产品所有游玩人均必填姓名和证件号码，请勿修改。</div>
	</#if>
<!-- 主要内容显示区域\\ -->
    <div class="p_box box_info">
	<table class="p_table table_center">
        <tbody>
        	<#if bizOrderRequired.groupCode=="FINANCE_PROD">
        		<tr>
	        		<td class="e_label" width="250" width="250"><i class="cc1">*</i>是否业务配置：</td>
	            	<td style="text-align:left;">
		            	<input type="radio" name="operatorConfig" <#if bizOrderRequired.operatorConfig=='Y'>checked</#if> value="Y" required=true>&nbsp;是
		            	<input type="radio" name="operatorConfig" <#if bizOrderRequired.operatorConfig=='N'>checked</#if> value="N" required=true>&nbsp;否
		            	<span id="configureError"></span>
		            </td>
	            </tr>
	            <div id ="financeProdRequire">
		            <tr class="js-check-box">
			            <td class="e_label" width="250"><i class="cc1">*</i>姓名：</td>
			            <td style="text-align:left;">需要&nbsp;&nbsp;</td>
			        </tr>
			        <tr class="js-check-box">
			        	<td class="e_label" width="250"><i class="cc1">*</i>手机号：</td>
			            <td style="text-align:left;">
			            	<input type="radio" name="phoneNumType" <#if bizOrderRequired.phoneNumType=='Y'>checked</#if> value="Y" required=true>&nbsp;是
		            		<input type="radio" name="phoneNumType" <#if bizOrderRequired.phoneNumType=='N'>checked</#if> value="N" required=true>&nbsp;否	
		            		<span id="telError"></span>
			            </td>
			        </tr>
			        <tr class="js-check-box">
			            <td class="e_label" width="250"><i class="cc1">*</i>E-mail：：</td>
			            <td style="text-align:left;">
			            	<input type="radio" name="emailType" <#if bizOrderRequired.emailType=='Y'>checked</#if> value="Y" required=true>&nbsp;是
			        		<input type="radio" name="emailType" <#if bizOrderRequired.emailType=='N'>checked</#if> value="N" required=true>&nbsp;否	
			        		<span id="emailError"></span>
			            </td>
			        </tr>
			        <tr class="js-check-box">
		        		<td class="e_label" width="250"><i class="cc1">*</i>证件：</td>
		            	<td style="text-align:left;">
			            	<input type="radio" name="idNumType" <#if bizOrderRequired.idNumType=='Y'>checked</#if> value="Y" required=true>&nbsp;是
			        		<input type="radio" name="idNumType" <#if bizOrderRequired.idNumType=='N'>checked</#if> value="N" required=true>&nbsp;否	<span id="certificatesError"></span>
			            	<br>
			            	<label><input type="checkbox"  name="idFlag"  <#if bizOrderRequired.idFlag=='Y'>checked</#if> value="Y" >身份证</label>
			            	<label><input type="checkbox" name="passportFlag" <#if bizOrderRequired.passportFlag=='Y'>checked</#if> value="Y" >护照</label>
			            	<label><input type="checkbox" name="passFlag" <#if bizOrderRequired.passFlag=='Y'>checked</#if> value="Y" >港澳通行证</label>
			            	<label><input type="checkbox" name="twPassFlag"<#if bizOrderRequired.twPassFlag=='Y'>checked</#if> value="Y" >台湾通行证</label>
			                <label><input type="checkbox" name="twResidentFlag"<#if bizOrderRequired.twResidentFlag=='Y'>checked</#if> value="Y" >台胞证</label>
	                        <label><input type="checkbox" name="householdRegFlag" <#if bizOrderRequired.householdRegFlag=='Y'>checked</#if> value="Y" >户口簿</label>
			                <label><input type="checkbox" name="birthCertFlag" <#if bizOrderRequired.birthCertFlag=='Y'>checked</#if> value="Y" >新生儿证明</label>
                            <label><input type="checkbox" name="soldierFlag" <#if bizOrderRequired.soldierFlag=='Y'>checked</#if> value="Y" >士兵证</label>
                            <label><input type="checkbox" name="officerFlag" <#if bizOrderRequired.officerFlag=='Y'>checked</#if> value="Y" >军官证</label>
			                <label><input type="checkbox" name="hkResidentFlag" <#if bizOrderRequired.hkResidentFlag=='Y'>checked</#if> value="Y" >回乡证</label>
			            </td>
		        	</tr>
		        </div>
		    <#elseif bizOrderRequired.groupCode=="SUPER_MEMBER">
				<#include "/biz/orderRequired/superMemberOrderRequired.ftl"/>
	        <#else>
	        	 <tr>
			        	<td colspan="2" style="font-size: 16px;"><b>游玩人/取票人/入住人</b></td>
			        </tr>
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
		            		<#if key!='TRAV_NUM_NO'>
		            			<input type="radio" name="travNumType" <#if key==bizOrderRequired.travNumType>checked</#if> value="${key!''}">&nbsp;${orderRequiredTravNumMap[key]!''}
		            			<#if key == 'TRAV_NUM_CONF'>注，代表该品类无法规则化，需要业务基于不同商品做设置</#if><#if key == 'TRAV_NUM_ALL'>注，代表该品类基于“数量关联”有几个游玩人就需要填写几个</#if><#if key == 'TRAV_NUM_ONE'>注，代表该品类只需要一个游玩人即可</#if>
		            		    <br/>
		            		</#if>
		            	</#list>
		            </td>
		        </tr>
		        <tr>
		            <td colspan="2" style="font-size: 16px;"><i class="cc1">*</i><b>游玩人信息明细：</b></td>
		        </tr>
		        <tr>
		            <td class="e_label" width="250">姓名：</td>
		            <td style="text-align:left;">需要&nbsp;&nbsp;注，数量根据“填写数量调取”</td>
		        </tr>
		        <tr>
		            <td class="e_label" width="250">英文姓名：</td>
		            <td style="text-align:left;">
		            	<select id="ennameType" name="ennameType" value="${bizOrderRequired.ennameType!''}" required=true>
		            		<#list orderRequiredTravNumMap?keys as key>
			                	<#if key == bizOrderRequired.ennameType>
			                		<option value="${key!''}" selected="selected">${orderRequiredTravNumMap[key]!''}</option>
			               		<#else>
			               			<option value="${key!''}">${orderRequiredTravNumMap[key]!''}</option>
			               		</#if>
			               	</#list>
		            	</select>
		            	<span>
		            	<input type="hidden" name="listExpand[0].wordsType" value="ennameType">
		            	<input type="hidden" name="listExpand[0].objectType" value="OPTIONAL">
		            	<input type="hidden" name="listExpand[0].obejctValue" value="<#if expandMap&&expandMap['ennameType_OPTIONAL']>${expandMap['ennameType_OPTIONAL']}<#else>N</#if>">
		            	<input type="checkbox"  name='typeExpand' <#if expandMap&&expandMap['ennameType_OPTIONAL']=='Y'>checked='true'</#if>>选填
		            	</span>
		           		 <span>
		            	<input type="hidden" name="listExpand[1].wordsType" value="ennameType">
		            	<input type="hidden" name="listExpand[1].objectType" value="ONLYBACKVIEW">
		            	<input type="hidden" name="listExpand[1].obejctValue" value="<#if expandMap&&expandMap['ennameType_ONLYBACKVIEW']>${expandMap['ennameType_ONLYBACKVIEW']}<#else>N</#if>">
		            	<input type="checkbox"  name="typeExpand" <#if expandMap&&expandMap['ennameType_ONLYBACKVIEW']=='Y'>checked='true'</#if>>仅后台显示
		            	</span>
		            	
		            </td>
		        </tr>
		        <tr>
		        	<td class="e_label" width="250">手机号：</td>
		            <td style="text-align:left;">
		            	<select id="phoneNumType" name="phoneNumType" value="${bizOrderRequired.phoneNumType!''}" required=true>
		            		<#list orderRequiredTravNumMap?keys as key>
			                	<#if key == bizOrderRequired.phoneNumType>
			                		<option value="${key!''}" selected="selected">${orderRequiredTravNumMap[key]!''}</option>
			               		<#else>
			               			<option value="${key!''}">${orderRequiredTravNumMap[key]!''}</option>
			               		</#if>
			               	</#list>
		            	</select>
		            	 <span>
		            	<input type="hidden" name="listExpand[2].wordsType" value="phoneType">
		            	<input type="hidden" name="listExpand[2].objectType" value="OPTIONAL">
		            	<input type="hidden" name="listExpand[2].obejctValue" value="<#if expandMap&&expandMap['phoneType_OPTIONAL']>${expandMap['phoneType_OPTIONAL']}<#else>N</#if>">
		            	<input type="checkbox"  name='typeExpand' <#if expandMap&&expandMap['phoneType_OPTIONAL']=='Y'>checked='true'</#if>>选填
		            	</span>
		           		 <span>
		            	<input type="hidden" name="listExpand[3].wordsType" value="phoneType">
		            	<input type="hidden" name="listExpand[3].objectType" value="ONLYBACKVIEW">
		            	<input type="hidden" name="listExpand[3].obejctValue"value="<#if expandMap&&expandMap['phoneType_ONLYBACKVIEW']>${expandMap['phoneType_ONLYBACKVIEW']}<#else>N</#if>">
		            	<input type="checkbox"  name="typeExpand" <#if expandMap&&expandMap['phoneType_ONLYBACKVIEW']=='Y'>checked='true'</#if>>仅后台显示
		            	</span>
		            </td>
		        </tr>      
		        <!--当地玩乐增加境外手机号-->
		         <tr id="outBoundPhoneType">
		        	<td class="e_label" width="250">境外手机号：</td>
		            <td style="text-align:left;">
		            	<select id="phoneNumType" name="outboundPhoneType" value="${bizOrderRequired.outboundPhoneType!''}" required=true>
		            		<#list orderRequiredTravNumMap?keys as key>
			                	<#if key == bizOrderRequired.outboundPhoneType>
			                		<option value="${key!''}" selected="selected">${orderRequiredTravNumMap[key]!''}</option>
			               		<#else>
			               			<option value="${key!''}">${orderRequiredTravNumMap[key]!''}</option>
			               		</#if>
			               	</#list>
		            	</select>
		            	 <span>
		            	<input type="hidden" name="listExpand[10].wordsType" value="outboundPhoneType">
		            	<input type="hidden" name="listExpand[10].objectType" value="OPTIONAL">
		            	<input type="hidden" name="listExpand[10].obejctValue" value="<#if expandMap&&expandMap['outboundPhoneType_OPTIONAL']>${expandMap['outboundPhoneType_OPTIONAL']}<#else>N</#if>">
		            	<input type="checkbox"  name='typeExpand' <#if expandMap&&expandMap['outboundPhoneType_OPTIONAL']=='Y'>checked='true'</#if>>选填
		            	</span>
		           		 <span>
		            	<input type="hidden" name="listExpand[11].wordsType" value="outboundPhoneType">
		            	<input type="hidden" name="listExpand[11].objectType" value="ONLYBACKVIEW">
		            	<input type="hidden" name="listExpand[11].obejctValue"value="<#if expandMap&&expandMap['outboundPhoneType_ONLYBACKVIEW']>${expandMap['outboundPhoneType_ONLYBACKVIEW']}<#else>N</#if>">
		            	<input type="checkbox"  name="typeExpand" <#if expandMap&&expandMap['outboundPhoneType_ONLYBACKVIEW']=='Y'>checked='true'</#if>>仅后台显示
		            	</span>
		            </td>
		        </tr>
		        <tr>
		            <td class="e_label" width="250">email：</td>
		            <td style="text-align:left;">
		            	<select id="emailType" name="emailType" value="${bizOrderRequired.emailType!''}" required=true>
		            		<#list orderRequiredTravNumMap?keys as key>
			                	<#if key == bizOrderRequired.emailType>
			                		<option value="${key!''}" selected="selected">${orderRequiredTravNumMap[key]!''}</option>
			               		<#else>
			               			<option value="${key!''}">${orderRequiredTravNumMap[key]!''}</option>
			               		</#if>
			               	</#list>
		            	</select>
		            	 <span>
		            	<input type="hidden" name="listExpand[4].wordsType" value="emailType">
		            	<input type="hidden" name="listExpand[4].objectType" value="OPTIONAL">
		            	<input type="hidden" name="listExpand[4].obejctValue" value="<#if expandMap&&expandMap['emailType_OPTIONAL']>${expandMap['emailType_OPTIONAL']}<#else>N</#if>">
		            	<input type="checkbox"  name='typeExpand' <#if expandMap&&expandMap['emailType_OPTIONAL']=='Y'>checked='true'</#if>>选填
		            	</span>
		           		 <span>
		            	<input type="hidden" name="listExpand[5].wordsType" value="emailType">
		            	<input type="hidden" name="listExpand[5].objectType" value="ONLYBACKVIEW">
		            	<input type="hidden" name="listExpand[5].obejctValue" value="<#if expandMap&&expandMap['emailType_ONLYBACKVIEW']>${expandMap['emailType_ONLYBACKVIEW']}<#else>N</#if>">
		            	<input type="checkbox"  name="typeExpand" <#if expandMap&&expandMap['emailType_ONLYBACKVIEW']=='Y'>checked='true'</#if>>仅后台显示
		            	</span>
		            </td>
		        </tr>
		        <tr>
		            <td class="e_label" width="250">人群：</td>
		            <td style="text-align:left;">
		            	<select id="occupType" name="occupType" value="${bizOrderRequired.occupType!''}" required=true>
		            		<#list orderRequiredTravNumMap?keys as key>
			                	<#if key == bizOrderRequired.occupType>
			                		<option value="${key!''}" selected="selected">${orderRequiredTravNumMap[key]!''}</option>
			               		<#else>
			               			<option value="${key!''}">${orderRequiredTravNumMap[key]!''}</option>
			               		</#if>
			               	</#list>
		            	</select>
		            	 <span>
		            	<input type="hidden" name="listExpand[6].wordsType" value="occupType">
		            	<input type="hidden" name="listExpand[6].objectType" value="OPTIONAL">
		            	<input type="hidden" name="listExpand[6].obejctValue" value="<#if expandMap&&expandMap['occupType_OPTIONAL']>${expandMap['occupType_OPTIONAL']}<#else>N</#if>">
		            	<input type="checkbox"  name='typeExpand' <#if expandMap&&expandMap['occupType_OPTIONAL']=='Y'>checked='true'</#if>>选填
		            	</span>
		           		 <span>
		            	<input type="hidden" name="listExpand[7].wordsType" value="occupType">
		            	<input type="hidden" name="listExpand[7].objectType" value="ONLYBACKVIEW">
		            	<input type="hidden" name="listExpand[7].obejctValue" value="<#if expandMap&&expandMap['occupType_ONLYBACKVIEW']>${expandMap['occupType_ONLYBACKVIEW']}<#else>N</#if>">
		            	<input type="checkbox"  name="typeExpand" <#if expandMap&&expandMap['occupType_ONLYBACKVIEW']=='Y'>checked='true'</#if>>仅后台显示
		            	</span>
		            </td>
		        </tr>
		        <tr id="localHotelAddressType">
		            <td class="e_label" width="250">当地酒店地址：</td>
		            <td style="text-align:left;">
		            	<select id="occupType" name="localHotelAddressType" value="${(bizOrderRequired.localHotelAddressType)!''}" required=true>
			                	<option value="TRAV_NUM_CONF" <#if bizOrderRequired.localHotelAddressType=="TRAV_NUM_CONF">selected="selected"</#if>>业务配置</option>
			               		<option value="TRAV_NUM_NO" <#if bizOrderRequired.localHotelAddressType=="TRAV_NUM_NO">selected="selected"</#if>>不需要</option>
		            	</select>
		            	 <span>
		            	<input type="hidden" name="listExpand[12].wordsType" value="occupType">
		            	<input type="hidden" name="listExpand[12].objectType" value="OPTIONAL">
		            	<input type="hidden" name="listExpand[12].obejctValue" value="<#if expandMap&&expandMap['localHotelAddressType_OPTIONAL']>${expandMap['localHotelAddressType_OPTIONAL']}<#else>N</#if>">
		            	<input type="checkbox"  name='typeExpand' <#if expandMap&&expandMap['localHotelAddressType_OPTIONAL']=='Y'>checked='true'</#if>>选填
		            	</span>
		           		 <span>
		            	<input type="hidden" name="listExpand[13].wordsType" value="occupType">
		            	<input type="hidden" name="listExpand[13].objectType" value="ONLYBACKVIEW">
		            	<input type="hidden" name="listExpand[13].obejctValue" value="<#if expandMap&&expandMap['localHotelAddressType_ONLYBACKVIEW']>${expandMap['localHotelAddressType_ONLYBACKVIEW']}<#else>N</#if>">
		            	<input type="checkbox"  name="typeExpand" <#if expandMap&&expandMap['localHotelAddressType_ONLYBACKVIEW']=='Y'>checked='true'</#if>>仅后台显示
		            	</span>
		            </td>
		        </tr>
		        <tr id="useTimeType">
		            <td class="e_label" width="250">使用时间：</td>
		            <td style="text-align:left;">
		            	<select id="occupType" name="useTimeType" value="${(bizOrderRequired.useTimeType)!''}" required=true>
		            			
			                	<option value="TRAV_NUM_CONF" <#if bizOrderRequired.useTimeType='TRAV_NUM_CONF'>selected="selected"</#if> >业务配置</option>
			               		<option value="TRAV_NUM_NO" <#if bizOrderRequired.useTimeType='TRAV_NUM_NO'>selected="selected"</#if>>不需要</option>
		            	</select>
		            	 <span>
		            	<input type="hidden" name="listExpand[14].wordsType" value="occupType">
		            	<input type="hidden" name="listExpand[14].objectType" value="OPTIONAL">
		            	<input type="hidden" name="listExpand[14].obejctValue" value="<#if expandMap&&expandMap['useTimeType_OPTIONAL']>${expandMap['useTimeType_OPTIONAL']}<#else>N</#if>">
		            	<input type="checkbox"  name='typeExpand' <#if expandMap&&expandMap['useTimeType_OPTIONAL']=='Y'>checked='true'</#if>>选填
		            	</span>
		           		 <span>
		            	<input type="hidden" name="listExpand[15].wordsType" value="occupType">
		            	<input type="hidden" name="listExpand[15].objectType" value="ONLYBACKVIEW">
		            	<input type="hidden" name="listExpand[15].obejctValue" value="<#if expandMap&&expandMap['useTimeType_ONLYBACKVIEW']>${expandMap['useTimeType_ONLYBACKVIEW']}<#else>N</#if>">
		            	<input type="checkbox"  name="typeExpand" <#if expandMap&&expandMap['useTimeType_ONLYBACKVIEW']=='Y'>checked='true'</#if>>仅后台显示
		            	</span>
		            </td>
		        </tr>
		        <tr>
		        	<td class="e_label" width="250">证件：</td>
		            <td style="text-align:left;">
		            	<select id="idNumType" name="idNumType" value="${bizOrderRequired.idNumType!''}" required=true>
		                	 <#list orderRequiredTravNumMap?keys as key>
			                	<#if key == bizOrderRequired.idNumType>
			                		<option value="${key!''}" selected="selected">${orderRequiredTravNumMap[key]!''}</option>
			               		<#else>
			               			<option value="${key!''}">${orderRequiredTravNumMap[key]!''}</option>
			               		</#if>
			               	</#list>
		            	</select>
		            	<span>
		            	<input type="hidden" name="listExpand[8].wordsType" value="idNumType">
		            	<input type="hidden" name="listExpand[8].objectType" value="OPTIONAL">
		            	<input type="hidden" name="listExpand[8].obejctValue" value="<#if expandMap&&expandMap['idNumType_OPTIONAL']>${expandMap['idNumType_OPTIONAL']}<#else>N</#if>">
		            	<input type="checkbox"  name='typeExpand' <#if expandMap&&expandMap['idNumType_OPTIONAL']=='Y'>checked='true'</#if>>选填
		            	</span>
		           		 <span>
		            	<input type="hidden" name="listExpand[9].wordsType" value="idNumType">
		            	<input type="hidden" name="listExpand[9].objectType" value="ONLYBACKVIEW">
		            	<input type="hidden" name="listExpand[9].obejctValue" value="<#if expandMap&&expandMap['idNumType_ONLYBACKVIEW']>${expandMap['idNumType_ONLYBACKVIEW']}<#else>N</#if>">
		            	<input type="checkbox"  name="typeExpand" <#if expandMap&&expandMap['idNumType_ONLYBACKVIEW']=='Y'>checked='true'</#if>>仅后台显示
		            	</span>
		            	<br>
		            	<div id="idNumTypeShow">
		            	身份证：
		            	<input type="radio" name="idFlag" <#if bizOrderRequired.idFlag=='Y'>checked</#if> value="Y" >&nbsp;是
		            	<input type="radio" name="idFlag" <#if bizOrderRequired.idFlag=='N'>checked</#if> value="N" >&nbsp;否
		            	<br>
		            	护&nbsp;&nbsp;&nbsp;照：
		            	<input type="radio" name="passportFlag" <#if bizOrderRequired.passportFlag=='Y'>checked</#if> value="Y" >&nbsp;是
		            	<input type="radio" name="passportFlag" <#if bizOrderRequired.passportFlag=='N'>checked</#if> value="N" >&nbsp;否
		            	<br>
		            	是否港澳通行证：
		            	<input type="radio" name="passFlag" <#if bizOrderRequired.passFlag=='Y'>checked</#if> value="Y" >&nbsp;是
		            	<input type="radio" name="passFlag" <#if bizOrderRequired.passFlag=='N'>checked</#if> value="N" >&nbsp;否
		            	<br>
		            	是否台湾通行证:
		            	<input type="radio" name="twPassFlag" <#if bizOrderRequired.twPassFlag=='Y'>checked</#if> value="Y" >&nbsp;是
		            	<input type="radio" name="twPassFlag" <#if bizOrderRequired.twPassFlag=='N'>checked</#if> value="N" >&nbsp;否
		            	<br>
		                                                 是否台胞证:
		                <input type="radio" name="twResidentFlag" <#if bizOrderRequired.twResidentFlag=='Y'>checked</#if> value="Y" >&nbsp;是
		                <input type="radio" name="twResidentFlag" <#if bizOrderRequired.twResidentFlag=='N'>checked</#if> value="N" >&nbsp;否
		                <br>
		                                                是否出生证明(婴儿):
		                <input type="radio" name="birthCertFlag" <#if bizOrderRequired.birthCertFlag=='Y'>checked</#if> value="Y" >&nbsp;是
		                <input type="radio" name="birthCertFlag" <#if bizOrderRequired.birthCertFlag=='N'>checked</#if> value="N" >&nbsp;否
		                <br>
		                                               是否户口簿(儿童):
		                <input type="radio" name="householdRegFlag" <#if bizOrderRequired.householdRegFlag=='Y'>checked</#if> value="Y" >&nbsp;是
		                <input type="radio" name="householdRegFlag" <#if bizOrderRequired.householdRegFlag=='N'>checked</#if> value="N" >&nbsp;否
		                <br>
		                                                是否士兵证:
		                <input type="radio" name="soldierFlag" <#if bizOrderRequired.soldierFlag=='Y'>checked</#if> value="Y" >&nbsp;是
		                <input type="radio" name="soldierFlag" <#if bizOrderRequired.soldierFlag=='N'>checked</#if> value="N" >&nbsp;否
		                <br>
		                                                是否军官证:
		                <input type="radio" name="officerFlag" <#if bizOrderRequired.officerFlag=='Y'>checked</#if> value="Y" >&nbsp;是
		                <input type="radio" name="officerFlag" <#if bizOrderRequired.officerFlag=='N'>checked</#if> value="N" >&nbsp;否
		                <br>
		                                                 是否回乡证(港澳居民):
		                <input type="radio" name="hkResidentFlag" <#if bizOrderRequired.hkResidentFlag=='Y'>checked</#if> value="Y" >&nbsp;是
		                <input type="radio" name="hkResidentFlag" <#if bizOrderRequired.hkResidentFlag=='N'>checked</#if> value="N" >&nbsp;否
		            	</div>
		            </td>
		        </tr>
		        <tr style="display:none;">
		            <td colspan="2" style="font-size: 16px;">紧急联系人：<i class="cc1"><b>注，紧急联系人，若需要，则仅会出现一个让用户输入</b></i></td>
		        </tr>
		        <tr style="display:none;">
		        	<td class="e_label" width="250"><i class="cc1">*</i>是否需要紧急联系人：</td>
		        	<td style="text-align:left;">
			        	<input type="radio" name="ecFlag" value="Y">&nbsp;是
			            <input type="radio" name="ecFlag" checked value="N">&nbsp;否
		        	</td>
		        </tr>
		         <#if bizOrderRequired.groupCode=='SINGLE_TICKET'>
		        <tr>
		            <td colspan="2" style="font-size: 16px;"><i class="cc1">*</i><b>导游</b></td>
		        </tr>
		        <tr>
		            <td class="e_label" width="250"><i class="cc1">*</i>是否需要导游信息：</td>
		             <td style="text-align:left;">          	
		            	<input type="radio" name="needGuideFlag" <#if bizOrderRequired.needGuideFlag!='TRAV_NUM_CONF'>checked</#if> value="TRAV_NUM_NO">&nbsp;不需要<br/>
		            	<input type="radio" name="needGuideFlag" <#if bizOrderRequired.needGuideFlag=='TRAV_NUM_CONF'>checked</#if> value="TRAV_NUM_CONF">&nbsp;业务配置&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注，适用于团队票，每单一个导游信息，需要业务基于不同商品做设置
		            </td>
		        </tr>
		        
		         <tr id="detail1">
		            <td colspan="2" style="font-size: 16px;"><i class="cc1">*</i><b>导游信息明细</b></td>
		        </tr>
		        <tr id="detail2">
		            <td class="e_label" width="250">导游姓名：</td>
		            <td style="text-align:left;">
		                 <select id="guideNameType" name="guideNameType" required=true>
		                    <option value="NEED" selected="selected">需要</option>
		            		
		            	</select>
		                                                           <!--需要
		                 <input type="hidden" name="guideNameType" value="NEED">
		                 -->
		            </td>
		            
		        </tr>
		        <tr id="detail4">
		            <td class="e_label" width="250">手机号：</td>
		            <td style="text-align:left;">
		            	<select id="guidePhoneType" name="guidePhoneType"  required=true>
		            	    <option value="NEED" selected="selected">需要</option>
		            	</select>
		            	<!--
		            	<span>
		            	<input type="hidden" name="listExpand[17].wordsType" value="guidePhoneType">
		            	<input type="hidden" name="listExpand[17].objectType" value="OPTIONAL">
		            	<input type="hidden" name="listExpand[17].obejctValue" value="<#if expandMap&&expandMap['guidePhoneType_OPTIONAL']>${expandMap['guidePhoneType_OPTIONAL']}<#else>N</#if>">
		            	<input type="checkbox"  name='typeExpand' <#if expandMap&&expandMap['guidePhoneType_OPTIONAL']=='Y'>checked='true'</#if>>选填
		            	</span>
		           		-->
		            </td>
		        </tr>
		        <tr id="detail3">
		            <td class="e_label" width="250">导游证号：</td>
		            <td style="text-align:left;">
		            	<select id="guideNoType" name="guideNoType" value="${bizOrderRequired.guideNoType!''}" required=true>
		            		<#list orderNeedTravNumMap?keys as key>
			                	<#if key == bizOrderRequired.guideNoType>
			                		<option value="${key!''}" selected="selected">${orderNeedTravNumMap[key]!''}</option>
			               		<#else>
			               			<option value="${key!''}">${orderNeedTravNumMap[key]!''}</option>
			               		</#if>
			               	</#list>
		            	</select>
		            	<span>
		            	<input type="hidden" name="listExpand[16].wordsType" value="guideNoType">
		            	<input type="hidden" name="listExpand[16].objectType" value="OPTIONAL">
		            	<input type="hidden" name="listExpand[16].obejctValue" value="<#if expandMap&&expandMap['guideNoType_OPTIONAL']>${expandMap['guideNoType_OPTIONAL']}<#else>N</#if>">
		            	<input type="checkbox"  name='typeExpand' <#if expandMap&&expandMap['guideNoType_OPTIONAL']=='Y'>checked='true'</#if>>选填
		            	</span>
		           		
		            </td>
		        </tr>
		        
		        <tr id="detail5">
		            <td class="e_label" width="250">身份证号：</td>
		            <td style="text-align:left;">
		            	<select id="guideIdType" name="guideIdType" value="${bizOrderRequired.guideIdType!''}" required=true>
		            		<#list orderNeedTravNumMap?keys as key>
			                	<#if key == bizOrderRequired.guideIdType>
			                		<option value="${key!''}" selected="selected">${orderNeedTravNumMap[key]!''}</option>
			               		<#else>
			               			<option value="${key!''}">${orderNeedTravNumMap[key]!''}</option>
			               		</#if>
			               	</#list>
		            	</select>
		            	<span>
		            	<input type="hidden" name="listExpand[18].wordsType" value="guideIdType">
		            	<input type="hidden" name="listExpand[18].objectType" value="OPTIONAL">
		            	<input type="hidden" name="listExpand[18].obejctValue" value="<#if expandMap&&expandMap['guidePhoneType_OPTIONAL']>${expandMap['guideIdType_OPTIONAL']}<#else>N</#if>">
		            	<input type="checkbox"  name='typeExpand' <#if expandMap&&expandMap['guideIdType_OPTIONAL']=='Y'>checked='true'</#if>>选填
		            	</span>
		           		
		            </td>
		        </tr>
		       
		        </#if>
        	</#if>
	       
        <tr>
        	<td class="operate mt10" colspan="2" style="font-size: 16px;">
        	    <#if bizOrderRequired.reqId??>
		       	<a href="javascript:void(0);" class="btn btn_cc1 showLogDialog" param='parentId=${bizOrderRequired.reqId}&parentType=PROD_PRODUCT&sysName=VST'>操作日志</a>
		       	<#else>
		       	<a href="javascript:void(0);" style="background-color:gray;" class="btn btn_cc2" param='parentId=${bizOrderRequired.reqId}&parentType=PROD_PRODUCT&sysName=VST'>操作日志</a>
		       	</#if>
			    <a class="btn btn_cc1" id="btnSave">保存</a>
		    </td>
        </tr>     
        </tbody>
    </table>
	</div><!-- div p_box -->
</form>
</div><!-- //主要内容显示区域 -->
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
$(function(){
	//交通接驳出境的产品有出境手机号
	if(!isConnects()){
		var $outPhone = $("#outBoundPhoneType");
		$outPhone.attr("style","display:none;");
		$outPhone.find("select").attr("disabled","disabled");
		$outPhone.find("input").attr("disabled","disabled");
	}
	showFoodAndSport();//美食和娱乐显示当地酒店地址和使用时间
	
	
	if($("select[name=idNumType] option:selected").val()=='TRAV_NUM_NO' || $("select[name=idNumType] option:selected").val()=='TRAV_NUM_CONF'){
		$("#idNumTypeShow").hide();
	}else{
		$("#idNumTypeShow").show();
	}
	if($("#groupCode").val() == 'FINANCE_PROD'){
		if($("[name='operatorConfig']:checked").val() === 'N'){
            $("[name='operatorConfig']:checked").parents('tr').siblings('.js-check-box').show();
        }else{
            $("[name='operatorConfig']:checked").parents('tr').siblings('.js-check-box').hide();
        }
    	if($("input[name='idNumType']:checked").val() === 'N'){
            $("input[name='idNumType']:checked").siblings('label').find('input').attr("disabled",true);
        }else{
           $("input[name='idNumType']:checked").siblings('label').find('input').attr("disabled",false);
        }
	}
	
});
	$("input[name=operatorConfig]").change(function(){
		var This =$(this);
		if($("input[name='operatorConfig']:checked").val() === 'Y'){
			This.parents('tr').siblings('.js-check-box').hide();
		}else{
			This.parents('tr').siblings('.js-check-box').show();
		}
	
	});
	
	$("select[name=idNumType]").change(function(){
		if($("select[name=idNumType] option:selected").val()=='TRAV_NUM_NO' || $("select[name=idNumType] option:selected").val()=='TRAV_NUM_CONF'){
			$("#idNumTypeShow").hide();
		}else{
			$("#idNumTypeShow").show();
		}
	});

	$("input[name=idNumType]").change(function(){
		var This =$(this);
		if($("input[name='idNumType']:checked").val() === 'Y'){
			This.siblings('label').find('input').attr("disabled",false);
		}else {
			This.siblings('label').find('input').attr("disabled",true);
		}
	});
	


//修改合同
$("#btnSave").click(function(){


	$("#reuqiredForm").validate({
		rules: {
			 'ecFlag':{ required:true },
			 'needTravFlag':{ required:true },
			 'travNumType':{ required:function(){return $("input[name='needTravFlag']:checked").val() === 'Y';} }
		}
	});
	if(!$("#reuqiredForm").validate().form()){
        return false;
    }
    if($("#groupCode").val() == 'FINANCE_PROD'){
    	if($("input[name='idNumType']:checked").val() === 'Y'){
			if(!$("input[name='idFlag']").is(":checked") && !$("input[name='passportFlag']").is(":checked") && !$("input[name='passFlag']").is(":checked") && !$("input[name='twPassFlag']").is(":checked")
				&& !$("input[name='twResidentFlag']").is(":checked") && !$("input[name='householdRegFlag']").is(":checked") && !$("input[name='birthCertFlag']").is(":checked")
				&& !$("input[name='soldierFlag']").is(":checked") && !$("input[name='officerFlag']").is(":checked") && !$("input[name='hkResidentFlag']").is(":checked")
			){
				$.alert("请勾选证件");
				return false;
			}
		}
    }
    if($("#groupCode").val() == 'SUPER_MEMBER'){
    	//根据idNumType去判断是否需要身份证
    	if($("select[name=idNumType] option:selected").val()=='TRAV_NUM_NO'){
    		$("input[name='idFlag']").val("N");
    	}else{
    		$("input[name='idFlag']").val("Y");
    	}
    }
	var resultCode;
	$.ajax({
		url : "/vst_admin/biz/orderRequired/addOrModifyOrderRequired.do",
		type : "post",
		data : $("#reuqiredForm").serialize(),
		dataType:'JSON',
		success : function(result) {
			resultCode=result.code;
			confirmAndRefresh(result);
		}
	});
});

$("#btnSearch").click(function(){
	$("#reuqiredForm").submit();
});

$("#groupCode").change(function(){
	
	$("#reuqiredForm").submit();
})

function confirmAndRefresh(result){
	if (result.code == "success") {
		pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
			$("#searchForm").submit();
		}});
	}else {
		pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
		}});
	}
}


	$("input[name='typeExpand']").change(function(){
       if($(this).is(':checked')){
       	$(this).parent().find("input[name$='obejctValue']").val("Y");
       }else{
       		$(this).parent().find("input[name$='obejctValue']").val("N");
       }
	});
	//是否是交通接驳出境的
	function isConnects(){
		if($("#groupCode").val()=="CONNECTS_OUT"){
			return true;
		}
		return false;
	}
	//美食和娱乐显示当地酒店地址和使用时间
	function showFoodAndSport(){
		if($("#groupCode").val()!="FOOD" && $("#groupCode").val()!="SPORT"){
			$("#localHotelAddressType").css("display","none");
			$("#useTimeType").css("display","none");
		}
        if($("#groupCode").val()=="FOOD"){
            $("#localHotelAddressType").css("display","none");
        }

	}
	
	var needGuideFlag=$("input[name='needGuideFlag'][checked]").val();
	if(needGuideFlag=='TRAV_NUM_NO'){
	     $("#detail1").hide();
	     $("#detail2").hide();
	     $("#detail3").hide();
	     $("#detail4").hide();
	     $("#detail5").hide();
	}
	
	$("input[name=needGuideFlag]").click(function(){
	     var value = $(this).val();
	     
	     if(value=='TRAV_NUM_CONF'){
	        $("#detail1").show();
	        $("#detail2").show();
	        $("#detail3").show();
	        $("#detail4").show();
	        $("#detail5").show();
	     }else{
	        $("#detail1").hide();
	        $("#detail2").hide();
	        $("#detail3").hide();
	        $("#detail4").hide();
	        $("#detail5").hide();
	     }
	});
</script>