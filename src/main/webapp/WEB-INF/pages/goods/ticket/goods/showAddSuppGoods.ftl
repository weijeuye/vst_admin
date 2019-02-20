<#list qualifyTypeList as typeInfo>
<input type="hidden" name="qualifyTypeListInputHidden" code="${typeInfo.code!''}" value="${typeInfo.cnName!''}">
</#list>
<#list lvAccSubjectList as accSubjectInfo>
<input type="hidden" name="lvAccSubjectListInputHidden" code="${accSubjectInfo.code!''}" value="${accSubjectInfo.subName!''}">
</#list>
<form action="/vst_admin/ticket/goods/goods/addSuppGoods.do" method="post" id="dataForm">
		<input type="hidden" name="supplierId" value="${suppGoods.suppSupplier.supplierId}">
		<input type="hidden" name="productId" value="${suppGoods.prodProduct.productId}">
		<input type="hidden" name="aperiodicFlag" value="${suppGoods.aperiodicFlag}" id="aperiodicFlag">  
		<input type="hidden" name="senisitiveFlag" value="N">
		<input type="hidden" name="stockApiFlag" value="N">
		<input type="hidden" id="ebkUseStatusReturn" name="ebkUseStatusReturn" value="${suppGoods.ebkUseStatusReturn!''}">
		<input type="hidden" id="isAutoPerform" name="isAutoPerform" value="${passProvider.isAutoPerform}">
		<input type="hidden" id="providerId" name="providerId" value="${passProvider.providerId}">
		<input type="hidden" id="providerName" name="providerName" value="${passProvider.providerName}">
		 <input type="hidden" id="useStatusVal" name="useStatusVal" value="${suppGoods.useStatus!''}">
		<input type="hidden" id="isBusinessVal" name="isBusinessVal" value="${suppGoods.isBusiness!''}">
        <table class="p_table form-inline">
            <tbody>
            	<tr>
                	<td colspan=3>基本信息：</td>
                </tr>
                <tr>
                	<td class="p_label" width="100"><i class="cc1">*</i>所属规格：</td>
                	<td colspan=2>
                		<#if prodProductBranchList?size gt 0>
	                		<select name="productBranchId" id="productBranchId1" required>
									  	<option value="">请选择</option>
									  	<#list prodProductBranchList as prodProductBranch>
						                    <option value="${prodProductBranch.productBranchId}" <#if suppGoods?? && suppGoods.prodProductBranch?? && suppGoods.prodProductBranch.productBranchId==prodProductBranch.productBranchId>selected</#if> data= "${prodProductBranch.singleItemCategoryId!''}">${prodProductBranch.branchName}</option>
									  	</#list>
		                	</select>
		                <#else>	
		                	<span class="notnull">请先创建产品规格!</span>
                		</#if>
                		 <span style="color:grey">必须选择规格，当规格分类等于单门票时，规格名称不带到商品名称中。</span>
                	</td>
                </tr>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>门票票种：</td>
                    <td colspan=2>
                    	<select name="goodsSpec" required>
                    	 			<option value="">请选择</option>
		    				<#list goodsSpecList as list>
		    					<option value=${list.code!''} specName=${list.specName!''} adult=${list.adult!''} child=${list.child!''}>${list.cnName!''}</option>
			                </#list>
			        	</select>
                        <input type="checkbox" name="specialSmsFlag" id ="specialSmsFlag"/>
                        短信不显示人群类别及数量<span style="color:grey">(选择后，短信中仅显示份数，不显示:X成人，X儿童)</span>
                    </td>
                </tr>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>成人数：</td>
                    <td colspan=2>
                    	<input type="text" name="adult" style="width:30px" value=0 min=0 max=999 required readonly>
                    </td>
                </tr>
                 <tr>
                	<td class="p_label"><i class="cc1">*</i>儿童数：</td>
                    <td colspan=2>
                    	<input type="text" name="child" style="width:30px" value=0 min=0 max=999 required readonly>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	<input type="checkbox" name="limitChild" id ="limitChild" value="Y" style="display:none" disabled="disabled" ><span name="limitChildText" style="display:none">限制单独购买</span></input>
                    </td>
                  
                </tr>
				<tr>
                	<td class="p_label"><i class="cc1">*</i>商品名称：</td>
                    <td colspan=2>
                    	<input type="hidden" name="goodsNameProductBranch"><input type="hidden" name="goodsNameGoodsSpec">
                    	<input type="text" name="goodsName1" style="width:260px" value="" required maxlength=40>
                    	【<input type="text" name="goodsName2" style="width:160px" value="" maxlength=60>】
                    	<input type="hidden" name="goodsName">
                    	
                    	<span style="color:grey">名称必须填写，副标题可描述商品特点，不允许输入中括号“【】”</span>
                    </td>
                </tr>
                <tr>
                	<td class="p_label">商品英文名称：</td>
                    <td colspan=2>
                    	<input type="text" name="goodsEnglishName" style="width:260px" value="" maxlength=60>
                    </td>
                </tr>
                <tr>
                    <td class="p_label"><i class="cc1">*</i>商品品类</td>
                    <td>
                        <div id="suppGoodsDetailDiv">
						<#if goodsCategoryList?? && (goodsCategoryList?size > 0) >
							<#list goodsCategoryList as category>
                                <input type="radio" name="categoryDetail" value="${category.suppChildId!''}"
									   <#if category.suppChildId==suppGoods.categoryDetail>checked=checked</#if>/>${category.goodsCateGoryValue!''}
							</#list>
						<#else>
                            <p>没有商品品类选项，不用填写！</p>
						</#if>
                        </div>

                    </td>
                </tr>

                <tr>
					<td class="p_label"><i class="cc1">*</i>商品合同：</td>
					<td colspan=2 class=" operate mt10">
                        <input type="hidden"  name="companyType" id="companyTypeHidden" value="${suppGoods.companyType!''}"  />
                        <label id="contractNameAdd" name="contractName"> <#if suppGoods!=null && suppGoods.suppContract!=null>${suppGoods.suppContract.contractName}</#if></label>
						<input type="hidden" id="contractIdAdd" name="contractId" <#if suppGoods!=null && suppGoods.suppContract!=null> value="${suppGoods.suppContract.contractId}"</#if>>
						<a id="change_button_contract" href="javascript:void(0);">[更改]</a>
                   	</td>
                </tr>
				<#-- SETTLE_ENTITY_NEW_MARK start  -->
                <tr>
                    <td class="p_label"><i class="cc1">*</i>结算对象：</td>
                    <td colspan=2 id="settlementEntityTd">
                        <input type="text" name="settlementEntityName" id="settlementEntityName" <#if suppGoods!=null && suppGoods.settlementEntity!=null> value="${suppGoods.settlementEntity.name}"</#if> required=true>
                        <input type="hidden" name="settlementEntityCode" id="settlementEntityCode" <#if suppGoods!=null && suppGoods.settlementEntity!=null> value="${suppGoods.settlementEntity.code}"</#if> required=true>
                        <input type="hidden" <#if suppGoods!=null && suppGoods.settlementEntity!=null> value="${suppGoods.settlementEntity.id}"</#if> name="settlementEntityId" id="settlementEntityId" required=true>
                        <span name="settlementEntityDesc" id="settlementEntityDesc">
					<#if suppGoods.settlementEntity!=null&&suppGoods.settlementEntity.code?? >
                        结算对象CODE: ${suppGoods.settlementEntity.code}
					</#if>
					<#if suppGoods.settlementEntity!=null&&suppGoods.settlementEntity.cooperatedBuNostroName??>
                        ,合作BU：${suppGoods.settlementEntity.cooperatedBuNostroName}
					</#if>
				</span>
                    </td>
                </tr>
				<#-- SETTLE_ENTITY_NEW_MARK  end -->
                <tr>
					<td class="p_label"><i class="cc1">*</i>我方结算主体：</td>
					<td colspan=2>
						<#--<select name="companyType" required>
		    				<#list companyTypeMap?keys as key >
								<option value="${key}">${companyTypeMap[key]}</option>
							</#list>
			        	</select>-->

                            <span id="companyTypeNew" style="width:250px;">
                            <#if (suppGoods!=null) && (suppGoods.companyType!=null)&&(suppGoods.companyType!="") >
                            <#assign lvCode="" />
                            <#switch suppGoods.companyType>
                                <#case "JOYU">
                                    <#assign lvCode="DEFAULT" />
                                    <#break>
                                <#case "GUOLV">
                                    <#assign lvCode="LVMAMA" />
                                    <#break>
                                <#case "XINGLV">
                                    <#assign lvCode="LVMAMAXINGLV" />
                                    <#break>
                            </#switch>
                          <#list lvAccSubjectList as subjectInfo>
                                <#if subjectInfo.code==lvCode>
                                ${subjectInfo.subName!''}
                                </#if>
                            </#list>
                    </#if>
                            </span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i for="companyTypeNew" id="contract_main" class="error" style="display:none">该字段不能为空</i>
                    </td>
                </tr>
                <tr>
					<td rowspan="3" class="p_label" ><i class="cc1">*</i>商品类型：</td>
				 </tr>
						<#if goodsTypeList??>	
							<#list goodsTypeList as goodsType>
								<#if goodsType=="EXPRESSTYPE_DISPLAY">
								<tr>
										<td>
											<input type="radio" name="goodsType" value="${goodsType.code}" required checked="checked">${goodsType.cnName}
											</br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<label>寄件方</label>
											<select name="expressType">
											<#list expressTypeList as expressType>
												<option value="${expressType.code}">${expressType.cnName}</option>
												</#list>
											</select>
											&nbsp;&nbsp;&nbsp;
											<label>是否免运费</label>
											<input type="radio" name="postFreeFlag" value="Y" >是
											<input type="radio" name="postFreeFlag" value="N" checked=checked>否
										</td>
								 </tr>
								</#if>
								<#if goodsType=="NOTICETYPE_DISPLAY">
								<tr>
										<td>
											<input type="radio" name="goodsType" value="${goodsType.code}" required >${goodsType.cnName}
											<span>
											<#assign noticeTypeContent = "" /> 
											<#list noticeTypeList as noticeType>
												<#if noticeType.code!='QRCODE'>
													<#if noticeTypeContent =="" >
													<#assign noticeTypeContent = "("+ noticeType.cnName/> 
													<#else>
													<#assign noticeTypeContent =  noticeTypeContent +("或者"+ noticeType.cnName+"通知游客)") /> 
													</#if>
												</#if>
											</#list>
											${noticeTypeContent}
											</span>
										</td>
								</tr>
								</#if>
							</#list>	
						</#if>
				<tr>
					<td class="p_label"><i class="cc1">*</i>支付对象：</td>
					<td colspan=2>
						<select name="payTarget" required>
                    	 			<option value="">请选择</option>
		    				<#list payTargetList as list>
			                    	<option value=${list.code!''}>${list.cnName!''}</option>
			                </#list>
			        	</select>
                    </td>
                </tr>
                <tr>
					<td class="p_label"><i class="cc1">*</i>分公司：</td>
					<td colspan=2>
						<select name="filiale" class="filialeCombobox">
                    	 			<option value="">请选择</option>
		    				<#list filialeList as list>
			                    	<option value=${list.code!''}>${list.cnName!''}</option>
			                </#list>
			        	</select>
                    </td>
                </tr>
                
                <tr>
					<td class="p_label"><i class="cc1">*</i>BU：</td>
					<td colspan=2>
			        	<select name="bu" required>
		    	 			<option value="">请选择</option>
						<#list buList as list>
		                	<option value=${list.code!''}>${list.cnName!''}</option>
			            </#list>
				    	</select>
	                </td>
	            </tr>
                
	            
                <tr>
					<td class="p_label"><i class="cc1">*</i>归属地：</td>
					<td colspan=2>
						<input type="text" name="attributionName" id="attributionName"  readonly = "readonly" required />
						<input type="hidden" name="attributionId" id="attributionId"  required />
                    </td>
                </tr>
                
                 <tr style="display:none" id="regionalLeader">
					<td class="p_label"><i class="cc1">*</i>区域负责人：</td>
					<td colspan=2>
						<input type="text" name="regionalLeaderName" id="regionalLeaderName" value="${suppGoods.regionalLeaderName}" required=true>
                    	<input type="hidden" value="${suppGoods.regionalLeaderId}" name="regionalLeaderId" id="regionalLeaderId" required=true>
                   	</td>
                </tr>  
                 <tr style="display:none" id="commercialStaff">
					<td class="p_label"><i class="cc1">*</i>商务人员：</td>
					<td colspan=2>
						<input type="text" name="commercialStaffName" id="commercialStaffName" value="${suppGoods.commercialStaffName}" required=true>
                    	<input type="hidden" value="${suppGoods.commercialStaffId}" name="commercialStaffId" id="commercialStaffId" required=true>
                   	</td>
                </tr>  
	            
                 <tr>
					<td class="p_label"><i class="cc1">*</i>产品经理：</td>
					<td colspan=2>
						<input type="text" name="managerName" id="managerName" value="${suppGoods.managerName}" required=true>
                    	<input type="hidden" value="${suppGoods.managerId}" name="managerId" id="managerId" required=true>
                   	</td>
                </tr>                
               	<tr>
					<td class="p_label"><i class="cc1">*</i>内容维护人员：</td>
					<td colspan=2>
						<input type="text" name="contentManagerName" id="contentManagerName" value="${suppGoods.contentManagerName}" required=true>
                    	<input type="hidden" value="${suppGoods.contentManagerId}" name="contentManagerId" id="contentManagerId" required=true>
                   	</td>
                </tr>
                <tr>
					<td class="p_label"><i class="cc1">*</i>是否有效：</td>
					<td colspan=2>无效(请在录入:商品描述，价格库存，下单必填项之后修改成有效)
						<#--<select name="cancelFlag" required>-->
	                    	<#--<option value="Y" <#if suppGoods!=null && suppGoods.cancelFlag=='Y'>selected</#if>>是</option>-->
	                    	<#--<option value="N" <#if suppGoods!=null && suppGoods.cancelFlag=='N'>selected</#if>>否</option>-->
	                    <#--</select>-->
	                    <input type="hidden" name="isCircus" value="0"/>
	                    <input type="hidden" name="tianNiuFlag" value="N"/>
                    </td>
                </tr>
                <#if isShowCircusFlag == 'Y'>
	                <tr>
						<td class="p_label"><i class="cc1"></i>是否场次票：</td>
						<td colspan=2>
							<input type="checkbox" id= "isCircus"/>
	                    </td>
	                </tr>
	            </#if>
	            <#if isShowTianNiuFlag == 'Y'>
        			<tr>
            			<td class="p_label"><i class="cc1"></i>是否天牛计划：</td>
            			<td colspan=2>
                			<input type="checkbox" id= "tianNiuFlag"/>
            			</td>
        			</tr>
        		</#if>
				<#if isShowSpecialTicketType == 'Y'>
                <tr>
                    <td class="p_label"><i class="cc1"></i>特殊门票类型：</td>
                    <td colspan=2>
						<select name="specialTicketType">
                            <option value="">无</option>
							<#list specialTicketTypes as specialTicketType>
                                <option value="${specialTicketType.code}">${specialTicketType.cnName}</option>
							</#list>
						</select>
                    </td>
                </tr>
				</#if>
				<#include "/base/showDistributorGoods.ftl"/>

                <!--有效期-->
                <#if suppGoods!=null && suppGoods.aperiodicFlag=='N'>
                    <#include "/goods/ticket/goods/showAddSuppGoodsExp.ftl"/>
                <#else>
                    <#include "/goods/ticket/goods/showAddAperiodicSuppGoodsExp.ftl"/>
                </#if>

                
                <tr>
					<td colspan=3>供应商信息：</td>
                </tr>
                <tr>
					<td class="p_label"><i class="cc1">*</i>通知供应商方式：</td>
					<td colspan=2>
						<input type="checkbox" id= "noticeType"/>接口对接（二维码：第三方服务商及驴妈妈自有设备）<br/><br/>
						<input type="checkbox" id="isEbkFlag"/>需要供应商在ebk确认资源，如询位单、确认单、修改单、取消单等<font color=red>（若不勾选，供应商开通ebk账号，仅能操作入园验证）</font><br/><br/>
						<input type="checkbox" style="margin-top: 0px;" id="faxFlag" checked />传真<a id="change_button_fax" href="#">[选择供应商传真名称]</a>
						<label name="suppFaxRule.faxRuleName" id="faxRuleName"/><br/>
						（注：若都不勾选则必须开通ebk账号，通过ebk入园）
						<input type="hidden" name="faxRuleId" id="faxRuleId"/>
						<input type="hidden" name="ebkFlag" id="ebkFlag" value="N">
						<input type="hidden" name="faxFlag"  value="Y" />
						<input type="hidden" name="noticeType"  value="SMS" />
                    </td>
                </tr>
          <tr>
				 		<td class="p_label">使用状态返回：</td>
				 		<td colspan=2>
				 			<input type="checkbox" style="margin-top: 0px;"  id= "isBusiness"  <#if suppGoods.isBusiness=="Y">checked</#if>/>
				 			<input type="hidden" name="isBusiness"  value="${suppGoods.isBusiness!'N'}" />
				 			<input type="hidden" name="useStatus"  value="${suppGoods.useStatus!'NOT_RETURN'}" />
				 			<select id="useStatus"  style="width:150px;margin-right:10px;"  disabled="disabled"  >
				 			    <option name="useStatusOpt" value="" selected>请选择</option>
					 			<option name="useStatusOpt" value="INTIME_RETURN" >可返回，及时</option>
					 			<option name="useStatusOpt" value="NOTINTIME_RETURN">可返回，不及时</option>
					 			<option name="useStatusOpt" value="NOT_RETURN">不可返回</option>
				 			</select>
				 			<span id="useStatusText">(由系统自动维护）</span>
				 		</td>
				 </tr>
                <tr id="cancelTitleTR" style="background:#F9FAFB;">
					<td colspan=3>退改信息：</td>
                </tr>
                <tr id="cancelStrategyTR">
					<td class="p_label"><i class="cc1">*</i>退款策略：</td>
					<td colspan=2>
								<div>
								<input type="radio" name="cancelStrategy" value="UNRETREATANDCHANGE" >不可退改&nbsp;&nbsp;
								<input type="radio" name="cancelStrategy" value="RETREATANDCHANGE" checked="checked">仅支持整单退&nbsp;&nbsp;
								<#if suppGoods!=null && suppGoods.aperiodicFlag=='N'>
									<input type="radio" name="cancelStrategy" value="PARTRETREATANDCHANGE" >可部分退
								</#if>
			                 	</div>
			                 <span id="refundStrategy" style="display: none">
			                  	<div  id="cancelTimeTypeDiv0"  style="margin-top:2px;margin-bottom:2px;" >
		                 			<label style="min-width:5px;width:10px;text-align:right;"/>
		                 				<input type="radio" name="cancelStrategySize" value="ONE" checked="checked">订单未使用,扣除每张（份）
		                 				<select id="OTHER_DEBUT_TYPE" style="width:100px;margin-right:10px;" name="deductType" ><option value="AMOUNT">固定金额(元)</option><option value="PERCENT">票价百分比(%)</option></select>
						                <input type="hidden" value=0 name="deductValue1"/>
						                <input id="OTHER_DEBUT_VALUE" type="text" style="width:45px" min=0 max=999 value=0 name="deductValue"/>
		                 		</div>
		                 		
								<div style="margin-top:2px;margin-bottom:2px;">
									<input type="radio" name="cancelStrategySize" value="MULIT">订单未使用，按时间分等级退改
								</div>
				                 <div id="cancelStrategyContent" style="display:none">
				                 			<div style="margin-top:2px;margin-bottom:2px;" class="cancelStrategyDiv">
					                 			<input type="hidden" name="goodsReFundList[0].deductValue"/>
							                 	<input type="hidden" name="goodsReFundList[0].cancelTimeType" value="OTHER" />
						                 		<input type="hidden" name="goodsReFundList[0].deductType" />
					                 		</div>
						                	<div style="margin-top:2px;margin-bottom:2px;" class="cancelStrategyDiv">

							                 <label style="min-width:60px;width:80px;text-align:right;"><#if suppGoods.aperiodicFlag=="Y">
								                 <select  class="w10 mr10" style="width:95px" name="goodsReFundList[1].refundType">
										                <#list refundTypeList as list>
										                    <option value=${list.code!''}>${list.cnName!''}</option>
										                </#list>
												  </select>
							                  <#else>游玩日</#if></label>
							                   <span id="refundAnyDay" style="display: none">							                 	
							                 	  <input type="text" style="width:80px" name="goodsReFundList[1].anyDay"  errorEle="selectDate" class="Wdate"  onFocus="WdatePicker({readOnly:true})"  required/> 	
							                   </span>
							                 <input type="hidden" name="goodsReFundList[1].latestCancelTime" class="latestCancelTime"  disabled="disabled" />					
							                 <select name="plusflag" class="w10 mr10" style="width:50px" disabled="disabled">
								                 <option value='1'>前</option>
								                 <option value='-1'>后</option>
							                 </select>
			                     			<select class="w10 mr10" style="width:60px" name="latestCancelTime_Day">
							                      <#list 0..100 as i>
							                      <option value="${i}"><#if i==0>当<#else>${i}</#if></option>
							                      </#list>
					                		</select>天  
							                <select class="w10 mr10" style="width:50px" name="latestCancelTime_Hour">
							                      <#list 0..23 as i>
							                      <option value="${i}">${i}</option>
							                      </#list>
							                </select>点
							                <select class="w10 mr10" style="width:50px" name="latestCancelTime_Minute">
							                      <#list 0..59 as i>
							                      <option value="${i}">${i}</option>
							                      </#list>
							                </select>分之前
							                ,扣除每张（份）<select style="width:100px;margin-right:10px;" name="goodsReFundList[1].deductType" ><option value="AMOUNT">固定金额(元)</option><option value="PERCENT">票价百分比(%)</option></select>
							                <input type="hidden" style="width:30px" min=0 max=999 name="goodsReFundList[1].deductValue"/>
							                <input type="text" style="width:45px" min=0 max=999 name="deductValue"  />
							                <span class="operate"><a class="btn btn_cc1" id="add">添加</a></span>
				                   		</div>
                   					</div>
			                   		<div id="cancelTimeTypeDiv1" style="margin-top:2px;margin-bottom:2px;display:none" >
			                 			<label style="min-width:30px;width:30px;text-align:right;"/>
			                 				<input type="checkbox" id="cancelTimeType" value="OTHER">不满足上述时间条件,扣除每张（份）
			                 				<select style="width:100px;margin-right:10px;" name="deductType" ><option value="AMOUNT">固定金额(元)</option><option value="PERCENT">票价百分比(%)</option></select>
							                <input type="hidden" style="width:30px" min=0 max=999 value=0 name="deductValue1"/>
							                <input type="text" style="width:45px" min=0 max=999 value=0 name="deductValue"/>
			                 		</div>

			                   </span>
                    </td>
                </tr>
                <tr class="hidden">
					<td class="p_label"><i class="cc1"></i>商品是否可及时处理：</td>
					<td colspan=2>
						<input type="checkbox" style="margin-top: 0px;" id="isNotInTimeFlag"/>不可及时处理
						<input type="hidden" name="notInTimeFlag" id="notInTimeFlag" value="N" />
                    </td>
                </tr>

                  <tr id="ebkUseReturn">

					<td class="p_label"><i class="cc1">*</i>ebk使用状态反馈：</td>
					<td colspan=2>
							<div>
			                 	<input type="radio" name="ebkUseStatus" value="EBK_INTIME_RETURN" checked="checked">反馈、及时
			                 </div>
							<div style="margin-top:5px;">
                   					<input type="radio" name="ebkUseStatus" value="EBK_NOTINTIME_RETURN">反馈、不及时
                   			</div>
                   			<div style="margin-top:5px;">
                   					<input type="radio" name="ebkUseStatus" value="EBK_NOT_RETURN">不反馈
                   			</div>
                    </td>
                </tr>

                
                <tr id="reschedule">
                    <td class="p_label"><i class="cc1">*</i>改期策略：</td>
                    <td colspan=2 style="padding: 0px">
                        <div class="reschedule-tabs">
                            <div class="reschedule-tabs-title">
                                <ul>
                                    <input type="hidden" name="goodsReschedule.changeStrategy" value=""/>
                                    <li>可改期</li>
                                    <li>不可改期</li>
                                </ul>
                            </div>
                            <div class="reschedule-tabs-content">
                                <div>
                                    <input type="hidden" name="goodsReschedule.changeCount"/>
                                    <input type="radio" name="goodsReschedule.changeDesc" value="0">在个人中心我的订单中申请改期。每个订单只改期
                                    <input type="text" style="width: 30px;" value="1" min="1" max="10"/> 次<br/>
                                    <label style="min-width:60px;width:60px;text-align:right;">游玩日</label>
                                    <input type="hidden" name="goodsReschedule.latestChangeTime" class="latestChangeTime"/>

                                    <select name="plusflag" class="w10 mr10" style="width:50px" disabled="disabled">
                                        <option value='1'>前</option>
                                        <option value='-1'>后</option>
                                    </select>
                                    <select class="w10 mr10" style="width:60px" name="latestChangeTime_Day">
                                    <#list 0..100 as i>
                                        <option value="${i}"><#if i==0>当<#else>${i}</#if></option>
                                    </#list>
                                    </select>天
                                    <select class="w10 mr10" style="width:60px" name="latestChangeTime_Hour">
                                    <#list 0..23 as i>
                                        <option value="${i}">${i}</option>
                                    </#list>
                                    </select>点
                                    <select class="w10 mr10" style="width:60px" name="latestChangeTime_Minute">
                                    <#list 0..59 as i>
                                        <option value="${i}">${i}</option>
                                    </#list>
                                    </select>分之前,可申请改期 (不满足上述条件, 不可改期)<br/>
                                    <input type="radio" name="goodsReschedule.changeDesc" value="1">拨打客服电话1010-6060申请改期。每个订单只可改期<input type="text"  style="width: 30px;" value="1" min="1" max="10"/>次<br/>
                                    <label style="min-width:60px;width:60px;text-align:right;">游玩日</label>

                                    <select name="plusflag" class="w10 mr10" style="width:50px" disabled="disabled">
                                        <option value='1'>前</option>
                                        <option value='-1'>后</option>
                                    </select>
                                    <select class="w10 mr10" style="width:60px" name="latestChangeTime_Day">
                                    <#list 0..100 as i>
                                        <option value="${i}"><#if i==0>当<#else>${i}</#if></option>
                                    </#list>
                                    </select>天
                                    <select class="w10 mr10" style="width:60px" name="latestChangeTime_Hour">
                                    <#list 0..23 as i>
                                        <option value="${i}">${i}</option>
                                    </#list>
                                    </select>点
                                    <select class="w10 mr10" style="width:60px" name="latestChangeTime_Minute">
                                    <#list 0..59 as i>
                                        <option value="${i}">${i}</option>
                                    </#list>
                                    </select>分之前,可申请改期 (不满足上述条件, 不可改期)<br/>
                                </div>
                                <div>
                                    <input type="radio" name="goodsReschedule.changeDesc" value="2" checked="checked">本商品一经预订不支持改期。<br/>
                                    <input type="radio" name="goodsReschedule.changeDesc" value="3">本商品一经预订不支持改期。（可退款的商品可申请退款后重新下单）
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
                
                <tr>
					<td class="p_label"><i class="cc1"></i>EBK是否支持发邮件：</td>
					<td colspan=2>
						<input type="checkbox" id= "ebkEmailFlag"/>支持&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;勾选后供应商可在EBK发送入园凭证相关的邮件给到用户
						<input type="hidden" name="ebkEmailFlag" value="N"/>
                    </td>
                </tr>
                  

                <tr>
					<td colspan=3>预订限制：</td>
                </tr>
                <tr>
					<td class="p_label"><i class="cc1">*</i>是否仅组合销售：</td>
					<td colspan=2>
						<input type="radio" name="packageFlag" value="Y">是
	                	<input type="radio" name="packageFlag" value="N" checked>否
	                	<span id="tips" style="display:none; color:red;">注：仅组合销售选择“是”时，商品只能通过打包方式售卖</span>
                    </td>
                </tr> 
                <tr>
					<td class="p_label"><i class="cc1">*</i>最小起订数量：</td>
					<td colspan=2>
						<input type="text" name="minQuantity"  min=1 max=999 required=true >
                    </td>
                </tr>
                <tr>
					<td class="p_label"><i class="cc1">*</i>最大订购数量：</td>
					<td colspan=2>
						<input type="text" name="maxQuantity" min=1 max=5000 required=true>
                    </td>
                </tr>
	            <#if suppGoods.aperiodicFlag="N">
	                <tr>
						<td colspan=3>预订限制：</td>
	                </tr>
	                <tr>
						<td class="p_label"><i class="cc1">*</i>预订日期限制：</td>
						<td colspan=2>
								<input type="radio" name="limitBookDayFlag" value="Y">是
		                		<input type="radio" name="limitBookDayFlag" value="N" checked>否
								<br>
								只允许预订
								<select name="limitBookDay" id="limitBookDay" style="width:70px" disabled="disabled" required>
			                    	 <#list 0..31 as i>
				                      	<option value="${i}">${i}</option>
				                      </#list>
			                    </select>日票
	                    </td>
	                </tr>
                </#if>
            </tbody>
        </table>
</form>
<div class="p_box box_info clearfix mb20">
            <div class="fl operate" style="margin-top:20px;"><a class="btn btn_cc1" id="save">保存</a></div>
</div>
<div style="min-height:100px;">
</div>
<div id="template" style="display:none">
		<div style="margin-top:2px;margin-bottom:2px;" class="cancelStrategyDiv">
             <label style="min-width:60px;width:80px;text-align:right;">
              <input type="hidden" name="goodsReFundList[{{index}}].refundType" class="refundType">   				
             </label>
              <input type="hidden" name="goodsReFundList[{{index}}].anyDay"   class="anyDay"  > 
             <input type="hidden" name="goodsReFundList[{{index}}].latestCancelTime" class="latestCancelTime">            
             <select class="w10 mr10" style="width:50px" name="plusflag" disabled="disabled">
					<option value='1'>前</option>
					<option value='-1'>后</option>
            </select>
         	<select class="w10 mr10" style="width:60px" name="latestCancelTime_Day">
                  <#list 0..100 as i>
                  <option value="${i}"><#if i==0>当<#else>${i}</#if></option>
                  </#list>
            </select>天   
            <select class="w10 mr10" style="width:50px" name="latestCancelTime_Hour">
                  <#list 0..23 as i>
                  <option value="${i}">${i}</option>
                  </#list>
            </select>点
            <select class="w10 mr10" style="width:50px" name="latestCancelTime_Minute">
                  <#list 0..59 as i>
                  <option value="${i}">${i}</option>
                  </#list>
            </select>分之前
            ,扣除每张（份）<select style="width:100px;margin-right:10px;" name="goodsReFundList[{{index}}].deductType" ><option value="AMOUNT">固定金额(元)</option><option value="PERCENT">票价百分比(%)</option></select>
            <input type="hidden" style="width:30px" min=0 max=999 value=0 name="goodsReFundList[{{index}}].deductValue">
            <input type="text" style="width:45px" min=0 max=999 value=0 name="deductValue">
            <span class="operate"><a class="btn btn_cc1 delete" >删除</a></span>
   		<div>
</div>

		<#-- SETTLE_ENTITY_NEW_MARK  start -->
            <script type="text/javascript" src="/vst_admin/js/vst_settlement_util.js"></script>
		<#-- SETTLE_ENTITY_NEW_MARK  end -->
<script> 
vst_pet_util.superUserSuggest("#contentManagerName","input[name=contentManagerId]");
vst_pet_util.superUserSuggest("#managerName","input[name=managerId]");
vst_pet_util.superUserSuggest("#regionalLeaderName","input[name=regionalLeaderId]");
vst_pet_util.superUserSuggest("#commercialStaffName","input[name=commercialStaffId]");


<#-- SETTLE_ENTITY_NEW_MARK  start -->
vst_settlement_util.settleEntityCommListSuggest("#contractIdAdd");
vst_settlement_util.settlementEntityNameBlur();
vst_settlement_util.settlementEntityNameFocus("#contractIdAdd");
<#-- SETTLE_ENTITY_NEW_MARK  end -->
</script>

<script type="text/javascript">
	function needEnglishName(){
		var categoryId = $("input[name='prodProduct.bizCategory.categoryId']").val();
		if(categoryId==11||categoryId==12 || categoryId == 13){
		}else{
			$("input[name='goodsEnglishName']").parents("tr").remove();
		}
	}
</script>
		
<script>
		$(function(){
			//判断是否需要输入英文名称	
			needEnglishName();
		     changeUseStatus();
			// 隐藏是否需要供应商EBK选择项，不需要EBK传真时才显示
			$('#showEbkFlag').hide();
			$("input[name='goodsName2']").each(function(){
				
				$(this).keyup(function() {
					if($(this).val().substring($(this).val().length-2,$(this).val().length)=="【】" || $(this).val().substring($(this).val().length-2,$(this).val().length)=="】【")
			        $(this).val($(this).val().substring(0,$(this).val().length-2));
					if($(this).val().substring($(this).val().length-1,$(this).val().length)=="【" || $(this).val().substring($(this).val().length-1,$(this).val().length)=="】")
			        $(this).val($(this).val().substring(0,$(this).val().length-1));
					vst_util.countLenth($(this));
				});
			});

            disableExpItem();
		});
		
		var height = $(".dialog-content").height();
		$(".dialog-content").css({"overflow-y":"auto","height":""+height});
		
		if($("#productBranchId option:selected").val()!=''){
			if($("#productBranchId1 option:selected").attr("data")!="310"){
				$("input[name=goodsNameProductBranch]").val($("#productBranchId option:selected").text());
				$("input[name=goodsName1]").val($("#productBranchId option:selected").text());
			}
		}

		var selectContractDialog2;
		var selectSuppFaxRule;
		//供应商合同回调函数
		function onSelectContract2(params){
			if(params!=null){
				$("#contractNameAdd").text(params.contractName);
				$("#contractIdAdd").val(params.contractId);

                var accCode =params.accSubject;
                //回调显示合同主体(取到合同的我方结算主体)
                var accSubjectCname='';
                $("input[name='lvAccSubjectListInputHidden']").each(function(){
                    if(accCode==$(this).attr("code")){
                        accSubjectCname=$(this).val();
                    }

                });
                $("#companyTypeHidden").val(lvSubjectCodeConvert(accCode));
                $("#companyTypeNew").html(accSubjectCname);
                $("#contract_main").attr("style", "display:none");

			<#-- SETTLE_ENTITY_NEW_MARK  start -->
                vst_settlement_util.resetSelectSettleEntityNameInput();
			<#-- SETTLE_ENTITY_NEW_MARK  end -->
			}
			selectContractDialog2.close();
		}
		//供应商传真号回调函数
		function onSelectSuppFaxRule(params){
			if(params!=null){
				$("#faxRuleName").text(params.faxRuleName);
				$("#faxRuleId").val(params.faxRuleId);
				$("label[name='suppFaxRule.faxRuleName']").attr('title','传真号码：'+params.fax+'； 发送时间：'+params.sendTime);
			}
			selectSuppFaxRule.close();
		}
		
		//打开选择供应商合同列表
		$("#change_button_contract").click(function(){
			selectContractDialog2 = new xDialog("/vst_back/supp/suppContract/selectContractListBySupplier.do?callback=onSelectContract2&supplierId="+$("#supplierId").val(),{},{title:"选择供应商合同",width:"600"});
		});
		
		//打开选择供应商传真号列表
		$("#change_button_fax").click(function(){
			selectSuppFaxRule = new xDialog("/vst_back/supp/fax/selectSuppFaxRuleList.do?callback=onSelectSuppFaxRule&supplierId="+$("#supplierId").val()+"&categoryId="+$("input[name='prodProduct.bizCategory.categoryId']").val(),{},{title:"选择供应商传真号",iframe:true,width:"800",height:"400"});
});
		 $("input[name='isApplyDate']").change( function() {
          	    if($(this).val()=='N'){
          		$("#isApplyDateTd").hide();
          		}else if($(this).val()=='Y'){
          		/*if($("input[name='startTime']").val()==""||$("input[name='endTime']").val()==""){
          			 alert("请先选择正确有效期的时间范围！");
          			 $("input[name='isApplyDate']:eq(0)").attr("checked",'checked'); 
          			 return;
          		}*/
          		$("#isApplyDateTd").show();
          		}
           });
		//添加不可用日期范围
		$("#copyDatdExclude").click(function(){
             var rowLength = $("#datdExcludeTable tr").length;
              if(rowLength>4){
             	alert("时间范围不能超过5条");
             	return;
             }
             var lastId=$("#datdExcludeTable tr:last").find("input[name='datdExcludeEndTime']").attr("id");
             var startId= lastId.substr(0,1)+(parseInt(lastId.substr(1,lastId.length))+1);
             var endId= lastId.substr(0,1)+(parseInt(lastId.substr(1,lastId.length))+2);
             var row='<tr><td>';
                 row+='<input id="'+startId+'" type="text" style="width:100px" name="datdExcludeStartTime" errorEle="selectDate" class="Wdate" onFocus="WdatePicker({minDate:\'#F{$dp.$D(\\\''+lastId+'\\\')||$dp.$D(\\\'d4321\\\')}\',maxDate:\'#F{$dp.$D(\\\''+endId+'\\\')||$dp.$D(\\\'d4322\\\')}\'})" required/>';
                 row+='  <input id="'+endId+'" type="text" style="width:100px" name="datdExcludeEndTime" errorEle="selectDate" class="Wdate"  onFocus="WdatePicker({minDate:\'#F{$dp.$D(\\\''+startId+'\\\')||$dp.$D(\\\''+lastId+'\\\')||$dp.$D(\\\'d4321\\\')}\',maxDate:\'#F{$dp.$D(\\\'d4322\\\')}\'})" required/><div id="selectDateError" style="display:inline"></div></br>';
                 row+='</td><td><a href="#content" onclick="deleteDatdExclude(this)">删除</a></td></tr>';
             $("#datdExcludeTable").append(row);
		});
		 //根据供应商状态切换ebk使用状态反馈显示/隐藏
		 function sycToggle(){
		 		changeUseStatus();
		 }
		$("#faxFlag").click(function(){
			if($(this).attr("checked")=="checked"){
				$("#change_button_fax").show();
				$('#isEbkFlag').removeAttr('checked');
				$("input[name='faxFlag']").val('Y');
			}else{
				
				$("#change_button_fax").hide();
				$("input[name='faxRuleId']").val("");
				$("label[name='suppFaxRule.faxRuleName']").text("");
				$("label[name='suppFaxRule.faxRuleName']").attr('title',"");
				$('#isEbkFlag').removeAttr('checked');
				$("input[name='faxFlag']").val('N');
			}
			sycToggle();
			initChangeStrategy();
		});
		
		$('#isEbkFlag').click(function(){
			if($(this).attr("checked")=="checked"){
				$("#faxFlag").removeAttr('checked');
				$("input[name='faxFlag']").val("N");
				$("#change_button_fax").hide();
				$("input[name='faxRuleId']").val("");
				$("label[name='suppFaxRule.faxRuleName']").attr('title',"");
				$("label[name='suppFaxRule.faxRuleName']").text("");
				$(this).val("Y");
			}else{
				$("input[name='faxFlag']").val("N");
				$("input[name='faxRuleId']").val("");
				$("label[name='suppFaxRule.faxRuleName']").text("");
				$("label[name='suppFaxRule.faxRuleName']").attr('title',"");
				$(this).val("N");
			}
		sycToggle();
		initChangeStrategy();
		});
		$("#noticeType").click(function(){
			if($(this).attr("checked")=="checked"){
				$("input[name='noticeType']").val("QRCODE");
				
			}else{
				$("input[name='noticeType']").val("SMS");
			}
			sycToggle();
			initChangeStrategy();
		});
		
		$("#isCircus").click(function(){
			if($(this).attr("checked")=="checked"){
				$("input[name='isCircus']").val("1");
				
			}else{
				$("input[name='isCircus']").val("0");
			}
		});
		
		$("#tianNiuFlag").click(function(){
        	if($(this).attr("checked")=="checked"){
            	$("input[name='tianNiuFlag']").val("Y");

        	}else{
            	$("input[name='tianNiuFlag']").val("N");
        	}
    	});
    	
    	$("#ebkEmailFlag").click(function(){
        	if($(this).attr("checked")=="checked"){
            	$("input[name='ebkEmailFlag']").val("Y");

        	}else{
            	$("input[name='ebkEmailFlag']").val("N");
        	}
    	});
		
		$("select[name='bu']").change(function(){
			var value = $("select[name=bu] option:selected").val();
			if(value == 'TICKET_BU'){
				$('#regionalLeader').show();
				$('#commercialStaff').show();
			}else{
				$('#regionalLeader').hide();
				$('#commercialStaff').hide();
			}
		});
		
		
		//选择票种
		$("select[name=goodsSpec]").change(function(){
			var temp= $("select[name=goodsSpec] option:selected").text();
			if(temp=="相关票"){
				$("input[name=goodsName1]").val("");
				$("input[name=child]").attr("readonly",false);
				$("input[name=child]").val("");
				$("input[name=adult]").attr("readonly",false);
				$("input[name=adult]").val("");
			}else{
				$("input[name=child]").attr("readonly",true);
				$("input[name=adult]").attr("readonly",true);
				$("input[name=adult]").val($("select[name=goodsSpec] option:selected").attr('adult'));
				$("input[name=child]").val($("select[name=goodsSpec] option:selected").attr('child'));
				$("input[name=goodsNameGoodsSpec]").val($("select[name=goodsSpec] option:selected").attr('specName'));
				$("input[name=goodsName1]").val($("input[name=goodsNameProductBranch]").val() + ' '+ $("input[name=goodsNameGoodsSpec]").val());
				if($("input[name=goodsName2]").val()==""){
					$("input[name=goodsName]").val($("input[name=goodsName1]").val());
				}else{
					$("input[name=goodsName]").val($("input[name=goodsName1]").val() + '【'+ $("input[name=goodsName2]").val() +'】');
				}
				
			}
			var goodsSpecVal= $("select[name=goodsSpec] option:selected").val();
			if(goodsSpecVal=="CHILDREN"){
			$("input[name=limitChild]").show();
			$("span[name=limitChildText]").show();
			$("input[name=limitChild]").removeAttr("disabled");
			}else{
			$("input[name=limitChild]").hide();
			$("span[name=limitChildText]").hide();
			$("input[name=limitChild]").attr("disabled","disabled")
			}
		});
		
		//选择规格
		$("#productBranchId1").change(function(){
			if($("#productBranchId1 option:selected").attr("data")!="310"){
				$("input[name=goodsNameProductBranch]").val($("#productBranchId1 option:selected").text());
			}else{
				$("input[name=goodsNameProductBranch]").val("");
			}
			$("input[name=goodsName1]").val($("input[name=goodsNameProductBranch]").val() + ' '+ $("input[name=goodsNameGoodsSpec]").val());
			if($("input[name=goodsName2]").val()==""){
				$("input[name=goodsName]").val($("input[name=goodsName1]").val());
			}else{
				$("input[name=goodsName]").val($("input[name=goodsName1]").val() + '【'+ $("input[name=goodsName2]").val() +'】');
			}
		});
		
		//【】中商品名
		$("input[name=goodsName2]").keyup(function() {
			if($("input[name=goodsName2]").val()==""){
				$("input[name=goodsName]").val($("input[name=goodsName1]").val());
			}else{
				$("input[name=goodsName]").val($("input[name=goodsName1]").val() + '【'+ $("input[name=goodsName2]").val() +'】');
			}
		});
		
		$("input[name=goodsName1]").keyup(function() {
			if($("input[name=goodsName2]").val()==""){
				$("input[name=goodsName]").val($("input[name=goodsName1]").val());
			}else{
				$("input[name=goodsName]").val($("input[name=goodsName1]").val() + '【'+ $("input[name=goodsName2]").val() +'】');
			}
		});
		$("input[name=deductValue]").keyup(function() {
			if($("input[name=deductValue]").val()==""){
				$("input[name=deductValue]").val(0);
			}
		});

		//TODO
		$("input:radio[name='cancelStrategySize']").change(function (){ 
			//$("input:radio[name='cancelStrategy']:eq(0)").attr("checked","checked");
			var cancelStrategySize = $("input[name=cancelStrategySize]:checked").val();
			if(cancelStrategySize == 'MULIT' ){
				$("#cancelStrategyContent").show();
				$("#cancelTimeTypeDiv1").show();
				$("#cancelStrategyContent").find(".latestCancelTime").removeAttr("disabled");
				if($("#cancelTimeType").attr("checked")){
					$("input[name='goodsReFundList[0].cancelTimeType']").val("OTHER");
				}else{
					$("input[name='goodsReFundList[0].cancelTimeType']").val("");
				}
			}else if(cancelStrategySize == "ONE"){
				$("#cancelStrategyContent").hide();
				$("#cancelStrategyContent").find(".latestCancelTime").attr("disabled","disabled");
				$("#cancelTimeTypeDiv1").hide();
				$("input[name='goodsReFundList[0].cancelTimeType']").val("OTHER");
			}
		});
		//控制退款策略显示方式
		//$("input:radio[name='cancelStrategy']").change(function (){
		//	var cancelStrategy = $("input[name=cancelStrategy]:checked").val();
		//	if(cancelStrategy == 'UNRETREATANDCHANGE') {
		//		$("#cancelStrategy_div0").hide();
		//		$("#cancelStrategy_div0_0").css("border-bottom-width","0px");
		//	} else {
		//		$("#cancelStrategy_div0").show();
		//		$("#cancelStrategy_div0_0").css("border-bottom-width","1px");
		//		$("#cancelStrategy_div0_0").css("border-bottom-style","solid");
		//		$("#cancelStrategy_div0_0").css("border-bottom-color","#D8DCE5");
		//	}
		//});
		$("#cancelTimeType").click(function(){
			if($("#cancelTimeType").attr("checked") == 'checked'){
				$("input[name='goodsReFundList[0].cancelTimeType']").val("OTHER");
			}else{
				$("input[name='goodsReFundList[0].cancelTimeType']").val("");
			}
		});
		
		$("#OTHER_DEBUT_VALUE").blur(function() { 
			var str = $(this).val();
			if(str == 100){
				var val = $("#OTHER_DEBUT_TYPE").val(); 
				if(val == 'PERCENT'){
					$.alert("您的设置就是“不可退改”，请通过直接选中“不可退改”实现。");
					$("input:radio[name='cancelStrategy']:eq(1)").attr("checked","checked");
				}
			}
		});


		$("#save").bind("click",function(){
			var distributorChecked = document.getElementById("distributorIds_4").checked;
			if(distributorChecked){
				var distributorUserIds = $("input:checkbox[name='distributorUserIds']:checked").val();
				if(typeof(distributorUserIds) =="undefined"){
					alert("请选择super系统分销商.");
					return;
				}
			}

            var categoryDetail = $('input:radio[name="categoryDetail"]').length;
            if (categoryDetail > 0) {
                var categoryDetailisChecked = $('input:radio[name="categoryDetail"]:checked').val();
                if (categoryDetailisChecked == null) {
                    alert("请选择商品品类栏目！");
                    return;
                }
            }

			var goodsType = $("input:radio[name='goodsType']:checked").val();
			var postFreeFlag = $("input:radio[name='postFreeFlag']:checked").val();
			if(goodsType == "EXPRESSTYPE_DISPLAY" && typeof(postFreeFlag) =="undefined"){
				alert("请选择是否免运费.");
				return;
			}
            var specialSmsFlag = $('#specialSmsFlag').attr('checked');
            if(specialSmsFlag){
                $('#specialSmsFlag').val('Y');
            }
			if($("#faxFlag").attr('checked')=='checked'){
				$("input[name='faxFlag']").val('Y');
			}else{
				$("input[name='faxFlag']").val('N');
			}
			
			var isEbkFlag = $('#isEbkFlag').attr('checked');
			if(isEbkFlag=='checked'){
				$('#ebkFlag').val('Y');
			}else{
				$('#ebkFlag').val('N');
			}
			if($("#noticeType").attr("checked")=="checked"){
				$("input[name='noticeType']").val('QRCODE');
			}else{
				$("input[name='noticeType']").val('SMS');
			}
			
			/*var isNotInTimeFlag = $('#isNotInTimeFlag').attr('checked');
			if(isNotInTimeFlag=='checked'){
				$('#notInTimeFlag').val('Y');
			}else{
				$('#notInTimeFlag').val('N');
			}*/
			var noticeWay1 = getNoticeWay();
		    if(noticeWay1=="isEbk"||noticeWay1==""){
		    	  $("#ebkUseStatusReturn").val($("input[name='ebkUseStatus']:checked").val());
		    }else{
		     	var status = getUseStatus();
			   // $("input[name='EBK_USE_STATUS']").val($("input[name='ebkUseStatus']:checked").val());
			    $("#ebkUseStatusReturn").val($("input[name='ebkUseStatus']:checked").val());
		    }
		   
			/**
			 * 验证正整数
			 */
			jQuery.validator.addMethod("isInteger1", function(value, element) {
			    var num = /^[1-9]{0}\d*(\.\d{1,2})?$/;
			    return this.optional(element) || (num.test(value));       
			 }, "只能填写整数");
		 
		 
			//验证
			var bFormValidation = $("#dataForm").validate({
				rules : {
					adult:{
						required : true,
						min:0,
						max:999
					},
					child:{
						required : true,
						min:0,
						max:999
					},
					minQuantity: {
						required : true,
						min:1,
						max:999
					},
					maxQuantity: {
						required : true,
						min:0,
						max:5000
					},
					deductValue: {
						isInteger1:true,
						min:0,
						max:999
					}
				}
			}).form();

            var typenew = $("#companyTypeNew").text();

            if($.trim(typenew) == "") {
                $("#contract_main").removeAttr("style");
                return false;
            }
			var filialeName = $("select.filialeCombobox").combobox("getValue");
			if(!filialeName) {
				var $combo = $("select.filialeCombobox").next();
				$("i[for=\"FILIALE\"]").remove();
				$combo.css('border-color', "red");
				$("<i for=\"FILIALE\" class=\"error\">该字段不能为空</i>").insertAfter($combo);
			}
			if(!bFormValidation || !filialeName){return false;}
			
			if($("#contractIdAdd").val()==""){
				$.alert("请选择供应商合同！");
				return false;
			}
			if(parseInt($("input[name=maxQuantity]").val())<parseInt($("input[name=minQuantity]").val())){
				$.alert("最小订购数量不能大于最大订购数量！");
				return false;
			}
			if($("select[name=useType] option:selected").val()=="PERIOD" &&
                    $("input[name=startTime]").val()>$("input[name=endTime]").val()){
				$.alert("开始时间不能大于结束时间！");
				return false;
			}
            if($("input[name=takeFlag][checked]").val()=="Y" &&
                    $("select[name=takeType] option:selected").val()=="POINT" &&
                    $("select[name=useType] option:selected").val()=="PERIOD" &&
                    $("select[name=takeAct] option:selected").val()=="AFTER" &&
                    $("input[name=takeDeadLineDay]").val() > $("input[name=endTime]").val()){
                $.alert("取票截止时间不能大于有效期结束时间！");
                return false;
            }
            if($("input[name=takeFlag][checked]").val()=="Y" &&
                    $("select[name=takeType] option:selected").val()=="PERIOD" &&
                    $("select[name=useType] option:selected").val()=="PERIOD" &&
                    $("input[name=takeEndTime]").val() > $("input[name=endTime]").val()){
                $.alert("取票结束时间不能大于有效期结束时间！");
                return false;
            }
            if($("input[name=takeFlag][checked]").val()=="Y" &&
                    $("select[name=takeType] option:selected").val()=="PERIOD" &&
                    $("select[name=useType] option:selected").val()=="TAKE_POINT" &&
                    $("select[name=useAct] option:selected").val()=="AFTER" &&
                    $("input[name=takeEndTime]").val() > $("input[name=useDeadLineDay]").val()){
                $.alert("取票截结束时间不能大于有效期截止时间！");
                return false;
            }
            if($("input[name=takeFlag][checked]").val()=="Y" &&
                    $("select[name=useType] option:selected").val()=="TAKE_POINT" &&
                    $("select[name=useAct] option:selected").val()=="INNER" &&
                    $("input[name=cancelStrategy]:checked").val() != "UNRETREATANDCHANGE"  &&
                    $("input[name=cancelStrategySize]:checked").val() == 'MULIT' &&
                    $("select[name='goodsReFundList[1].refundType'] option:selected").val() =="LAST_EXP"){
                $.alert("有效期设置找不到最晚有效期，退改不能按最晚有效期设置！");
                return false;
            }
			if(parseInt($("input[name=child]").val())==0 && parseInt($("input[name=adult]").val())==0){
				$.alert("儿童成人数量不能同时为0！");
				return false;
			}
			if('Y'==$("input[name='faxFlag']").val() && $("input[name='faxRuleId']").val()==""){
				$.alert("请选择供应商传真号！");
				return false;
			}
			//判断不适用日期
			/*
			var unvalidDate  = $("input[name=unvalid]").val();
			var isValidDate = true; 
			if(unvalidDate!="" && typeof(unvalidDate) != "undefined"){
				var unvalidDateArray =  unvalidDate.split(",");
				for(var i=0;i<unvalidDateArray.length;i++){
					var date = unvalidDateArray[i];
					var objRegExp = /^(\d{4})\-(\d{2})\-(\d{2})$/;
					if(!objRegExp.test(date)){
						isValidDate = false;
					}
				}
			}
			if(!isValidDate){
				$.alert("期票商品不适用日期格式不正确!");
				return;
			}*/
            var unvalidData="";
            var isApplyDate=$("input[name='isApplyDate']:checked").val();
             if(isApplyDate=="Y"){
                  var weeks="";
                  var dateScope="";
            	  $("#weeksExcludeTd").find("[name='weeksExclude']:checked").each(function(){
                      weeks+='"'+$(this).val()+'",';
                   })
            	  $("#datdExcludeTable tr").each(function(){
            	    if($(this).find("input[name='datdExcludeStartTime']").val()!=""&&$(this).find("input[name='datdExcludeEndTime']").val()!=""){
                 	dateScope+='{"startDate":"'+$(this).find("input[name='datdExcludeStartTime']").val()+'","endDate":"'+$(this).find("input[name='datdExcludeEndTime']").val()+'"},';
                 	}
                  })
                  unvalidData='{"weeks":['+weeks.substr(0,weeks.length-1)+'],"dateScope":['+dateScope.substr(0,dateScope.length-1)+']}';
                 if(weeks=="" && dateScope==""){
                     $.alert("请选择周期或日期范围！");
				      return false;
                 }
            }
            
			$("input[name='unvalidData']").val(unvalidData);
			//把最晚无损退票时间转化为分钟数
			$("#cancelStrategyContent").find("div.cancelStrategyDiv").each(function(){
					var target = $(this).find(".latestCancelTime");
					var day = $(this).find("select[name=latestCancelTime_Day]").val();
					var hour = $(this).find("select[name=latestCancelTime_Hour]").val();
					var minute = $(this).find("select[name=latestCancelTime_Minute]").val();
					var flag = $(this).find("select[name=plusflag]").find("option:selected").val();
					setLatestCancelTime(parseInt(day),parseInt(hour),parseInt(minute),target,flag);
			});
			//转换退改价格
			$("input[name=deductValue]").each(function(){
					if($.trim($(this).val())==''){ // 如果退改金额为空，设为0
					    $(this).val(0);
					}
					$(this).prev("input").val(parseInt($(this).val()*100));
			});
			
			
			if($("input[name='goodsReFundList[0].cancelTimeType']").val() == "OTHER"){
				var deductValue = "";
				var deductType = "";
				if($("input[name=cancelStrategySize]:checked").val() == "MULIT"){
					deductValue = $("#cancelTimeTypeDiv1").find("input[name=deductValue1]").val();
					deductType = $("#cancelTimeTypeDiv1").find("select[name=deductType]").val();
				}else{
					deductValue = $("#cancelTimeTypeDiv0").find("input[name=deductValue1]").val();
					deductType = $("#cancelTimeTypeDiv0").find("select[name=deductType]").val();
					$("#cancelStrategyContent").find(".latestCancelTime").attr("disabled","disabled");
				}
				$("input[name='goodsReFundList[0].deductType']").val(deductType);
				$("input[name='goodsReFundList[0].deductValue']").val(deductValue);
			}

            //复制退改
            var rescheduleContent = $(".reschedule-tabs-content");
            var value = rescheduleContent.find("input[name='goodsReschedule.changeDesc']:checked").val();
            if('0'==value || '1'==value){
                var target = rescheduleContent.find(".latestChangeTime");
                var day = rescheduleContent.find("select[name=latestChangeTime_Day]").eq(value).val();
                var hour = rescheduleContent.find("select[name=latestChangeTime_Hour]").eq(value).val();
                var minute = rescheduleContent.find("select[name=latestChangeTime_Minute]").eq(value).val();
                var flag = rescheduleContent.find("select[name=plusflag]").find("option:selected").eq(value).val();
                if(target.length>0){
                    setLatestCancelTime(parseInt(day),parseInt(hour),parseInt(minute),target,flag);
                }
            }
            $(".reschedule-tabs-content div:first-child input[name='goodsReschedule.changeDesc']").each(function(){
                if($(this).attr("checked")=='checked'){
                    $("input[name='goodsReschedule.changeCount']").val($(this).next().val());
                }
            });
            //

		    //任选日期
			if($("input[name=cancelStrategy]:checked").val() != "UNRETREATANDCHANGE"
			     && $("input[name=cancelStrategySize]:checked").val() == 'MULIT' 
			     && $("select[name='goodsReFundList[1].refundType'] option:selected").val() =="ANY_DAY"){
				var anyDay = $("input[name='goodsReFundList[1].anyDay']").val();                             
				if(anyDay ==""){
					$.alert("退改策略中任选日期不能为空");
					return false;
				}else{
					 $(".anyDay").val(anyDay);
				}
		    }


			$("input[name=goodsName]").val($.trim($("input[name=goodsName]").val()));
			var msg = '确认保存吗 ？';	
			if(refreshSensitiveWord($("#dataForm").find("input[type='text'],textarea"))){
				$("input[name=senisitiveFlag]").val("Y");
			 	msg = '内容含有敏感词,是否继续?';
			}else {
			$("input[name=senisitiveFlag]").val("N");
			}
			$("#save").hide();
			$.confirm(msg,function(){
				$.ajax({
					url : "/vst_admin/ticket/goods/goods/addSuppGoods.do",
					type : "post",
					data : $(".dialog #dataForm").serialize(),
					success : function(result) {
						if (!(result.code == "success")) {
							$("#save").show(); 
						}
						confirmAndRefresh(result);
					},
					error : function(){
						$("#save").show(); 
					}
				});
			},function(){
				$("#save").show(); 
			});
	});
var index = 2;
$("#add").bind("click",function(){
	if($("#cancelStrategyContent").find("div.cancelStrategyDiv").size()>=20){
		alert("最多允许保存20条退改说明");
		return;
	}
	//获得模板
	var template = $("#template").html();
	//设置index
	template = template.replace(/{{index}}/g,index);
	index++;
	var templateObj = $(template);
	//添加模板
	$("#cancelStrategyContent").append(templateObj);
	//判断是不是期票
	var aperiodicFlag = $("#aperiodicFlag").val();
	if(aperiodicFlag=="Y"){
		var obj= $("select[name='goodsReFundList[1].refundType'] option:selected"); 
		$(".refundType").val(obj.val());
		if(obj.val()=="ORDER_DAY"){
			$("select[name=plusflag]").attr("disabled",true).val(-1);
		}
	}
	//增加删除
	templateObj.find(".delete").click(function(){
		$.confirm("是否删除",function(){
					templateObj.remove();
		});
	});
});


 function expDisableById(id){
     $("#"+id).find("input").attr("disabled","disabled");
     $("#"+id).find("select").attr("disabled","disabled");
 }

 function expEnableById(id){
     $("#"+id).find("input").attr("disabled",false);
     $("#"+id).find("select").attr("disabled",false);
 }

 function cleanById(id){
     $("#"+id).find("input").each(function(){
         $(this).val("");
     })
     $("#"+id).find("select").each(function(){
         $(this).find("option").eq(0).attr("selected",true);
     })
 }

//可退改、不可退改
$(function(){
	var obj = $("input[name=cancelStrategy]:checked");
	if(obj.val() != "UNRETREATANDCHANGE" ){
		 $("#refundStrategy").show();
		// expEnableById("refundStrategy");
	}else{
         $("#refundStrategy").hide();
     //    expDisableById("refundStrategy");
	}
});

$("input[name=cancelStrategy]").bind("click",function(){
     if($(this).val() != "UNRETREATANDCHANGE"){
        $("#refundStrategy").show();
     }else{
         $("#refundStrategy").hide();
     }
 });

function setFlag(){
	$("select[name=latestCancelTime_Day]").each(function(){
		if($(this).val()==0){
				$(this).parent().find("select[name=plusflag]").attr("disabled",true).val(1);
			}else{
				$(this).parent().find("select[name=plusflag]").removeAttr("disabled");
			}
	});
}
//分时间段 退改 select
$("select[name='goodsReFundList[1].refundType']").live("change",function(){
	$(".refundType").val($(this).val());
	if($(this).val()=="ORDER_DAY"){
     		$("select[name=plusflag]").attr("disabled",true).val(-1);
	}else{
		setFlag();
	}
     if($(this).val()=="ANY_DAY"){
     	 $("#refundAnyDay").show();
     	 $("#refundAnyDay").find("input").attr("disabled",false);
     	 $(".anyDay").attr("disabled", false);
     	 
     }else{
     	$("#refundAnyDay").hide(); 
     	$("#refundAnyDay").find("input").attr("disabled",true);
     	$(".anyDay").attr("disabled", true);
     }
 });


//设置最晚取消时间
function setLatestCancelTime(day,hour,minute,target,plusflag){
	var targetVal=0;
	if(plusflag == "-1"){
		targetVal = -day*24*60-hour*60-minute;
	}else{
		targetVal = day*24*60-hour*60-minute;
		
	}
	target.val(targetVal);
}


        $(function () {
			//时间为当日的时限制为时间前
			$("#cancelStrategyContent").find(".cancelStrategyDiv").each(function(){
				var obj = $(this).find("select[name=latestCancelTime_Day] option:selected");
				var obj2= $("select[name='goodsReFundList[1].refundType'] option:selected");   
				
				if(parseInt(obj.val())== 0 && obj2.val()!="ORDER_DAY"){
					$(this).find("select[name=plusflag]").attr("disabled",true).val(1);
				}else if(obj2.val()=="ORDER_DAY"){
					$(this).find("select[name=plusflag]").attr("disabled",true).val(-1);
				}else{
					$(this).find("select[name=plusflag]").removeAttr("disabled");
				}
				
				if(obj2.val()=="ANY_DAY"){
					$("#refundAnyDay").show(); 
					$("#refundAnyDay").find("input").attr("disabled",false);
				}else{
					$("#refundAnyDay").hide();
					$("#refundAnyDay").find("input").attr("disabled",true);
				}
            });
        });

		$("select[name=latestCancelTime_Day]").live("change",function(){
			var obj=$(this);
			var obj2= $("select[name='goodsReFundList[1].refundType'] option:selected");  
			if(parseInt(obj.val())== 0 && obj2.val()!="ORDER_DAY"){
				obj.parent().find("select[name=plusflag]").attr("disabled",true).val(1);
			}else if(obj2.val()=="ORDER_DAY"){
				obj.parent().find("select[name=plusflag]").attr("disabled",true).val(-1);
			}else if(parseInt(obj.val())!= 0 && obj2.val()!="ORDER_DAY"){
				obj.parent().find("select[name=plusflag]").removeAttr("disabled");
			}
		
		});

        $("select[name='latestChangeTime_Day']").live("change", function () {
            var obj = $(this);
            if (parseInt(obj.val()) == 0) {
                obj.prev("select[name=plusflag]").attr("disabled", true).val(1);
            } else {
                obj.prev("select[name=plusflag]").removeAttr("disabled");
            }
        });

		$('select[name=payTarget]').live('change', function() {
			var disable = $(this).val() == "PAY";

            var tr = $('#cancelStrategyTR');
            var allForm = tr.find('[name]');
            allForm.prop('disabled', disable);
            var allBtn =tr.find('a');
            if (disable) {
                allBtn.hide();
            } else {
                allBtn.show();
            }
           initChangeStrategy();
		});
//预订日期限制选择
$("input[name='limitBookDayFlag']").live("click",function(){
	var limitBookDayFlag = $(this).val();
	if(limitBookDayFlag == 'Y'){
		$("#limitBookDay").removeAttr("disabled");
	}else{
		$("#limitBookDay").attr("disabled","disabled");
	}
});

$("input[name='goodsType']").live("click",function(){
    var value = $(this).val();
    if(value==="EXPRESSTYPE_DISPLAY"){
        $("select[name='expressType']").attr("disabled",false);
        $("input[name='postFreeFlag']").attr("disabled",false);
    }else if(value==="NOTICETYPE_DISPLAY"){
        $("select[name='expressType']").attr("disabled",true);
        $("input[name='postFreeFlag']").attr("disabled",true);
    }
    initChangeStrategy();
});

var destSelectDialog;
var markDest;
var markDestId;
//选择
function onSelectDest(params){
	if(params!=null){
		$("#"+markDest).val(params.destName);
		$("#"+markDestId).val(params.destId);
	}
	destSelectDialog.close();
	$("#destError").hide();
}

//打开选择归属地窗口
$("input[name=attributionName]").bind("click",function(){
	markDest = $(this).attr("id");
	markDestId = $("#attributionId").attr("id");
	var url = "/vst_admin/biz/attribution/selectAttributionList.do";
	destSelectDialog = new xDialog(url,{},{title:"选择归属地",iframe:true,width:"1000",height:"600"});
});

//提示add by zhoudengyun
$("input[name=packageFlag]").bind('change',function(){
	var packageFlag = $(this).val();
	if(packageFlag=="Y"){
		$("#tips").show();
	}else{
		$("#tips").hide();
	}
});

$("select.filialeCombobox").combobox({
    multiple:false,
    width: 170,
    filter:function(q,row){
		var opts=$(this).combobox("options");
		return row[opts.textField].indexOf(q) > -1;
	},
	onHidePanel: function () {
		var filialeName = $(this).combobox("getValue");
		if(!!filialeName) {
			$(".combo").css('border-color', "#abc");
			$("i[for=\"FILIALE\"]").css("display", "none");
		}
	}
});
 function deleteDatdExclude(obj){
    var hang = $(obj).parent().parent("tr").prevAll().length; 
    $(obj).parent().parent("tr").remove();
 }
//
        (function(){
            var titles = $(".reschedule-tabs-title ul li");
            var contents = $(".reschedule-tabs-content div");
            if(titles.length==0||contents.length==0)
                return;
            titles.eq(1).addClass("reschedule-tabs-select");
            contents.eq(1).css("display","block");
            $("input[name='goodsReschedule.changeStrategy']").val("NOTRESCHEDULE");
            titles.each(function(i,element){
               $(element).click(function(){
                var isEbkFlag= $("input[type='checkbox'][id='isEbkFlag']").is(':checked');
                var isNoticeType= $("input[type='checkbox'][id='noticeType']").is(':checked');
                var isFaxFlag=$("input[type='checkbox'][id='faxFlag']").is(':checked');
                var ebkUseStatus=$("input[type='radio'][name='ebkUseStatus']:checked").val();
                var goodsType=$("input[type='radio'][name='goodsType']:checked").val();
                var aperiodicFlag=$("input[name='aperiodicFlag']").val();
                var payTarget=$("select[name='payTarget']").find("option:selected").val();
                
                    titles.removeClass("reschedule-tabs-select");
                    contents.css("display","none");
                    $(this).addClass("reschedule-tabs-select");
                    contents.eq(i).css("display","block");
                    if(i==0){
                        $("input[name='goodsReschedule.changeStrategy']").val("RESCHEDULE");
                      if(!isNoticeType&&!isFaxFlag&&ebkUseStatus=='EBK_INTIME_RETURN'&&goodsType=='NOTICETYPE_DISPLAY'&&aperiodicFlag!='Y'&&payTarget=='PREPAID'){
                     $("input[type=radio][name='goodsReschedule.changeDesc'][value='0']").attr("checked",'checked');
                     $("input[name='goodsReschedule.changeDesc'][value='0']").removeAttr("disabled","disabled");
                     $(".reschedule-tabs-content").find("input[type='text']").eq(0).val("1");
                     $(".reschedule-tabs-content").find("input[type='text']").eq(0).removeAttr("disabled","disabled");
                     $(".reschedule-tabs-content").find("select[name='plusflag']").eq(0).val("1");
                     $(".reschedule-tabs-content").find("select[name='plusflag']").eq(0).removeAttr("disabled","disabled");
                     $(".reschedule-tabs-content").find("select[name='latestChangeTime_Day']").eq(0).val("0");
                     $(".reschedule-tabs-content").find("select[name='latestChangeTime_Day']").eq(0).removeAttr("disabled","disabled");
                     $(".reschedule-tabs-content").find("select[name='latestChangeTime_Hour']").eq(0).val("0");
                     $(".reschedule-tabs-content").find("select[name='latestChangeTime_Hour']").eq(0).removeAttr("disabled","disabled");
                     $(".reschedule-tabs-content").find("select[name='latestChangeTime_Minute']").eq(0).val("0");
                     $(".reschedule-tabs-content").find("select[name='latestChangeTime_Minute']").eq(0).removeAttr("disabled","disabled");
                    }else{
                    $("input[type=radio][name='goodsReschedule.changeDesc'][value='1']").attr("checked",'checked');
                    $("input[name='goodsReschedule.changeDesc'][value='0']").attr("disabled","disabled");
                    $(".reschedule-tabs-content").find("input[type='text']").eq(0).val("1");
                    $(".reschedule-tabs-content").find("input[type='text']").eq(0).attr("disabled","disabled");
                    $(".reschedule-tabs-content").find("select[name='plusflag']").eq(0).val("1");
                    $(".reschedule-tabs-content").find("select[name='plusflag']").eq(0).attr("disabled","disabled");
                    $(".reschedule-tabs-content").find("select[name='latestChangeTime_Day']").eq(0).val("0");
                    $(".reschedule-tabs-content").find("select[name='latestChangeTime_Day']").eq(0).attr("disabled","disabled");
                    $(".reschedule-tabs-content").find("select[name='latestChangeTime_Hour']").eq(0).val("0");
                    $(".reschedule-tabs-content").find("select[name='latestChangeTime_Hour']").eq(0).attr("disabled","disabled");
                    $(".reschedule-tabs-content").find("select[name='latestChangeTime_Minute']").eq(0).val("0");
                    $(".reschedule-tabs-content").find("select[name='latestChangeTime_Minute']").eq(0).attr("disabled","disabled");
                    }  
                    }else{
                        $("input[name='goodsReschedule.changeStrategy']").val("NOTRESCHEDULE");
                        $("input[type=radio][name='goodsReschedule.changeDesc'][value='2']").attr("checked",'checked');
                    }
                   
                  });
             
            });
            /*$("#isNotInTimeFlag").click(function(){
                var div = $("#reschedule");
                if(div.length==0)
                return;
                if($(this).attr("checked")=="checked"){
                    $("#reschedule").hide();
                }else{
                    $("#reschedule").show();
                }
            });*/
        })()
    //# sourceURL=goods.add
    //初始化改期策略
function initChangeStrategy(){
$(".reschedule-tabs-title ul li").eq(0).removeClass("reschedule-tabs-select");
$(".reschedule-tabs-title ul li").eq(1).addClass("reschedule-tabs-select");
$(".reschedule-tabs-content div").eq(0).css("display","none");
$(".reschedule-tabs-content div").eq(1).css("display","block");
$("input[name='goodsReschedule.changeStrategy']").val("NOTRESCHEDULE");
$("input[type=radio][name='goodsReschedule.changeDesc'][value='2']").attr("checked",'checked');
$("input[name='goodsReschedule.changeDesc'][value='0']").removeAttr("disabled","disabled");
$(".reschedule-tabs-content").find("input[type='text']").eq(0).val("1");
$(".reschedule-tabs-content").find("input[type='text']").eq(0).removeAttr("disabled","disabled");
$(".reschedule-tabs-content").find("select[name='plusflag']").eq(0).val("1");
$(".reschedule-tabs-content").find("select[name='plusflag']").eq(0).removeAttr("disabled","disabled");
$(".reschedule-tabs-content").find("select[name='latestChangeTime_Day']").eq(0).val("0");
$(".reschedule-tabs-content").find("select[name='latestChangeTime_Day']").eq(0).removeAttr("disabled","disabled");
$(".reschedule-tabs-content").find("select[name='latestChangeTime_Hour']").eq(0).val("0");
$(".reschedule-tabs-content").find("select[name='latestChangeTime_Hour']").eq(0).removeAttr("disabled","disabled");
$(".reschedule-tabs-content").find("select[name='latestChangeTime_Minute']").eq(0).val("0");
$(".reschedule-tabs-content").find("select[name='latestChangeTime_Minute']").eq(0).removeAttr("disabled","disabled");
$(".reschedule-tabs-content").find("input[type='text']").eq(1).val("1");
$(".reschedule-tabs-content").find("select[name='plusflag']").eq(1).val("1");
$(".reschedule-tabs-content").find("select[name='latestChangeTime_Day']").eq(1).val("0");
$(".reschedule-tabs-content").find("select[name='latestChangeTime_Hour']").eq(1).val("0");
$(".reschedule-tabs-content").find("select[name='latestChangeTime_Minute']").eq(1).val("0");

}

 //有效期开始
 function disableExpItem(){
     //取票下面的组件
     expDisableById("takeDiv");
     //使用有效期下单后下面的组件
     expDisableById("useByPoint");
 }

 $("input[name=takeFlag]").bind("click",function(){
     $("input[name=takeFlag]").attr("checked",false);
     $(this).attr("checked",true);
     $("select[name=useType]").find("option[value='PERIOD']").attr("selected",true);
     $("#useByPeriod").show();
     $("#useByPoint").hide();

     expEnableById("useByPeriod");
     expDisableById("useByPoint");

     cleanById("useByPoint");
     $("#useTimeHourAndMinute").show();
     expEnableById("useTimeHourAndMinute");
     $("#useActTime").hide();
     expDisableById("useActTime");

     if($(this).val() == "Y"){

        $("select[name=takeType]").find("option[value='PERIOD']").attr("selected",true);
        $("#takeByPeriod").show();
        $("#takeByPoint").hide();

        $("#takeDiv").show();
        $("#userText").text("取票后");
        $("select[name=useType] option").each(function(){
            if($(this).val()=="ORDER_POINT") {
                $(this).hide();
            }else{
                $(this).show();
            }
        });

         expEnableById("takeByPeriod");
         expDisableById("takeByPoint");
         $("select[name=takeType]").attr("disabled",false);
     }else{
         $("#takeDiv").hide();
         $("#userText").text("下单后");
         $("select[name=useType] option").each(function(){
             if($(this).val()=="TAKE_POINT") {
                 $(this).hide();
             }else{
                 $(this).show();
             }
         });

         expDisableById("takeDiv");
     }
 });

 $("select[name=takeType]").live("change",function(){
     if($(this).val()=="PERIOD"){
         $("#takeByPeriod").show();
         $("#takeByPoint").hide();

         expEnableById("takeByPeriod");
         expDisableById("takeByPoint");
     }else{
         $("#takeByPoint").show();
         $("#takeByPeriod").hide();

         expEnableById("takeByPoint");
         expDisableById("takeByPeriod");

         if($("select[name=takeAct] option:selected").val()=="INNER"){
             expDisableById("takeActTime")
         }else{
             expEnableById("takeActTime");
         }
     }
 });

 $("select[name=takeTimeType]").live("change",function(){
     if($(this).val()=="DAY"){
         $("#takeTimeHourAndMinute").show();
         expEnableById("takeTimeHourAndMinute");
     }else{
         $("#takeTimeHourAndMinute").hide();
         expDisableById("takeTimeHourAndMinute");
     }
 });

 $("select[name=takeAct]").live("change",function(){
     if($(this).val()=="AFTER"){
         $("#takeActTime").show();
         expEnableById("takeActTime");
     }else{
         $("#takeActTime").hide();
         expDisableById("takeActTime");
     }
 });

$("select[name=useType]").live("change",function(){
    if($(this).val()=="PERIOD"){
        $("#useByPeriod").show();
        $("#useByPoint").hide();

        expEnableById("useByPeriod");
        expDisableById("useByPoint");
    }else{
        $("#useByPoint").show();
        $("#useByPeriod").hide();

        expEnableById("useByPoint");
        expDisableById("useByPeriod");

        if($("select[name=useAct] option:selected").val()=="INNER"){
            expDisableById("useActTime");
        }else{
            expEnableById("useActTime");
        }
    }
});

$("select[name=useTimeType]").live("change",function(){
    if($(this).val()=="DAY"){
        $("#useTimeHourAndMinute").show();
        expEnableById("useTimeHourAndMinute");
    }else{
        $("#useTimeHourAndMinute").hide();
        expDisableById("useTimeHourAndMinute");
    }
});

$("select[name=useAct]").live("change",function(){
    if($(this).val()=="AFTER"){
        $("#useActTime").show();
        expEnableById("useActTime");
    }else{
        $("#useActTime").hide();
        expDisableById("useActTime");
    }
});

//有效期结束

        //合同结算主体code转换
        function lvSubjectCodeConvert(lvAccSubjectCode){
            var returnCode="";
            switch(lvAccSubjectCode){
                case "DEFAULT":
                    returnCode="JOYU";
                    break;
                case "LVMAMA":
                    returnCode="GUOLV";
                    break;
                case "LVMAMAXINGLV":
                    returnCode="XINGLV";
                    break;
            }
            return returnCode;
        }
 //@ sourceURL=addSupp
 //判断通知供应商方式
 function getNoticeWay(){
 		//Ebk
 		if($("#faxFlag").attr("checked")!="checked"&&$("#noticeType").attr("checked")!="checked"){
 			return "isEbk";
 		} else if($("#noticeType").attr("checked")=="checked"){  		//二维码
 			return "qcode";
 		}else if($("#faxFlag").attr("checked")=="checked"&&$("#noticeType").attr("checked")!="checked"){
 			return "fax";
 		}else{
 			return ;
 		}
 }
 //判断使用状态返回
 	function getUseStatus(){
 		var noticeWay = getNoticeWay(); 
 			if($("input[name='ebkUseStatus']:checked").val()=="EBK_NOT_RETURN"){
 			    $('#notInTimeFlag').val('Y');
 			}else if($("input[name='ebkUseStatus']:checked").val()=="EBK_NOTINTIME_RETURN"){
 			   $('#notInTimeFlag').val('Y');
 			}else if($("input[name='ebkUseStatus']:checked").val()=="EBK_INTIME_RETURN"){
 			      $('#notInTimeFlag').val('N');
 			}
 		//二维码
	   if(noticeWay=="qcode"){ 
			 if($("#providerName").val()=='LVMAMA'||$("#isAutoPerform").val()==2){ //可返回，及时
 		 		return "INTIME_RETURN";
 		 	}else if($("#isAutoPerform").val()!=1&&$("#isAutoPerform").val()!=2){ //无对接（服务商管理中未勾选推送或查询）
 		 		 return "NOT_RETURN";  
 		 	}else if($("#isAutoPerform").val()==1){//可返回，不及时
 		 		return "NOTINTIME_RETURN";
 		 	}else{
 		 		return "NOT_RETURN";  
 		 	}
 		}
 		//传真
 		if(noticeWay=="fax"){  //不可返回
 			return "NOT_RETURN";
 		}
 		//ebk
 		if(noticeWay=="isEbk"){
 			if($("input[name='ebkUseStatus']:checked").val()=="EBK_NOT_RETURN"){
 			    $('#notInTimeFlag').val('Y');
 				 return "NOT_RETURN";
 			}else if($("input[name='ebkUseStatus']:checked").val()=="EBK_NOTINTIME_RETURN"){
 			   $('#notInTimeFlag').val('Y');
 			   return "NOTINTIME_RETURN";
 			}else if($("input[name='ebkUseStatus']:checked").val()=="EBK_INTIME_RETURN"){
 			      $('#notInTimeFlag').val('N');
 				  return "INTIME_RETURN";
 			}
 		}
 	}
 	//切换是否使用状态返回选项 根据是否为系统选择决定是否勾选复选框
 	function changeUseStatus(){
 		var status= getUseStatus();
 		if($("#isBusinessVal").val()=='N'||$("#isBusinessVal").val()==''){ //是系统自动选择
 			$("#isBusiness").removeAttr("checked");
 			$("#isBusiness").val("N");
 			if(status==""){
 				$("input[name='useStatus']").val("NOT_RETURN");
 			}else {
 				$("input[name='useStatus']").val(status);
 				$("#useStatus").find("option[value="+status+"]").attr("selected",true);
 			}
 		}else if($("#isBusinessVal").val()=='Y'){ //系统不去计算，由业务人员维护
 			$("#isBusiness").attr("checked","checked");
 			 //直接取得数据库中的数据
 			$("#isBusiness").val("Y");
 			$("input[name='useStatus']").val( $("option[name='useStatusOpt']:checked").val());
 		}
 	}
 	
 	 //使用状态是是否开启人工选择
	 $("#isBusiness").change(function(){
	 		if($("#isBusiness").attr("checked")=="checked"){
	 				$("#isBusinessVal").val('Y');
	 				$("input[name='isBusiness']").val("Y");
	 				changeUseStatus();
	 				$("input[name='useStatus']").val( $("option[name='useStatusOpt']:checked").val());
	 				$("#useStatus").removeAttr("disabled");
	 				$("#useStatusText").text("(由业务产品经理维护)");
	 		}else{
	 				$("#isBusinessVal").val('N');
	 				$("input[name='isBusiness']").val("N");
	 				changeUseStatus();
	 				$("#useStatus").attr("disabled","disabled")
	 				$("#useStatusText").text("(由系统自动维护)");
	 		}
	 });
	 
	 	//*ebk使用状态反馈切换自动计算使用状态返回
	 $("[name='ebkUseStatus']").click(function(){
   		changeUseStatus();
   		initChangeStrategy();
 	  });
 	  
 	   $('#useStatus').change(function(){ 
 	  		$("input[name='useStatus']").val($(this).children('option:selected').val()); 
 	  });

        document.getElementById('productBranchId1').onchange=function () {
            var branchId= this.options[this.options.selectedIndex].value;
            var suppGoodsId =$("#suppGoodsId").val();
            var str="";
            $.ajax({
                url: "/vst_admin/ticket/goods/goods/findSuppGoodsDetail.do",
                type: "post",
                data: {"branchId": branchId,"suppGoodsId":suppGoodsId},
                async: true,
                success: function (data) {
                    if (data.status = 200) {
                        $("#suppGoodsDetailDiv").empty();
                        var jsonData = JSON.parse(data.data);
                        if (!jsonData || jsonData.length==0) {
                            $("#suppGoodsDetailDiv").append("<p>没有商品品类选项，不用填写！</p>");
                        } else {
                            for (var i = 0; i < jsonData.length; i++) {
                                var temp = jsonData[i];
                                if (temp.suppChildId == 310001) {
                                    str = "checked=checked";
                                    $("#suppGoodsDetailDiv").append("<input type='radio' name='categoryDetail'" + str + " value=" + temp.suppChildId + " />" + temp.goodsCateGoryValue);
                                } else {
                                    $("#suppGoodsDetailDiv").append("<input type='radio' name='categoryDetail' value=" + temp.suppChildId + " />" + temp.goodsCateGoryValue);
                                }
                            }
                        }
                    }


                }
            });

        }
</script>