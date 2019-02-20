		<#if categoryId?? && categoryId==4>
			<div class="title">
				   <h2 class="f16">预订限制</h2>
			</div>
		</#if>
	     <form id="reservationLimitForm">
	     	<input type="hidden" name="categoryId" value="${categoryId!''}" />
	     	<input type="hidden" name="reqId" value="${(comOrderRequired.reqId)!''}" />
	     	<#if prodProduct?? && prodProduct.productId??>
	     	<input type="hidden" name="objectId" value="${(prodProduct.productId)!''}" />
	     	<#else>
	     	<input type="hidden" name="objectId" value="${suppGoodsId!''}" />
	     	</#if>
			<div class="box_content">
				<div id="travNum">
			 		<table class="e_table form-inline">
			 			<tr> 
			 				<td class="e_label" width="150">
			 					<label><i class="cc1">*</i>1笔订单需要的“游玩人/取票人”数量：</label>
			 				</td>
			 				<td>
							  	<#list travNumTypeList as list>
							  		<#if list.code=='TRAV_NUM_ONE' || list.code=='TRAV_NUM_ALL'>
								  		<input type="radio" name="travNumType" value="${list.code!''}"
											   <#if (comOrderRequired.travNumType)?? &&	comOrderRequired.travNumType==list.code>checked</#if> required/>${list.cnName!''}
								  		<#if list.code=='TRAV_NUM_ONE'>
								  			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <span style="color:grey">注，代表该品类只需要一个游玩人即可。</span>
								  		<#elseif list.code=='TRAV_NUM_ALL'>
								  			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <span style="color:grey">注，代表该品类基于“数量关联”有几个游玩人就需要填写几个。</span>
								  		</#if>
								  		<#if travNumTypeList?size-4!=list_index>
								  			</br>
								  		</#if>
							  		</#if>
							  	</#list>
							  	<div class="e_error" id="travNumTypeError"/>
			 				</td>
					 	</tr>
					 </table></br>
				 </div>
				 <div id="ennameNum">
					 <table class="e_table form-inline">
			 			<tr>
			 				<td class="e_label" width="150">
			 					<label><i class="cc1">*</i>英文姓名：</label>
			 				</td>
			 				<td>
							  	<#list travNumTypeList as list>
							  		<#if list.code=='TRAV_NUM_ONE' || list.code=='TRAV_NUM_ALL'>
								  		<input type="radio" name="ennameType" value="${list.code!''}"
											   <#if (comOrderRequired.ennameType)?? && comOrderRequired.ennameType==list.code>checked</#if> required/>${list.cnName!''}
								  		<#if list.code=='TRAV_NUM_ONE'>
								  			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <span style="color:grey">注，代表该品类只需要一个游玩人即可。</span>
								  		<#elseif list.code=='TRAV_NUM_ALL'>
								  			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <span style="color:grey">注，代表该品类基于“数量关联”有几个游玩人就需要填写几个。</span>
								  		</#if>
								  		<#if travNumTypeList?size-2!=list_index>
								  			</br>
								  		</#if>
							  		<#elseif list.code=='TRAV_NUM_NO'>
								  		<input type="radio" name="ennameType" value="${list.code!''}"
											   <#if (comOrderRequired.ennameType)?? && comOrderRequired.ennameType==list.code>checked</#if> required/>${list.cnName!''}
								  		<#if travNumTypeList?size-2!=list_index>
								  			</br>
								  		</#if>
							  		</#if>
							  	</#list>
							  	<div class="e_error" id="ennameTypeError"/>
			 				</td>
					 	</tr>
			 		 </table></br>
				 </div>
				 <div id="occupNum">
					 <table class="e_table form-inline">
			 			<tr>
			 				<td class="e_label" width="150">
			 					<label><i class="cc1">*</i>人群：</label>
			 				</td>
			 				<td>
							  	<#list travNumTypeList as list>
							  		<#if list.code=='TRAV_NUM_ONE' || list.code=='TRAV_NUM_ALL'>
								  		<input type="radio" name="occupType" value="${list.code!''}"
											   <#if (comOrderRequired.occupType)?? && comOrderRequired.occupType==list.code>checked</#if> required/>${list.cnName!''}
								  		<#if list.code=='TRAV_NUM_ONE'>
								  			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <span style="color:grey">注，代表该品类只需要一个游玩人即可。</span>
								  		<#elseif list.code=='TRAV_NUM_ALL'>
								  			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <span style="color:grey">注，代表该品类基于“数量关联”有几个游玩人就需要填写几个。</span>
								  		</#if>
								  		<#if travNumTypeList?size-2!=list_index>
								  			</br>
								  		</#if>
							  		<#elseif list.code=='TRAV_NUM_NO'>
								  		<input type="radio" name="occupType" value="${list.code!''}"
											   <#if (comOrderRequired.occupType)?? && comOrderRequired.occupType==list.code>checked</#if> required/>${list.cnName!''}
								  		<#if travNumTypeList?size-2!=list_index>
								  			</br>
								  		</#if>
							  		</#if>
							  	</#list>
							  	<div class="e_error" id="occupTypeError"/>
			 				</td>
					 	</tr>
			 		 </table></br>
			 	  </div>
			 	  <div id="phoneNum">
					 <table class="e_table form-inline">
			 			<tr>
			 				<td class="e_label" width="150">
			 					<label><i class="cc1">*</i>手机号：</label>
			 				</td>
			 				<td>
							  	<#list travNumTypeList as list>
							  		<#if list.code=='TRAV_NUM_ONE' || list.code=='TRAV_NUM_ALL'>
								  		<input type="radio" name="phoneType" value="${list.code!''}"
											   <#if (comOrderRequired.phoneType)?? && comOrderRequired.phoneType==list.code>checked</#if> required/>${list.cnName!''}
								  		<#if list.code=='TRAV_NUM_ONE'>
								  			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <span style="color:grey">注，代表该品类只需要一个游玩人即可。</span>
								  		<#elseif list.code=='TRAV_NUM_ALL'>
								  			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <span style="color:grey">注，代表该品类基于“数量关联”有几个游玩人就需要填写几个。</span>
								  		</#if>						  		
								  		<#if travNumTypeList?size-2!=list_index>
								  			</br>
								  		</#if>
							  		<#elseif list.code=='TRAV_NUM_NO'>
								  		<input type="radio" name="phoneType" value="${list.code!''}"
											   <#if (comOrderRequired.phoneType)?? && comOrderRequired.phoneType==list.code>checked</#if> required/>${list.cnName!''}
								  		<#if travNumTypeList?size-2!=list_index>
								  			</br>
								  		</#if>
							  		</#if>	
							  	</#list>
							  	<div class="e_error" id="phoneTypeError"/>
			 				</td>
					 	</tr>
			 		</table></br>
		 		 </div>
                <!-- 新增境外手机号 start -->
                <div id="outboundPhoneNum">
                    <table class="e_table form-inline">
                        <tr>
                            <td class="e_label" width="150">
                                <label><i class="cc1">*</i>境外手机号：</label>
                            </td>
                            <td>
								<#list travNumTypeList as list>
									<#if list.code=='TRAV_NUM_ONE' || list.code=='TRAV_NUM_ALL'>
										<input type="radio" name="outboundPhoneType" value="${list.code!''}"
											   <#if (comOrderRequired.outboundPhoneType)?? && comOrderRequired.outboundPhoneType==list.code>checked</#if> required/>${list.cnName!''}
										<#if list.code=='TRAV_NUM_ONE'>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <span style="color:grey">注，代表该品类只需要一个游玩人即可。</span>
										<#elseif list.code=='TRAV_NUM_ALL'>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <span style="color:grey">注，代表该品类基于“数量关联”有几个游玩人就需要填写几个。</span>
										</#if>
										<#if travNumTypeList?size-2!=list_index>
											</br>
										</#if>
									<#elseif list.code=='TRAV_NUM_NO'>
										<input type="radio" name="outboundPhoneType" value="${list.code!''}"
											   <#if (comOrderRequired.outboundPhoneType)?? && comOrderRequired.outboundPhoneType==list.code>checked</#if> required/>${list.cnName!''}
										<#if travNumTypeList?size-2!=list_index>
											</br>
										</#if>
									</#if>
								</#list>
                                <div class="e_error" id="phoneTypeError"/>
                            </td>
                        </tr>
                    </table></br>
                </div>
                <!-- 新增境外手机号 end -->
                
               
		 		 <div id="emailNum">
				 <table class="e_table form-inline">
		 			<tr>
		 				<td = class="e_label"  width="150">
		 					<label><i class="cc1">*</i>email：</label>
		 				</td>
		 				<td>
						  	<#list travNumTypeList as list>
						  		<#if list.code=='TRAV_NUM_ONE' || list.code=='TRAV_NUM_ALL'>
							  		<input type="radio" name="emailType" value="${list.code!''}"
										   <#if (comOrderRequired.emailType)?? && comOrderRequired.emailType==list.code>checked</#if> required/>${list.cnName!''}
							  		<#if list.code=='TRAV_NUM_ONE'>
							  			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <span style="color:grey">注，代表该品类只需要一个游玩人即可。</span>
							  		<#elseif list.code=='TRAV_NUM_ALL'>
							  			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <span style="color:grey">注，代表该品类基于“数量关联”有几个游玩人就需要填写几个。</span>
							  		</#if>						  		
							  		<#if travNumTypeList?size-2!=list_index>
							  			</br>
							  		</#if>
						  		<#elseif list.code=='TRAV_NUM_NO'>
							  		<input type="radio" name="emailType" value="${list.code!''}"
										   <#if (comOrderRequired.emailType)?? && comOrderRequired.emailType==list.code>checked</#if> required/>${list.cnName!''}
							  		<#if travNumTypeList?size-2!=list_index>
							  			</br>
							  		</#if>
						  		</#if>
						  	</#list>
						  	<div class="e_error" id="emailTypeError"/>
		 				</td>
				 	</tr>
		 		 </table></br>
		 		 </div>
		 		 <!--新增是否需要使用时间start-->
		 		 <div id="useTimeFlag">
			 		<table class="e_table form-inline">
			 			<tr> 
			 				<td class="e_label" width="150">
			 					<label><i class="cc1">*</i>使用时间:</label>
			 				</td>
			 				<td>
			 					  <input type="radio" name="useTimeFlag" value="Y" <#if comOrderRequired?? && comOrderRequired.useTimeFlag=='Y'>checked</#if> required/>需要
			 					  <br/>
							  	  <input type="radio" name="useTimeFlag" value="N" <#if comOrderRequired?? &&comOrderRequired.useTimeFlag=='N'>checked</#if> required/>不需要
							  	  <div class="e_error" id="useTimeFlagTypeError"/>
			 				</td>
					 	</tr>
					 </table></br>
				 </div>
		 		 <!--新增是否需要使用时间end-->
		 		 <!--新增是否需要当地酒店地址start-->
		 		 <div id="localHotelAddressFlag">
			 		<table class="e_table form-inline">
			 			<tr> 
			 				<td class="e_label" width="150">
			 					<label><i class="cc1">*</i>当地酒店地址(英文):</label>
			 				</td>
			 				<td>
			 					  <input type="radio" name="localHotelAddressFlag" value="Y" <#if comOrderRequired?? && comOrderRequired.localHotelAddressFlag=='Y'>checked</#if> required/>需要
			 					  <br/>
							  	  <input type="radio" name="localHotelAddressFlag" value="N" <#if comOrderRequired?? &&comOrderRequired.localHotelAddressFlag=='N'>checked</#if> required/>不需要
							  	  <div class="e_error" id="localHotelAddressTypeError"/>
			 				</td>
					 	</tr>
					 </table></br>
				 </div>
		 		 <!--新增是否需要当地酒店地址end-->
		 		 <div id="credNum">
				 <table class="e_table form-inline">
		 			<tr>
		 				<td class="e_label" width="150">
		 					<label><i class="cc1">*</i>证件：</label>
		 				</td>
		 				<td>
						  	<#list travNumTypeList as list>
						  		<#if list.code=='TRAV_NUM_ONE' || list.code=='TRAV_NUM_ALL'>
						  			<input type="radio" name="credType" value="${list.code!''}"
										   <#if (comOrderRequired.credType)?? && comOrderRequired.credType==list.code>checked</#if> required/>
						  			${list.cnName!''}
							  		<#if list.code=='TRAV_NUM_ONE'>
							  			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <span style="color:grey">注，代表该品类只需要一个游玩人即可。</span>
							  		<#elseif list.code=='TRAV_NUM_ALL'>
							  			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <span style="color:grey">注，代表该品类基于“数量关联”有几个游玩人就需要填写几个。</span>
							  		</#if>
						  			<#if travNumTypeList?size-2!=list_index></br></#if>
						  		<#elseif list.code=='TRAV_NUM_NO'>
							  		<input type="radio" name="credType" value="${list.code!''}"
										   <#if (comOrderRequired.credType)?? && comOrderRequired.credType==list.code>checked</#if> required/>${list.cnName!''}
							  		<#if travNumTypeList?size-2!=list_index></br></#if>
						  		</#if>
						  	</#list>
						  	<div class="e_error" id="credTypeError"/>
		 				</td>
				 	</tr>
		 		</table></br>
		 		</div>
		 		<div id="credNumType">
				<table class="e_table form-inline" >
		 			<tr>
		 				<td class="e_label" width="150" rowspan=10>
		 					<label><i class="cc1">*</i>可用证件类型：</label>
		 				</td>
		 				<td>
		 					<i class="cc1">*</i>身份证：&nbsp;<input type="radio" name="idFlag" value="N" <#if !comOrderRequired || comOrderRequired.idFlag=='N'>checked</#if> required/>不可用&nbsp;
							<input type="radio" name="idFlag" value="Y" <#if comOrderRequired?? && comOrderRequired.idFlag=='Y'>checked</#if> required/>可用<div class="e_error" id="idFlagError"/>
		 				</td>
				 	</tr>
				 	<tr>
		 				<td>
		 					<i class="cc1">*</i>护照：&nbsp;&nbsp;&nbsp;<input type="radio" name="passportFlag" value="N" <#if !comOrderRequired || comOrderRequired.passportFlag=='N'>checked</#if> required/>不可用&nbsp;
							<input type="radio" name="passportFlag" value="Y" <#if comOrderRequired?? && comOrderRequired.passportFlag=='Y'>checked</#if> required/>可用<div class="e_error" id="passportFlagError"/>
		 				</td>
				 	</tr>
				 	<tr>
		 				<td>
		 					<i class="cc1">*</i>港澳通行证：<input type="radio" name="passFlag" value="N" <#if !comOrderRequired || comOrderRequired.passFlag=='N'>checked</#if> required/>不可用&nbsp;
		 					<input type="radio" name="passFlag" value="Y" <#if comOrderRequired?? && comOrderRequired.passFlag=='Y'>checked</#if> required/>可用<div class="e_error" id="passFlagError"/>
		 				</td>
				 	</tr>
				 	<tr>
		 				<td>
		 					<i class="cc1">*</i>台湾通行证：
		 					<input type="radio" name="twPassFlag" value="N" <#if !comOrderRequired || comOrderRequired.twPassFlag=='N'>checked</#if> required/>不可用&nbsp;
		 					<input type="radio" name="twPassFlag" value="Y" <#if comOrderRequired?? && comOrderRequired.twPassFlag=='Y'>checked</#if> required/>可用<div class="e_error" id="twPassFlagError"/>
		 				</td>
				 	</tr>
				 	<tr>
                        <td>
                            <i class="cc1">*</i>台胞证：
                            <input type="radio" name="twResidentFlag" value="N" <#if !comOrderRequired || comOrderRequired.twResidentFlag=='N'>checked</#if> required/>不可用&nbsp;
                            <input type="radio" name="twResidentFlag" value="Y" <#if comOrderRequired?? && comOrderRequired.twResidentFlag=='Y'>checked</#if> required/>可用<div class="e_error" id="twResidentFlagError"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <i class="cc1">*</i>出生证明(婴儿)：
                            <input type="radio" name="birthCertFlag" value="N" <#if !comOrderRequired || comOrderRequired.birthCertFlag=='N'>checked</#if> required/>不可用&nbsp;
                            <input type="radio" name="birthCertFlag" value="Y" <#if comOrderRequired?? && comOrderRequired.birthCertFlag=='Y'>checked</#if> required/>可用<div class="e_error" id="birthCertFlagError"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <i class="cc1">*</i>户口簿(儿童)：
                            <input type="radio" name="householdRegFlag" value="N" <#if !comOrderRequired || comOrderRequired.householdRegFlag=='N'>checked</#if> required/>不可用&nbsp;
                            <input type="radio" name="householdRegFlag" value="Y" <#if comOrderRequired?? && comOrderRequired.householdRegFlag=='Y'>checked</#if> required/>可用<div class="e_error" id="householdRegFlagError"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <i class="cc1">*</i>士兵证：
                            <input type="radio" name="soldierFlag" value="N" <#if !comOrderRequired || comOrderRequired.soldierFlag=='N'>checked</#if> required/>不可用&nbsp;
                            <input type="radio" name="soldierFlag" value="Y" <#if comOrderRequired?? && comOrderRequired.soldierFlag=='Y'>checked</#if> required/>可用<div class="e_error" id="soldierFlagError"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <i class="cc1">*</i>军官证：
                            <input type="radio" name="officerFlag" value="N" <#if !comOrderRequired || comOrderRequired.officerFlag=='N'>checked</#if> required/>不可用&nbsp;
                            <input type="radio" name="officerFlag" value="Y" <#if comOrderRequired?? && comOrderRequired.officerFlag=='Y'>checked</#if> required/>可用<div class="e_error" id="officerFlagError"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <i class="cc1">*</i>回乡证(港澳居民)：
                            <input type="radio" name="hkResidentFlag" value="N" <#if !comOrderRequired || comOrderRequired.hkResidentFlag=='N'>checked</#if> required/>不可用&nbsp;
                            <input type="radio" name="hkResidentFlag" value="Y" <#if comOrderRequired?? && comOrderRequired.hkResidentFlag=='Y'>checked</#if> required/>可用<div class="e_error" id="hkResidentFlagError"/>
                        </td>
                    </tr>       				 					 	
		 		</table>
		 		</div>	 		
			 </div>
			 <#if  categoryId==11>
			 <#if  goodsSpec=='TEAM'>
			 <div id="needGuideFlag">
					 <table class="e_table form-inline">
			 			<tr>
			 				<td class="e_label" width="150">
			 					<label><i class="cc1">*</i>是否需要导游信息：</label>
			 				</td>
			 				<td>
			 				    <input type="radio" name="needGuideFlag" value="TRAV_NUM_NO" <#if !comOrderRequired || comOrderRequired.needGuideFlag!='NEED'>checked</#if>  required/>不需要<br/>
							  	<input type="radio" name="needGuideFlag" value="NEED" <#if comOrderRequired?? && comOrderRequired.needGuideFlag=='NEED'>checked</#if>  required/>需要  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <span style="color:grey">注，适用于团队票，需导游带领才能取票。</span>
			 				</td>
					 	</tr>
			 		 </table></br>
			 </div>
			 <div id="needGuideDetail">
					 <table class="e_table form-inline">
			 			<tr>
			 				<td class="e_label" width="150">
			 					
			 				</td>
			 				<td>
			 				    <div id="guideNameType">
			 				        <input type="checkbox" name="guideNameType" value="NEED" checked />导游姓名<br/>
			 				    </div>
			 				    <div id="guidePhoneType">
							  	   <input type="checkbox" name="guidePhoneType" value="NEED" checked />导游手机号<br/>
							  	 </div>
							  	 <div id="guideNoType">
							  	     <input type="checkbox" name="guideNoType" value="NEED" <#if comOrderRequired?? && comOrderRequired.guideNoType=='NEED'>checked</#if> />导游证号<br/>
							  	 </div>
							  	 <div id="guideIdType">
							  	     <input type="checkbox" name="guideIdType" value="NEED" <#if comOrderRequired?? && comOrderRequired.guideIdType=='NEED'>checked</#if> />身份证号<br/>
							  	</div>
			 				</td>
					 	</tr>
			 		 </table></br>
			 </div>
			 </#if>
			 </#if>
		 </form>
 <input id="showCredNumType" value="Y" type="hidden"/>
<script>

	$(function(){
		// 如果选择不需要证件，就将证件类型隐藏掉
		if($("input[name=credType]:checked").val()=='TRAV_NUM_NO'){
			$("#credNumType").hide();
		}
        //默认没有境外手机号
		hideOutPhoneDiv();
		//默认不显示当地玩乐属性
		hidePlayProp();
	});

    //隐藏境外手机号
	function hideOutPhoneDiv() {
        var outboundPhoneType = $("#outboundPhoneNum");
        outboundPhoneType.hide();
        outboundPhoneType.find("input").attr("disabled","disabled");
    }
    //隐藏当地酒店地址和使用时间
    function hidePlayProp(){
    	$("#localHotelAddressFlag").hide();
    	$("#localHotelAddressFlag").find("input").attr("disabled","disabled");
    	$("#useTimeFlag").hide();
    	$("#useTimeFlag").find("input").attr("disabled","disabled");
    }
    //根据品类显示当地酒店地址和使用时间
    function showPlayProp(key){
    	if(key=="FOOD"){
    		$("#useTimeFlag").show();
    		$("#useTimeFlag").find("input").removeAttr("disabled");
    	}
    	if(key=="SPORT"){
    		$("#useTimeFlag").show();
    		$("#useTimeFlag").find("input").removeAttr("disabled");
    		$("#localHotelAddressFlag").show();
    		$("#localHotelAddressFlag").find("input").removeAttr("disabled");
    	}

    }

    //显示境外手机号
    function showOutPhoneDiv() {
        var outboundPhoneType = $("#outboundPhoneNum");
        outboundPhoneType.show();
        outboundPhoneType.find("input").removeAttr("disabled");
    }
    //隐藏证件类型，然后根据产品类型设置证件
    function hideCredNumType(productType) {
    	$("#showCredNumType").val("N");
    	var credNumType = $("#credNumType");
    	credNumType.find("input[type=readio]").each(function() {
    		var $this = $(this);
    		if ($this.val() == 'N') {
    			$this.attr("checked", "checked");
    		}

    	});
    	if (productType == "OUT") {
    		editRequireByName(["passportFlag","passFlag","twPassFlag"]);
    	}else{
    		editRequireByName(["idFlag","passportFlag"]);
    	}
    	credNumType.hide();
    }
    function editRequireByName(nameList) {
    	var credNumType = $("#credNumType");
    	for (var i in nameList) {
    		credNumType.find("input[name=" + nameList[i] + "]").each(function() {
    			var $this = $(this);
    			if ($this.val() == 'Y') {
    				$this.attr("checked", "checked");
    			}
    		});
    	}

    }

	function showRequire(categoryId,productType,addtion){

		//首先将所有的必填项全部置为可用
		$("#travNum").show();
		$("input[name='travNumType']").removeAttr("disabled");
		$("#ennameNum").show();
		$("input[name='ennameType']").removeAttr("disabled");
		$("#occupNum").show();
		$("input[name='occupType']").removeAttr("disabled");
		$("#phoneNum").show();
		$("input[name='phoneType']").removeAttr("disabled");
        $("#outBoundPhoneNum").show();
        $("input[name='outBoundPhoneType']").removeAttr("disabled");
		$("#emailNum").show();
		$("input[name='emailType']").removeAttr("disabled");
        $("#credNum").show();
        $("input[name='credType']").removeAttr("disabled");
		//拼接 key， 传到后台获取 后台配置的必填项
		var key = "";
		if(categoryId==15){
			key = "GROUP"
		}else if(categoryId == 42) {
			key = "CUSTOMIZED"
		}else if(categoryId==18){
			key = "FREEDOM"
		}else if(categoryId==16){
			key = "LOCAL"
		}else if(categoryId==3){
			key = "INSURANCE"
		}else if(categoryId==11){
			key = "SINGLE_TICKET"
		}else if(categoryId==13){
			key = "COMB_TICKET"
		}else if(categoryId==121||categoryId==123){
			key = "OTHER_TICKET"
		}else if(categoryId==21){
			key = "TRAFFIC_AERO_OTHER"
		}else if(categoryId==23){
			key = "TRAFFIC_TRAIN_OTHER"
		}else if(categoryId==25){
			key = "TRAFFIC_BUS_OTHER"
		}else if(categoryId==27){
			key = "TRAFFIC_SHIP_OTHER"
		}else if(categoryId==17){
		    key = "HOTELCOMB"
		}else if(categoryId==32){
		    key = "NEWHOTELCOMB"
		}else if(categoryId==4){
		    key = "VISA"
		}else if(categoryId == 41){
			//CONNECTS_INNER 和 CONNECTS_OUT
            key = "CONNECTS"
			if(productType == 'OUT'){
                showOutPhoneDiv();
			}
		}else if(categoryId == 43){
			 key = "FOOD"
			 showPlayProp(key);
			 hideCredNumType(productType);
		}else if(categoryId == 44){
			 key = "SPORT"
			 showPlayProp(key);
			 hideCredNumType(productType);
		}else if(categoryId == 45){
			 key = "SHOP"
			 hideCredNumType(productType);
		}
		if(productType!=""){
			key = key+"_"+productType;
		}
		if(addtion!=""){
			key = key+"_"+addtion;
		}
		$.ajax({
			url:'/vst_admin/biz/orderRequired/findOrderRequiredList.do',
			type:"get",
			data :{"groupCode":key},
			async:false,
			dataType:'JSON',
            success: function (result) {
            	if(result == null){
            		return;	
            	}
            	
            	if(result.needTravFlag != null){

                    //needTravFlag 是否需要游玩人信息
	            	if(result.needTravFlag=="N"){
		            	$("#reservationLimitForm").hide();
		            	$("#reservationLimitForm").children().find("input").each(function(){
							$(this).attr("disabled","disabled"); 
						}); 
		            }else{
	            		if($("#reservationLimitForm").is(":hidden")){
	            			$("#reservationLimitForm").show();
	            		}
	            		$("#reservationLimitForm").children().find("input").each(function(){
							$(this).removeAttr("disabled");
						});

						//根据后台的配置，对下单必填项做限制

	            		if(result.travNumType != "TRAV_NUM_CONF"){
	            			$("#travNum").hide();
	            			$("input[name='travNumType']").attr("disabled","disabled");
	            		}else{
	            			$("#travNum").show();
	            			$("input[name='travNumType']").remove("disabled");
	            		}
	            		if(result.ennameType != "TRAV_NUM_CONF"){
	            			$("#ennameNum").hide();
	            			$("input[name='ennameType']").attr("disabled","disabled"); 
	            		}else{
	            			$("#ennameNum").show();
	            			$("input[name='ennameType']").remove("disabled"); 
	            		}
						if(result.occupType != "TRAV_NUM_CONF"){
	            			$("#occupNum").hide();
	            			$("input[name='occupType']").attr("disabled","disabled");
	            		}else{
	            			$("#occupNum").show();
	            			$("input[name='occupType']").remove("disabled"); 
	            		}
	            		if(result.phoneNumType != "TRAV_NUM_CONF"){
	            			$("#phoneNum").hide();
	            			$("input[name='phoneType']").attr("disabled","disabled");
	            		}else{
	            			$("#phoneNum").show();
	            			$("input[name='phoneType']").remove("disabled"); 
	            		}

                        //境外手机号
                        if(result.outboundPhoneType != "TRAV_NUM_CONF"){
                            $("#outboundPhoneNum").hide();
                            $("input[name='outboundPhoneType']").attr("disabled","disabled");
                        }else{
                            $("#outboundPhoneNum").show();
                            $("input[name='outboundPhoneType']").remove("disabled");
                        }

                        if(result.emailType != "TRAV_NUM_CONF"){
                            $("#emailNum").hide();
                            $("input[name='emailType']").attr("disabled","disabled");
                        }else{
                            $("#emailNum").show();
                            $("input[name='emailType']").remove("disabled");
                        }
                        if(result.idNumType != "TRAV_NUM_CONF"){
                            $("#credNum").hide();
                            $("#credNumType").hide();
                            $("input[name='credType']").attr("disabled","disabled");
                        }else{
                            $("#credNum").show();
                            if($("input[name=credType]:checked").val()!='TRAV_NUM_NO' && $("#showCredNumType").val()!="N"){
                                $("#credNumType").show();
                            }
                            $("input[name='credType']").remove("disabled");
                        }

		            }
            	}
	            if(result.needGuideFlag=='TRAV_NUM_CONF'){           	    
            	     $("#needGuideFlag").show(); 
            	     var needGuideFlag=$("input[name='needGuideFlag'][checked]").val();
            	     if(needGuideFlag!='NEED'){
            	        $("#needGuideDetail").hide();
            	     }else{
            	         $("#needGuideDetail").show();
            	     }
            	     $("input[name='guideNameType']").attr("disabled","disabled");          	     
            	     $("input[name='guidePhoneType']").attr("disabled","disabled");
            	     if(result.guideNoType=="NEED"){
            	        $("input[name='guideNoType']").attr("disabled","disabled");
            	        $("input[name='guideNoType']").attr("checked","checked");
            	     }else if(result.guideNoType=="TRAV_NUM_CONF"){
            	        
            	     }else{
            	         $("#guideNoType").hide();
            	     }
            	     
            	     if(result.guideIdType=="TRAV_NUM_CONF"){
            	        
            	     }else if(result.guideIdType=="NEED"){
            	        $("input[name='guideIdType']").attr("disabled","disabled");
            	        $("input[name='guideIdType']").attr("checked","checked");
            	     }else{
            	        $("#guideIdType").hide();
            	     }
            	}else {
            	     $("#needGuideDetail").hide();
            	     $("#needGuideFlag").hide();           	     
            	}
            	
            }
            
           
		});
		 
	}

	//下拉框点击事件
	$("input[name=credType]").change(function(){
		if($("input[name=credType]:checked").val()=='TRAV_NUM_NO'){
			$("#credNumType").hide();
		}else{
			if($("#showCredNumType").val()!="N"){
			   $("#credNumType").show();
			}
		}
	});
	
	$("input[name=needGuideFlag]").click(function(){
	     var value = $(this).val();
	     if(value=='NEED'){
	         $("#needGuideDetail").show();
	     }else{
	        $("#needGuideDetail").hide();
	     }
	});
	

</script>