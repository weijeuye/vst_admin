<!--/国内短线增加名称START-->
<div class="dialog dialog-default lt_dialog addName_dialog addName_dx_dialog INNERSHORTLINE">
    <div class="dialog-inner clearfix">
        <a data-dismiss="dialog" class="dialog-close lt-dialog-close">&times;</a>
        <div class="dialog-header">添加国内短线产品名称</div>
        <div class="dialog-body">
            <div class="dialog-content clearfix">
                <p class="add-name-input">
                    <b>产品名称主标题：</b>
                    <input type="hidden" class="add-main-title"/>
                    <input type="hidden" class="add-sub-title"/>
                    <input type="hidden" class="add-sub-title-4-tnt"/>
                    
                    <em class="lt-not-null">*</em>
                    <input type="text" placeholder="目的地" name="destination" class="input-text lt-w100 add-mdd"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/>填写城市名称、景区名称，以顿号为间隔，*星、纯玩/精品，星级以中文字填写（可不填，达到准四无挂牌可用“精品”二字）；如“三亚天涯海角、大东海纯玩”</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="40"/>
                    <input type="text" placeholder="交通方式" name="traffic" class="input-text lt-w100 add-traffic"
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/>填写产品的交通方式，巴士（不能写“汽车”）、轮船、快艇、慢艇、高铁、动车、火车、飞机  如：双飞；</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="40"/>
                    <em class="lt-not-null">*</em>
                    <select class="day-count" name="dayNumber" >
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                    </select>日
                    <select class="night-count" name="nightNumber">
                        <option value="">-</option>
                        <option value="0">0</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                        <option value="31">31</option>
                    </select>晚
                    <select class="add-playtype" name="playType" >
                    	<option value="">---</option>
                        <option value="WITH_GROUP">跟团</option>
                        <option value="DEPTH">深度</option>
                        <option value="SEMI_SELF">半自助</option>
                    </select>游
                </p>
                <p class="add-name-input">
                    <b>产品名称副标题：</b>
                    <input type="text" placeholder="大型活动" name="largeActivity" class="input-text lt-w100 add-dxhd"  
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写大型活动或专题的产品定义；如519大促、节后抄底。 <br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <input type="text" placeholder="促销信息" name="benefit" class="input-text lt-w100 add-yhhd"
                           data-tip="此输入框为<i class='add-blue'>非必填</i>项 <br/> 输入促销类型的营销词，如：满1000减100； <br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <em class="lt-not-null">*</em>
                    <input type="text" placeholder="产品特色" name="mainFeature"  class="input-text lt-w100 add-tsmd"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/> 输入产品卖点，此款产品最大亮点，如：港龙直飞不转机、米其林餐厅饕餮盛宴等；<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <a class="lt-mr15 name-view-btn" href="javascript:">预览</a>
                </p>
                <div class="addName-help-tips clearfix">
                    <p class="bzts">帮助提示：</p>

                    <p class="bz-content"></p>
                </div>

                <p class="add-name-view">
                    <b>名称预览：</b>
                    <span class="add-name-content"></span>
                </p>
            </div>
        </div>
        <div class="dialog-footer">
            <button class="lt-button lt-mr15 lt-dialog-confirm">确认</button>&nbsp;
            <button class="lt-button lt-mr15 lt-mr15-grey lt-dialog-close">取消</button>
        </div>
    </div>
</div>
<!--/国内短线增加名称END-->

<!--/国内长线增加名称START-->
<div class="dialog dialog-default lt_dialog addName_dialog addName_cx_dialog INNERLONGLINE">
    <div class="dialog-inner clearfix">
        <a data-dismiss="dialog" class="dialog-close lt-dialog-close">&times;</a>
        <div class="dialog-header">添加国内长线产品名称</div>
        <div class="dialog-body">
            <div class="dialog-content clearfix">
                <p class="add-name-input">
                    <b>产品名称主标题：</b>
                    <input type="hidden" class="add-main-title"/>
                    <input type="hidden" class="add-sub-title"/>
                    <input type="hidden" class="add-sub-title-4-tnt"/>
                    
                    <em class="lt-not-null">*</em>
                    <input type="text" placeholder="目的地" name="destination" class="input-text lt-w100 add-mdd"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/>填写城市名称、景区名称，以顿号为间隔，*星、纯玩/精品，星级以中文字填写（可不填，达到准四无挂牌可用“精品”二字）；如“三亚天涯海角、大东海纯玩”</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="40"/>
                    <input type="text" placeholder="交通方式" name="traffic" class="input-text lt-w100 add-traffic"
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/>填写产品的交通方式，巴士（不能写“汽车”）、轮船、快艇、慢艇、高铁、动车、火车、飞机  如：双飞；</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="40"/>
                    <em class="lt-not-null">*</em>
                    <select class="day-count" name="dayNumber" >
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                    </select>日
                    <select class="night-count" name="nightNumber">
                        <option value="">-</option>
                        <option value="0">0</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                        <option value="31">31</option>
                    </select>晚
                    <select class="add-playtype" name="playType" >
                    	<option value="">---</option>
                        <option value="WITH_GROUP">跟团</option>
                        <option value="DEPTH">深度</option>
                        <option value="SEMI_SELF">半自助</option>
                    </select>游
                </p>
                <p class="add-name-input">
                    <b>产品名称副标题：</b>
                    <input type="text" placeholder="大型活动" name="largeActivity" class="input-text lt-w100 add-dxhd"  
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写大型活动或专题的产品定义；如519大促、节后抄底。 <br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <input type="text" placeholder="促销信息" name="benefit" class="input-text lt-w100 add-yhhd"
                           data-tip="此输入框为<i class='add-blue'>非必填</i>项 <br/> 输入促销类型的营销词，如：满1000减100； <br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <em class="lt-not-null">*</em>
                    <input type="text" placeholder="产品特色" name="mainFeature"  class="input-text lt-w100 add-tsmd"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/> 输入产品卖点，此款产品最大亮点，如：港龙直飞不转机、米其林餐厅饕餮盛宴等；<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <a class="lt-mr15 name-view-btn" href="javascript:">预览</a>
                </p>
                <div class="addName-help-tips clearfix">
                    <p class="bzts">帮助提示：</p>

                    <p class="bz-content"></p>
                </div>

                <p class="add-name-view">
                    <b>名称预览：</b>
                    <span class="add-name-content"></span>
                </p>
            </div>
        </div>
        <div class="dialog-footer">
            <button class="lt-button lt-mr15 lt-dialog-confirm">确认</button>&nbsp;
            <button class="lt-button lt-mr15 lt-mr15-grey lt-dialog-close">取消</button>
        </div>
    </div>
</div>
<!--/国内长线增加名称END-->

<!--/国内边境游增加名称START-->
<div class="dialog dialog-default lt_dialog addName_dialog addName_bjy_dialog INNER_BORDER_LINE">
    <div class="dialog-inner clearfix">
        <a data-dismiss="dialog" class="dialog-close lt-dialog-close">&times;</a>
        <div class="dialog-header">添加国内边境游产品名称</div>
        <div class="dialog-body">
            <div class="dialog-content clearfix">
                <p class="add-name-input">
                    <b>产品名称主标题：</b>
                    <input type="hidden" class="add-main-title"/>
                    <input type="hidden" class="add-sub-title"/>
                    <input type="hidden" class="add-sub-title-4-tnt"/>
                    
                    <em class="lt-not-null">*</em>
                    <input type="text" placeholder="目的地" name="destination" class="input-text lt-w100 add-mdd"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/>填写城市名称、景区名称，以顿号为间隔，*星、纯玩/精品，星级以中文字填写（可不填，达到准四无挂牌可用“精品”二字）；如“三亚天涯海角、大东海纯玩”</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="40"/>
                    <em class="lt-not-null">*</em>
                    <select class="day-count" name="dayNumber" >
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                    </select>日
                    <select class="night-count" name="nightNumber">
                        <option value="">-</option>
                        <option value="0">0</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                        <option value="31">31</option>
                    </select>晚
                    <input type="text" placeholder="交通方式" name="traffic" class="input-text lt-w100 add-traffic"
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/>填写产品的交通方式，巴士（不能写“汽车”）、轮船、快艇、慢艇、高铁、动车、火车、飞机  如：双飞；</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="40"/>
                    <select class="add-playtype" name="playType" >
                    	<option value="">---</option>
                        <option value="WITH_GROUP">跟团</option>
                        <option value="DEPTH">深度</option>
                        <option value="SEMI_SELF">半自助</option>
                    </select>游
                </p>
                <p class="add-name-input">
                    <b>产品名称副标题：</b>
                    <input type="text" placeholder="大型活动" name="largeActivity" class="input-text lt-w100 add-dxhd"  
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写大型活动或专题的产品定义；如519大促、节后抄底。 <br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <input type="text" placeholder="促销信息" name="benefit" class="input-text lt-w100 add-yhhd"
                           data-tip="此输入框为<i class='add-blue'>非必填</i>项 <br/> 输入促销类型的营销词，如：满1000减100； <br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <em class="lt-not-null">*</em>
                    <input type="text" placeholder="产品特色" name="mainFeature"  class="input-text lt-w100 add-tsmd"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/> 输入产品卖点，此款产品最大亮点，如：港龙直飞不转机、米其林餐厅饕餮盛宴等；<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <a class="lt-mr15 name-view-btn" href="javascript:">预览</a>
                </p>
                <div class="addName-help-tips clearfix">
                    <p class="bzts">帮助提示：</p>

                    <p class="bz-content"></p>
                </div>

                <p class="add-name-view">
                    <b>名称预览：</b>
                    <span class="add-name-content"></span>
                </p>
            </div>
        </div>
        <div class="dialog-footer">
            <button class="lt-button lt-mr15 lt-dialog-confirm">确认</button>&nbsp;
            <button class="lt-button lt-mr15 lt-mr15-grey lt-dialog-close">取消</button>
        </div>
    </div>
</div>
<!--/国内边境游增加名称END-->

<!--/出境港澳台增加名称START-->
<div class="dialog dialog-default lt_dialog addName_dialog addName_cj_dialog FOREIGNLINE">
    <div class="dialog-inner clearfix">
        <a data-dismiss="dialog" class="dialog-close lt-dialog-close">&times;</a>

        <div class="dialog-header">添加出境港澳台产品名称</div>
        <div class="dialog-body">
            <div class="dialog-content clearfix">
                <p class="add-name-input">
                    <b>产品名称主标题：</b>
                    <em class="lt-not-null">*</em>
                    
                    <input type="hidden" class="add-main-title"/>
                    <input type="hidden" class="add-sub-title"/>
                    <input type="hidden" class="add-sub-title-4-tnt"/>
                    
                    <input type="text" placeholder="目的地" name="destination" class="input-text lt-w100 add-mdd"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/>填写城市名称、景区名称，以顿号为间隔；</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="40"/>
                    <select class="day-count" name="dayNumber" >
                        <option value="">-</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                    </select>日
                    <select class="night-count" name="nightNumber" >
                        <option value="">-</option>
                        <option value="0">0</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                        <option value="31">31</option>
                    </select>晚
                    <em class="lt-not-null">*</em>
                    <select class="add-category" name="playType" >
                    	<option value="">---</option>
                        <option value="DEPTH">深度</option>
                        <option value="SEMI_SELF">半自助</option>
                        <option value="CLASSIC">经典</option>
                        <option value="FULL_VIEW">全景</option>
                        <option value="ONE_DEPTH">一国深度</option>
                        <option value="TWO_ONLINE">二国连线</option>
                        <option value="MANY_ONLINE">多国连线</option>
                        <option value="CJ_SXY">舒享</option>
                        <option value="CJ_JHY">精华</option>
                    </select>游
                </p>
                <p class="add-name-input">
                    <b>产品名称副标题：</b>
                    <input type="text" placeholder="优惠活动" name="benefit" class="input-text lt-w100 add-yhhd"
                           data-tip="此输入框为<i class='add-blue'>非必填</i>项 <br/> 填写产品参与活动，如买一送一，南京银行立减1000 <br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <input type="text" placeholder="主题内容" name="themeContent" class="input-text lt-w100 add-thct placeholder"
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写产品的主题内容，输入产品核心内容比如：浪漫樱花季、亲子欢乐、体验之旅<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <input type="text" placeholder="酒店信息" name="hotel"  class="input-text lt-w100 add-hotel"
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写当前产品酒店简称，如有多个酒店选择用或连接，如希尔顿或万豪或喜来登<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <em class="lt-not-null">*</em>
                    <input type="text" placeholder="特色卖点" name="mainFeature"  class="input-text lt-w100 add-tsmd"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/> 填写产品卖点<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <em class="lt-not-null">*</em>
                    <select class="add-levelStar" name="levelStar" data-tip="此下拉框为<i class='add-red'>必选</i> <br/> 输入产品星级，包含：目的地--行程涵盖的主要目的地写出来（也可体现主要景点名称）<br/>">
                        <option value="0">无星级</option>
                        <option value="1">一星</option>
                        <option value="2">二星</option>
                        <option value="3">三星</option>
                        <option value="4">四星</option>
                        <option value="5">五星</option>
                        <option value="6">六星</option>
                        <option value="7">七星</option>
                        <option value="8">八星</option>
                        
                    </select>
                    <a class="lt-mr15 name-view-btn" href="javascript:">预览</a>
                </p>
                <div class="addName-help-tips clearfix">
                    <p class="bzts">帮助提示：</p>

                    <p class="bz-content"></p>
                </div>

                <p class="add-name-view">
                    <b>名称预览：</b>
                    <span class="add-name-content"></span>
                </p>
            </div>
        </div>
        <div class="dialog-footer">
            <button class="lt-button lt-mr15 lt-dialog-confirm">确认</button>&nbsp;
            <button class="lt-button lt-mr15 lt-mr15-grey lt-dialog-close">取消</button>
        </div>
    </div>
</div>
<!--/出境港澳台增加名称-->

<!--模板START-->
<div class="lt-info-template hide">
    <!-- 产品名称模板START -->
    <p class="lt-product-name-view-main">
        <span class="lt-pnv-content-main"></span>
        <a href="javascript:;" class="lt-pnv-modify">修改</a>
        <a href="javascript:;" class="lt-pnv-delete">删除</a>
    </p>
    <p class="lt-product-name-view-sub">
        <span class="lt-pnv-content-sub"></span>
    </p>
    <!-- 产品名称模板START -->
</div>
<!--模板结束-->