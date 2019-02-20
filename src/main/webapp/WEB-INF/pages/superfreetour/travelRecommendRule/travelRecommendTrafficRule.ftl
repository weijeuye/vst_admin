<!-- 交通规则设置 -->
		<#if travelRecommendTrafficRule?? && travelRecommendTrafficRule !=null >
		<div id="trafficTable" class="tabContent cf plane-ticket-set js-tab-con" style="display:block">
			<p class="main-title">机票规则设置</p>
			<form id="travelRecommendTrafficRuleForm" name="travelRecommendTrafficRuleFrom">
			<input type="hidden" id="trafficRuleId" name="trafficRuleId" value="${travelRecommendTrafficRule.trafficRuleId}"></input>
			<input type="hidden" id="recommendId" name="recommendId" value="${recommendId}"></input>
			<dl class="clearfix cf">
				<dt>对接类型</dt>
				<dd>
					<label><input type="radio" name="rule-type" value="DUIJIE" <#if travelRecommendTrafficRule.trafficType=="DUIJIE"> checked="checked"</#if> >对接机票优先</label>
					<label><input type="radio" name="rule-type" value="QIEWEI" <#if travelRecommendTrafficRule.trafficType=="QIEWEI"> checked="checked"</#if> >切位机票优先</label>
					<label><input type="radio" name="rule-type" value="LIANGXIANG"  <#if travelRecommendTrafficRule.trafficType=="LIANGXIANG"> checked="checked"</#if>>良翔机票优先</label>
				</dd>
			</dl>
			<dl class="clearfix cf">
				<dt>舱等</dt>
				<dd>
					<label><input type="radio" name="rule-space" value="ECONOMY" <#if travelRecommendTrafficRule.cabinLevel=="ECONOMY"> checked="checked"</#if> >经济舱</label>
					<label><input type="radio" name="rule-space" value="BUSINESS" <#if travelRecommendTrafficRule.cabinLevel=="BUSINESS"> checked="checked"</#if> >公务舱</label>
					<label><input type="radio" name="rule-space" value="FIRST" <#if travelRecommendTrafficRule.cabinLevel=="FIRST"> checked="checked"</#if> >头等舱</label>
				</dd>
			</dl>
			
			<dl class="clearfix cf">
				<dt>中转</dt>
				<dd>
					<label><input type="checkbox" name="rule-transfer" value="Y"  <#if travelRecommendTrafficRule.transitFlag=="Y"> checked="checked"</#if> >无中转</label>
				</dd>
			</dl>
			<dl class="clearfix cf">
				<dt>经停</dt>
				<dd>
					<label><input type="checkbox" name="rule-stop" value="Y" <#if travelRecommendTrafficRule.stopFlag=="Y"> checked="checked"</#if> >无经停</label>
				</dd>
			</dl>
			<dl class="clearfix cf">
				<dt>隔夜航班</dt>
				<dd>
					<label><input type="checkbox" name="rule-night" value="Y" <#if travelRecommendTrafficRule.nightFlag=="Y"> checked="checked"</#if> >无隔夜</label>
				</dd>
			</dl>
			<dl class="clearfix cf">
				<dt>去程出发时间范围</dt>
				<dd>
					<div class="time-begin">
						<#--<input class="flat-input flat-input-long" type="text" placeholder="设置起始时间">-->
						 <input errorEle="searchValidate" type="text" name="goStartMin" class="Wdate w110" id="d4321" onFocus="WdatePicker({readOnly:'true',dateFmt:'H:mm'})"   placeholder="设置起始时间" value="${travelRecommendTrafficRule.goStartMintime!''}"/>
						
					</div>
					 -
					<div class="time-end">
						<#--<input class="flat-input flat-input-long" type="text" placeholder="设置截止时间">-->
						<input errorEle="searchValidate" type="text" name="goStartMax" class="Wdate w110" id="d4321" onFocus="WdatePicker({readOnly:'true',dateFmt:'H:mm'})" placeholder="设置截止时间" value="${travelRecommendTrafficRule.goStartMaxtime!''}"/>
						
					</div>

				</dd>
			</dl>
			<dl class="clearfix cf">
				<dt>去程到达时间范围</dt>
				<dd>
					<div class="time-begin">
						
						<input errorEle="searchValidate" type="text" name="goArriveMin" class="Wdate w110" id="d4321" onFocus="WdatePicker({readOnly:'true',dateFmt:'H:mm'})" placeholder="设置起始时间" value="${travelRecommendTrafficRule.goArriveMintime!''}"/>
						
					</div>
					 -
					<div class="time-end">
						<!--<input class="flat-input flat-input-long" type="text" placeholder="设置截止时间">-->
						<input errorEle="searchValidate" type="text" name="goArriveMax" class="Wdate w110" id="d4321" onFocus="WdatePicker({readOnly:'true',dateFmt:'H:mm'})" placeholder="设置截止时间" value="${travelRecommendTrafficRule.goArriveMaxtime!''}"/>
					
					</div>
				</dd>
			</dl>
			<dl class="clearfix cf">
				<dt>返程出发时间范围</dt>
				<dd>
					<div class="time-begin">
						<#--<input class="flat-input flat-input-long" type="text" placeholder="设置起始时间">-->
						<input errorEle="searchValidate" type="text" name="backStartMin" class="Wdate w110" onFocus="WdatePicker({readOnly:'true',dateFmt:'H:mm'})"  placeholder="设置起始时间" value="${travelRecommendTrafficRule.backStartMintime!''}"/>
						
					</div>
					-
					<div class="time-end">
						<#--<input class="flat-input flat-input-long" type="text" placeholder="设置截止时间">-->
						<input errorEle="searchValidate" type="text" name="backStartMax" class="Wdate w110"  onFocus="WdatePicker({readOnly:'true',dateFmt:'H:mm'})" placeholder="设置截止时间" value="${travelRecommendTrafficRule.backStartMaxtime!''}"/>
						
					</div>
				</dd>
			</dl>
			</form>
			<a class="btn btn-blue save-traffic-btn">保存</a>
		</div>
		
		<#else>
		<div  id="trafficTable" class="tabContent cf plane-ticket-set js-tab-con" style="display:block">
			<p class="main-title">机票规则设置</p>
			<form id="travelRecommendTrafficRuleForm" name="travelRecommendTrafficRuleFrom">
			<input type="hidden" id="trafficRuleId" name="trafficRuleId" value="${trafficRuleId}">
			<input type="hidden" id="recommendId" name="recommendId" value="${recommendId}"></input>
			<dl class="clearfix cf">
				<dt>对接类型</dt>
				<dd>
					<label><input type="radio" name="rule-type" value="DUIJIE">对接机票优先</label>
					<label><input type="radio" name="rule-type" value="QIEWEI">切位机票优先</label>
					<label><input type="radio" name="rule-type" value="LIANGXIANG">良翔机票优先</label>
				</dd>
			</dl>
			<dl class="clearfix cf">
				<dt>舱等</dt>
				<dd>
					<label><input type="radio" name="rule-space" value="ECONOMY">经济舱</label>
					<label><input type="radio" name="rule-space" value="BUSINESS">公务舱</label>
					<label><input type="radio" name="rule-space" value="FIRST">头等舱</label>
				</dd>
			</dl>
			<#--<dl class="clearfix cf">
				<dt>航司</dt>
				<dd class="js-require">
					<label><input type="radio" name="rule-boat" value="N">无要求</label>
					<div class="plane-choose-box">
                        <label><input type="radio" name="rule-boat" class="require js-require1" value="Y">有要求</label>
                        <p><i class="red">*</i>
                            <span class="plane-name-box"></span>
                        <input type="text" placeholder="请选择航司" class="form-control js-boat-select require-con" disabled="disabled">
                        </p>
                    </div>
                </dd>
			</dl>-->
			
			<dl class="clearfix cf">
				<dt>中转</dt>
				<dd>
					<label><input type="checkbox" name="rule-transfer" value="Y">无中转</label>
				</dd>
			</dl>
			<dl class="clearfix cf">
				<dt>经停</dt>
				<dd>
					<label><input type="checkbox" name="rule-stop" value="Y">无经停</label>
				</dd>
			</dl>
			<dl class="clearfix cf">
				<dt>隔夜航班</dt>
				<dd>
					<label><input type="checkbox" name="rule-night" value="Y">无隔夜</label>
				</dd>
			</dl>
			<dl class="clearfix cf">
				<dt>去程出发时间范围</dt>
				<dd>
					<div class="time-begin">
						<#--<input class="flat-input flat-input-long" type="text" placeholder="设置起始时间">-->
						 <input errorEle="searchValidate" type="text" name="goStartMin" class="Wdate w110" id="d4321" onFocus="WdatePicker({readOnly:'true',dateFmt:'H:mm'})"   placeholder="设置起始时间" />
				
					</div>
					 -
					<div class="time-end">
						<#--<input class="flat-input flat-input-long" type="text" placeholder="设置截止时间">-->
						<input errorEle="searchValidate" type="text" name="goStartMax" class="Wdate w110" id="d4321" onFocus="WdatePicker({readOnly:'true',dateFmt:'H:mm'})" placeholder="设置截止时间" />
					
					</div>

				</dd>
			</dl>
			<dl class="clearfix cf">
				<dt>去程到达时间范围</dt>
				<dd>
					<div class="time-begin">
						<#--<input class="flat-input flat-input-long" type="text" placeholder="设置起始时间">-->
						<input errorEle="searchValidate" type="text" name="goArriveMin" class="Wdate w110" id="d4321" onFocus="WdatePicker({readOnly:'true',dateFmt:'H:mm'})" placeholder="设置起始时间" />
					
					</div>
					 -
					<div class="time-end">
						<!--<input class="flat-input flat-input-long" type="text" placeholder="设置截止时间">-->
						<input errorEle="searchValidate" type="text" name="goArriveMax" class="Wdate w110" id="d4321" onFocus="WdatePicker({readOnly:'true',dateFmt:'H:mm'})" placeholder="设置截止时间" />
					
					</div>
				</dd>
			</dl>
			<dl class="clearfix cf">
				<dt>返程出发时间范围</dt>
				<dd>
					<div class="time-begin">
						<#--<input class="flat-input flat-input-long" type="text" placeholder="设置起始时间">-->
						<input errorEle="searchValidate" type="text" name="backStartMin" class="Wdate w110" onFocus="WdatePicker({readOnly:'true',dateFmt:'H:mm'})"  placeholder="设置起始时间" />
					
					</div>
					-
					<div class="time-end">
						<#--<input class="flat-input flat-input-long" type="text" placeholder="设置截止时间">-->
						<input errorEle="searchValidate" type="text" name="backStartMax" class="Wdate w110"  onFocus="WdatePicker({readOnly:'true',dateFmt:'H:mm'})" placeholder="设置截止时间" />
						
					</div>
				</dd>
			</dl>
			</form>
			<a class="btn btn-blue save-traffic-btn">保存</a>
		</div>
		
		</#if>
		<!-- 交通规则设置 END -->

		