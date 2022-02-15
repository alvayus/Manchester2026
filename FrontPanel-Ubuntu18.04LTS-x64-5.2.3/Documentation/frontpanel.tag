<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
<tagfile>
  <compound kind="file">
    <name>okFrontPanel.dox</name>
    <path>/var/lib/buildbot/frontpanel/Ubuntu-18_04-x86_64-Thinkpad-dist/build/frontpanel-src/FrontPanelDLL/</path>
    <filename>okFrontPanel_8dox</filename>
    <class kind="class">OpalKelly::FrontPanelDevices</class>
    <class kind="class">OpalKelly::FrontPanelManager</class>
    <class kind="struct">OpalKelly::FrontPanelManager::CallbackInfo</class>
    <class kind="class">OpalKelly::ProgressCallback</class>
    <class kind="class">OpalKelly::Buffer</class>
    <class kind="class">OpalKelly::ScriptValue</class>
    <class kind="class">OpalKelly::ScriptValues</class>
    <class kind="class">OpalKelly::ScriptEngine</class>
    <class kind="class">OpalKelly::ScriptEngine::AsyncResultHandler</class>
    <namespace>OpalKelly</namespace>
    <member kind="define">
      <type>#define</type>
      <name>OK_API_VERSION_MAJOR</name>
      <anchorfile>okFrontPanel_8dox.html</anchorfile>
      <anchor>a7f790558df1c43c26e59283e49f7c127</anchor>
      <arglist></arglist>
    </member>
    <member kind="define">
      <type>#define</type>
      <name>OK_API_VERSION_MINOR</name>
      <anchorfile>okFrontPanel_8dox.html</anchorfile>
      <anchor>a73b19a405abf0f83451d3fff44511ad5</anchor>
      <arglist></arglist>
    </member>
    <member kind="define">
      <type>#define</type>
      <name>OK_API_VERSION_MICRO</name>
      <anchorfile>okFrontPanel_8dox.html</anchorfile>
      <anchor>a40fd7fc1ab4cb42f9eea26064b57f353</anchor>
      <arglist></arglist>
    </member>
    <member kind="define">
      <type>#define</type>
      <name>OK_API_VERSION_STRING</name>
      <anchorfile>okFrontPanel_8dox.html</anchorfile>
      <anchor>a30ac1f44970ecc05ebb0609d22c3d7b7</anchor>
      <arglist></arglist>
    </member>
    <member kind="define">
      <type>#define</type>
      <name>OK_CHECK_API_VERSION</name>
      <anchorfile>okFrontPanel_8dox.html</anchorfile>
      <anchor>a14001ecb036ea2a3ac97f13dfd153ea8</anchor>
      <arglist>(major, minor, micro)</arglist>
    </member>
    <member kind="typedef">
      <type>std::auto_ptr&lt; okCFrontPanel &gt;</type>
      <name>FrontPanelPtr</name>
      <anchorfile>namespaceOpalKelly.html</anchorfile>
      <anchor>aed5b6191f81ce1aacfeefddc19df3293</anchor>
      <arglist></arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetAPIVersionMajor</name>
      <anchorfile>namespaceOpalKelly.html</anchorfile>
      <anchor>a27d175286fd14d6fdc1a3e9d8e5c3210</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetAPIVersionMinor</name>
      <anchorfile>namespaceOpalKelly.html</anchorfile>
      <anchor>a714cdfa27993d84c3ed62fe01cb364e0</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetAPIVersionMicro</name>
      <anchorfile>namespaceOpalKelly.html</anchorfile>
      <anchor>a047105264b8ee48c8ab56d39958c6020</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const char *</type>
      <name>GetAPIVersionString</name>
      <anchorfile>namespaceOpalKelly.html</anchorfile>
      <anchor>a705299d3de48569b19af4d58c85d03bf</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>CheckAPIVersion</name>
      <anchorfile>namespaceOpalKelly.html</anchorfile>
      <anchor>a0663480683e198bcba8894dc5e831fc7</anchor>
      <arglist>(int major, int minor, int micro)</arglist>
    </member>
    <member kind="function">
      <type>FrontPanel::ErrorCode</type>
      <name>FrontPanelEmulateTestDeviceConnection</name>
      <anchorfile>namespaceOpalKelly.html</anchorfile>
      <anchor>a5cc2b4dcf3e756ba600ff3dcaf2d0f82</anchor>
      <arglist>(const std::string &amp;serial, bool connect)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>OpalKelly::ScriptEngine::AsyncResultHandler</name>
    <filename>classOpalKelly_1_1ScriptEngine_1_1AsyncResultHandler.html</filename>
    <member kind="function" virtualness="pure">
      <type>virtual void</type>
      <name>OnResult</name>
      <anchorfile>classOpalKelly_1_1ScriptEngine_1_1AsyncResultHandler.html</anchorfile>
      <anchor>a6a6169f9108953e49b1664fb1b71df61</anchor>
      <arglist>(const std::string &amp;error, ScriptValues retvals)=0</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>OpalKelly::Buffer</name>
    <filename>classOpalKelly_1_1Buffer.html</filename>
    <member kind="function">
      <type></type>
      <name>Buffer</name>
      <anchorfile>classOpalKelly_1_1Buffer.html</anchorfile>
      <anchor>ab7153c9099dd26f9f2ba526973076868</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Buffer</name>
      <anchorfile>classOpalKelly_1_1Buffer.html</anchorfile>
      <anchor>ac97ff0cda6df9250fed3656ae685efe0</anchor>
      <arglist>(size_t size)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Buffer</name>
      <anchorfile>classOpalKelly_1_1Buffer.html</anchorfile>
      <anchor>a2671277e019ab8396c3867b6816714d1</anchor>
      <arglist>(void *ptr, size_t size)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Buffer</name>
      <anchorfile>classOpalKelly_1_1Buffer.html</anchorfile>
      <anchor>ad02c79a72057f80374511b5b9b334ac0</anchor>
      <arglist>(const Buffer &amp;buf)</arglist>
    </member>
    <member kind="function">
      <type>Buffer &amp;</type>
      <name>operator=</name>
      <anchorfile>classOpalKelly_1_1Buffer.html</anchorfile>
      <anchor>a1c1c41a8860c5e53b643255255de12b5</anchor>
      <arglist>(const Buffer &amp;buf)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>IsEmpty</name>
      <anchorfile>classOpalKelly_1_1Buffer.html</anchorfile>
      <anchor>a6361d4d719d8cbfca97522f5e3e8d229</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>size_t</type>
      <name>GetSize</name>
      <anchorfile>classOpalKelly_1_1Buffer.html</anchorfile>
      <anchor>a83918f60b5a0c2436a828e03e9f986a2</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>unsigned char *</type>
      <name>GetData</name>
      <anchorfile>classOpalKelly_1_1Buffer.html</anchorfile>
      <anchor>a69a90ddc51de954890677b0e94fa7b56</anchor>
      <arglist>() const</arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>OpalKelly::FrontPanelManager::CallbackInfo</name>
    <filename>structOpalKelly_1_1FrontPanelManager_1_1CallbackInfo.html</filename>
    <member kind="function">
      <type>bool</type>
      <name>IsUsed</name>
      <anchorfile>structOpalKelly_1_1FrontPanelManager_1_1CallbackInfo.html</anchorfile>
      <anchor>a6d3a06e5bdb138557deadf5bb9cde196</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>fd</name>
      <anchorfile>structOpalKelly_1_1FrontPanelManager_1_1CallbackInfo.html</anchorfile>
      <anchor>a393d4bf685f94fa313c425fc43432653</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>void(*</type>
      <name>callback</name>
      <anchorfile>structOpalKelly_1_1FrontPanelManager_1_1CallbackInfo.html</anchorfile>
      <anchor>a07eaadc40189da36de69f023d3e96f20</anchor>
      <arglist>)(void *)</arglist>
    </member>
    <member kind="variable">
      <type>void *</type>
      <name>param</name>
      <anchorfile>structOpalKelly_1_1FrontPanelManager_1_1CallbackInfo.html</anchorfile>
      <anchor>a61371bdb6175650480c39d12d9614f6b</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>OpalKelly::FrontPanelDevices</name>
    <filename>classOpalKelly_1_1FrontPanelDevices.html</filename>
    <member kind="function">
      <type></type>
      <name>FrontPanelDevices</name>
      <anchorfile>classOpalKelly_1_1FrontPanelDevices.html</anchorfile>
      <anchor>acbdf3fbe2919e4c59a3948ef0be55bc7</anchor>
      <arglist>(const std::string &amp;realm=std::string())</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetCount</name>
      <anchorfile>classOpalKelly_1_1FrontPanelDevices.html</anchorfile>
      <anchor>a16e4c8d0e133c4d390822ad9a347eb45</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>GetSerial</name>
      <anchorfile>classOpalKelly_1_1FrontPanelDevices.html</anchorfile>
      <anchor>a28210becd48d22e288a8a9c5668b2f52</anchor>
      <arglist>(int num) const</arglist>
    </member>
    <member kind="function">
      <type>FrontPanelPtr</type>
      <name>Open</name>
      <anchorfile>classOpalKelly_1_1FrontPanelDevices.html</anchorfile>
      <anchor>af2b47b409f71526f099e20556b423964</anchor>
      <arglist>(const std::string &amp;serial=std::string()) const</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~FrontPanelDevices</name>
      <anchorfile>classOpalKelly_1_1FrontPanelDevices.html</anchorfile>
      <anchor>acc0225965378b41ad4cedac92aed8896</anchor>
      <arglist>()</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>OpalKelly::FrontPanelManager</name>
    <filename>classOpalKelly_1_1FrontPanelManager.html</filename>
    <class kind="struct">OpalKelly::FrontPanelManager::CallbackInfo</class>
    <member kind="function">
      <type></type>
      <name>FrontPanelManager</name>
      <anchorfile>classOpalKelly_1_1FrontPanelManager.html</anchorfile>
      <anchor>a19eadc72b8626702d122e02ae9335d35</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~FrontPanelManager</name>
      <anchorfile>classOpalKelly_1_1FrontPanelManager.html</anchorfile>
      <anchor>a26336ef048845eda48b13178cbeff296</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>StartMonitoring</name>
      <anchorfile>classOpalKelly_1_1FrontPanelManager.html</anchorfile>
      <anchor>a8917d7bb05f5d5347820db8cb7541665</anchor>
      <arglist>(CallbackInfo *cbInfo=NULL)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>StopMonitoring</name>
      <anchorfile>classOpalKelly_1_1FrontPanelManager.html</anchorfile>
      <anchor>afe409d476a964681811fddf398f1929b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>EnterMonitorLoop</name>
      <anchorfile>classOpalKelly_1_1FrontPanelManager.html</anchorfile>
      <anchor>ae3341a55222c86aee0e49784051de480</anchor>
      <arglist>(CallbackInfo &amp;callbackInfo, int millisecondsTimeout=0)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>ExitMonitorLoop</name>
      <anchorfile>classOpalKelly_1_1FrontPanelManager.html</anchorfile>
      <anchor>af77e35407d1188268d86679ba7966b0b</anchor>
      <arglist>(int exitCode=0)</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual void</type>
      <name>OnDeviceAdded</name>
      <anchorfile>classOpalKelly_1_1FrontPanelManager.html</anchorfile>
      <anchor>aaa59e7e316235816241c44ddf722ddc7</anchor>
      <arglist>(const char *serial)=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual void</type>
      <name>OnDeviceRemoved</name>
      <anchorfile>classOpalKelly_1_1FrontPanelManager.html</anchorfile>
      <anchor>ab797fe31c006278e98438f2453e96e0e</anchor>
      <arglist>(const char *serial)=0</arglist>
    </member>
    <member kind="function">
      <type>okCFrontPanel *</type>
      <name>Open</name>
      <anchorfile>classOpalKelly_1_1FrontPanelManager.html</anchorfile>
      <anchor>a540c23ce4ddec57548a287302cc2840a</anchor>
      <arglist>(const char *serial)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>okCDeviceSensors</name>
    <filename>classokCDeviceSensors.html</filename>
    <member kind="function">
      <type>int</type>
      <name>GetSensorCount</name>
      <anchorfile>classokCDeviceSensors.html</anchorfile>
      <anchor>a1484b7f932614ae922a5c1f3cc63e21d</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>okTDeviceSensor</type>
      <name>GetSensor</name>
      <anchorfile>classokCDeviceSensors.html</anchorfile>
      <anchor>a877904fa7c09eba509e629ebec5aa0f3</anchor>
      <arglist>(int index) const</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>okCDeviceSettings</name>
    <filename>classokCDeviceSettings.html</filename>
    <member kind="function">
      <type></type>
      <name>okCDeviceSettings</name>
      <anchorfile>classokCDeviceSettings.html</anchorfile>
      <anchor>af45f921dd03739a361bd096c48a6fd31</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>GetString</name>
      <anchorfile>classokCDeviceSettings.html</anchorfile>
      <anchor>a5d7ea7d2f6e23ef1e071d3b18a57da52</anchor>
      <arglist>(const std::string &amp;key, std::string *value)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>GetInt</name>
      <anchorfile>classokCDeviceSettings.html</anchorfile>
      <anchor>a580da1226fceebc7d50ec9f3bc776f93</anchor>
      <arglist>(const std::string &amp;key, UINT32 *value)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>SetString</name>
      <anchorfile>classokCDeviceSettings.html</anchorfile>
      <anchor>af8052e48ba506786e9f128fa868c3ae6</anchor>
      <arglist>(const std::string &amp;key, const std::string &amp;value)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>SetInt</name>
      <anchorfile>classokCDeviceSettings.html</anchorfile>
      <anchor>a3b7c755af5df551d664e83baee258ebf</anchor>
      <arglist>(const std::string &amp;key, UINT32 value)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>List</name>
      <anchorfile>classokCDeviceSettings.html</anchorfile>
      <anchor>a60f693f99cb2fd7397287726b4de0ec4</anchor>
      <arglist>(std::vector&lt; std::string &gt; &amp;keys)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>Delete</name>
      <anchorfile>classokCDeviceSettings.html</anchorfile>
      <anchor>aa5595287918c06b81841179be9db25a6</anchor>
      <arglist>(const std::string &amp;key)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>Save</name>
      <anchorfile>classokCDeviceSettings.html</anchorfile>
      <anchor>ab14ee03ca8c97b5ff476060129b5c423</anchor>
      <arglist>()</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>okCFrontPanel</name>
    <filename>classokCFrontPanel.html</filename>
    <member kind="function">
      <type></type>
      <name>okCFrontPanel</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>acf79b986d6f38115bbe078cddd150eb0</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~okCFrontPanel</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a98380d232cc085b18e01dea892c1851e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const char *</type>
      <name>GetLastErrorMessage</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a4e1e1ab63352465fb9b7a61502850053</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>ActivateTriggerIn</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a5d6ecf0224545b1160ca15de62795d27</anchor>
      <arglist>(int epAddr, int bit)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>Close</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>aee80bc2c65ef4e3d62f230892ad4c9b3</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>ConfigureFPGA</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a8ba687692ea69eb5d033136b91586d14</anchor>
      <arglist>(const std::string strFilename, void(*callback)(int, int, void *)=NULL, void *arg=NULL)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>ConfigureFPGAWithReset</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>aeaa6482e470a0e61afacc5bcc9169a0f</anchor>
      <arglist>(const std::string strFilename, const okTFPGAResetProfile *reset, void(*callback)(int, int, void *)=NULL, void *arg=NULL)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>ConfigureFPGAFromMemory</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a464b5f9ea9daaf58d6d8a6212d515283</anchor>
      <arglist>(const unsigned char *data, unsigned long length, void(*callback)(int, int, void *)=NULL, void *arg=NULL)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>ConfigureFPGAFromMemoryWithReset</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a6a6f32441c518c6f9147e4ca27fdf9f3</anchor>
      <arglist>(const unsigned char *data, unsigned long length, const okTFPGAResetProfile *reset, void(*callback)(int, int, void *)=NULL, void *arg=NULL)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>ConfigureFPGAFromFlash</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>af508321b71c6bc26786654d93347ba8e</anchor>
      <arglist>(const unsigned long configIndex, void(*callback)(int, int, void *), void *arg)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>EnableAsynchronousTransfers</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>ae3cc28114a2e2752fd0b830f91db377d</anchor>
      <arglist>(bool enable)</arglist>
    </member>
    <member kind="function">
      <type>BoardModel</type>
      <name>GetBoardModel</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>aa7dff4a98b875d5db5091d13bdf180ac</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetDeviceCount</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a5681ceff00c78a5443406e32eac6520f</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>GetDeviceID</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>aa5f74ef9d5511ba7d6bbd489f5392187</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>GetDeviceInfo</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a4650e9d343d3b80dd89ce658adaf8ab4</anchor>
      <arglist>(okTDeviceInfo *info)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>GetFPGAResetProfile</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a69bbce82343535cb215d2d3bf460e7cd</anchor>
      <arglist>(okEFPGAConfigurationMethod method, okTFPGAResetProfile *profile)</arglist>
    </member>
    <member kind="function">
      <type>BoardModel</type>
      <name>GetDeviceListModel</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>aae55e05110944ceb745a145bc880f2c7</anchor>
      <arglist>(int num)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>GetDeviceListSerial</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a1f0c683a359b80d9a80d0c0ec9f8156d</anchor>
      <arglist>(int num)</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetDeviceMajorVersion</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a47245b7de2f7efa8a96eeb97cec52ac7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetDeviceMinorVersion</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>ac967a1245deea121bc6b9b741847e69e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>GetDeviceSensors</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>ae4232c22d5d9a867d6bf67fce2797406</anchor>
      <arglist>(okCDeviceSensors &amp;sensors) const</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>GetDeviceSettings</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a0ca33a2019f4904e0fba55cc45fafb1a</anchor>
      <arglist>(okCDeviceSettings &amp;settings)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>GetEepromPLL22150Configuration</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a5f9da76fb2f276145b575b23d573db92</anchor>
      <arglist>(okCPLL22150 &amp;pll)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>GetEepromPLL22393Configuration</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a7a650425713e28b66ddf83ef2c0863be</anchor>
      <arglist>(okCPLL22393 &amp;pll)</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetHostInterfaceWidth</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a5d6673451bec6cefb859bd0928c05c09</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>long</type>
      <name>GetLastTransferLength</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>aa5a4983d322c98ea4530b2458a02b27f</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>GetPLL22150Configuration</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a4b4ad78c98fb590695e54f8b68187df0</anchor>
      <arglist>(okCPLL22150 &amp;pll)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>GetPLL22393Configuration</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a04fc1588d583e5fbc2794a83a3a29041</anchor>
      <arglist>(okCPLL22393 &amp;pll)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>GetSerialNumber</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>ae74063ad7ac8778530fd3f80b8ca7147</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>GetWireInValue</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>ace377ac73c390322fd0832b774654920</anchor>
      <arglist>(int epAddr, UINT32 *val)</arglist>
    </member>
    <member kind="function">
      <type>UINT32</type>
      <name>GetWireOutValue</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a179f9ffba19235bdd314dd9b2efd3054</anchor>
      <arglist>(int epAddr)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>IsHighSpeed</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a6bcb4c45efe892223dbea741fed4bf46</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>IsFrontPanel3Supported</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>addfbe376b067628c91dee2484ef0e7c4</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>IsFrontPanelEnabled</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a77faa8e8520e82e847a85a5d320b94b5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>IsOpen</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a01d90a0ac728cf88b9637ab2b78546b5</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>IsRemote</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a88817d333832242aa0d74c98ffe4c425</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>IsTriggered</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>aaee61a8fb308b6a76c859d19dfd009c8</anchor>
      <arglist>(int epAddr, UINT32 mask)</arglist>
    </member>
    <member kind="function">
      <type>UINT32</type>
      <name>GetTriggerOutVector</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a8d4774a728645afb117ff5f5cb87786d</anchor>
      <arglist>(int epAddr) const</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>LoadDefaultPLLConfiguration</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a206a26859fd2db3646dc748c815beeac</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>OpenBySerial</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a8df2e32a316faa146a0047213bb77e6c</anchor>
      <arglist>(std::string str=&quot;&quot;)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>ReadI2C</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a3b624f3bd41f874867f2becfdf776018</anchor>
      <arglist>(const int addr, int length, unsigned char *data)</arglist>
    </member>
    <member kind="function">
      <type>long</type>
      <name>ReadFromBlockPipeOut</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a4accb11a5bfa48798e263aa2c4d9e977</anchor>
      <arglist>(int epAddr, int blockSize, long length, unsigned char *data)</arglist>
    </member>
    <member kind="function">
      <type>long</type>
      <name>ReadFromPipeOut</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a78d9da7ddea0a75c9ce408a64b14e51a</anchor>
      <arglist>(int epAddr, long length, unsigned char *data)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>ReadRegister</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a230a2848017f7e86abe56a3144d3db0c</anchor>
      <arglist>(UINT32 addr, UINT32 *data)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>ReadRegisters</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a5969507a9b4333844d7a9c65ba871188</anchor>
      <arglist>(okTRegisterEntries &amp;regs)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>ResetFPGA</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>ad5494fe1f285b92b53317c1846e496f0</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>SetBTPipePollingInterval</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>ab5441f0e58ebcee9b14d6a6e935207f1</anchor>
      <arglist>(int interval)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>SetFPGAResetProfile</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>af458e6d190a371b1bf4f79e4e941a0d2</anchor>
      <arglist>(okEFPGAConfigurationMethod method, const okTFPGAResetProfile *profile)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetDeviceID</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>af5982edf22087334218e5f7f855be61e</anchor>
      <arglist>(const std::string str)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>SetPLL22150Configuration</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a2505713115f8cdbc7e23ea3b9d2b8701</anchor>
      <arglist>(const okCPLL22150 &amp;pll)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>SetPLL22393Configuration</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a547277109d6989e465cb8f64ccb83044</anchor>
      <arglist>(const okCPLL22393 &amp;pll)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>SetEepromPLL22150Configuration</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>aabd0c3796ff94851fdb468c702fcb499</anchor>
      <arglist>(const okCPLL22150 &amp;pll)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>SetEepromPLL22393Configuration</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>acd5ba02f78aaf9da0f781fe9b34cfd90</anchor>
      <arglist>(const okCPLL22393 &amp;pll)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetTimeout</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a8bb9f63c7cfe315781f52d289ca6c2bf</anchor>
      <arglist>(int timeout)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>SetWireInValue</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a74f8b4b37ccc57dd72b5b739bbc45766</anchor>
      <arglist>(int ep, UINT32 val, UINT32 mask=0xffffffff)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>UpdateTriggerOuts</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a0f7a732026288b052c86ad656c5fc955</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>UpdateWireIns</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a50a5ae9f0bcd08b5ebc7f75612c256f5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>UpdateWireOuts</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>afb4f41ee15d213d76dddc8b589b527b0</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>FlashEraseSector</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>abccdbdaf2cf6ba837a4c503ff9cce177</anchor>
      <arglist>(UINT32 address)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>FlashWrite</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>ae17fe4fffbfaa4891dd16dc9b672ed7e</anchor>
      <arglist>(UINT32 address, UINT32 length, const UINT8 *buf)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>FlashRead</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a43d0486ed605536d99487c98556cf36a</anchor>
      <arglist>(UINT32 address, UINT32 length, UINT8 *buf)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>WriteI2C</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a20b8caa652f5ace0343c6784de8478db</anchor>
      <arglist>(const int addr, int length, const unsigned char *data)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>WriteRegister</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a7f4c4215b9515401faae6eb2afa5bdee</anchor>
      <arglist>(UINT32 addr, UINT32 data)</arglist>
    </member>
    <member kind="function">
      <type>ErrorCode</type>
      <name>WriteRegisters</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>aadb3118557415653bce3bfdc435ccdf3</anchor>
      <arglist>(const okTRegisterEntries &amp;regs)</arglist>
    </member>
    <member kind="function">
      <type>long</type>
      <name>WriteToBlockPipeIn</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a1046c9a36a5442329ae20e278e2a92f5</anchor>
      <arglist>(int epAddr, int blockSize, long length, const unsigned char *data)</arglist>
    </member>
    <member kind="function">
      <type>long</type>
      <name>WriteToPipeIn</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>ab5a48ebe66a14414455d6b5de7f593cf</anchor>
      <arglist>(int epAddr, long length, const unsigned char *data)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static ErrorCode</type>
      <name>AddCustomDevice</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a6b4ed79e84fad3c7b4a34b5e22398439</anchor>
      <arglist>(const okTDeviceMatchInfo &amp;matchInfo, const okTDeviceInfo *devInfo=NULL)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static ErrorCode</type>
      <name>RemoveCustomDevice</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>aa99f02073f52d7c5e5e73a39130da434</anchor>
      <arglist>(int productID)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static BoardModel</type>
      <name>FindUSBDeviceModel</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>aaf5b584ffa5b76959ef1f9c7b5831f94</anchor>
      <arglist>(unsigned usbVID, unsigned usbPID)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static std::string</type>
      <name>GetBoardModelString</name>
      <anchorfile>classokCFrontPanel.html</anchorfile>
      <anchor>a024636cf6f182381d51e01ad8cdda971</anchor>
      <arglist>(BoardModel m)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>okCPLL22150</name>
    <filename>classokCPLL22150.html</filename>
    <member kind="function">
      <type></type>
      <name>okCPLL22150</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>ad2c77e4688d138d3e3d7de7f714e1c18</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetDiv1Divider</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>a77f4f05bf114d753efdd585f372ea303</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetDiv2Divider</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>a4c49b31488d6d383c5d68d766ec45fbb</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>DividerSource</type>
      <name>GetDiv1Source</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>ab0e06725b351e43b472341893433b2ff</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>DividerSource</type>
      <name>GetDiv2Source</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>abe89ef2ea4b1ed466c4c7a36402bc245</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>double</type>
      <name>GetOutputFrequency</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>aad426c8f706214add84cf6e8518a13c3</anchor>
      <arglist>(int output)</arglist>
    </member>
    <member kind="function">
      <type>ClockSource</type>
      <name>GetOutputSource</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>a4d9c60f12dc3b5139d57236ec3337a95</anchor>
      <arglist>(int output)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>GetProgrammingInfo</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>a59ecdeea4147a416a977bb79b783ec4a</anchor>
      <arglist>(unsigned char *buf) const</arglist>
    </member>
    <member kind="function">
      <type>double</type>
      <name>GetReference</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>a385eb7e053eed325885f7440a635373f</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>double</type>
      <name>GetVCOFrequency</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>abf8f61d0dcf78b5ce698c3fa6c76840a</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetVCOP</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>a78d2701769214fcacc13133fcd74906e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetVCOQ</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>aaca7e664ef01388d16d4902a3c5777f7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>InitFromProgrammingInfo</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>a5b84308cb4afa58b5d31a02c5d388664</anchor>
      <arglist>(unsigned char *buf)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>IsOutputEnabled</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>aaeac088fa47eb76625d9a9cd38b2b60e</anchor>
      <arglist>(int output)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetCrystalLoad</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>a3f8cb112e808a409b2eca8dda9e4c330</anchor>
      <arglist>(double capload)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetReference</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>a1e5214bb0ecc8701b12384b33178b665</anchor>
      <arglist>(double freq, bool extosc)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetDiv1</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>a9eead524e2f3c868b6a3814ae659787d</anchor>
      <arglist>(DividerSource divsrc, int n)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetDiv2</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>a483673f7359556d1939cc603cf57f2f7</anchor>
      <arglist>(DividerSource divsrc, int n)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetOutputSource</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>a1d395e88cf8aaeaf1a3e381f58168447</anchor>
      <arglist>(int output, ClockSource clksrc)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetOutputEnable</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>af8c7758118570d073521910f23f86765</anchor>
      <arglist>(int output, bool enable)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>SetVCOParameters</name>
      <anchorfile>classokCPLL22150.html</anchorfile>
      <anchor>aa924dd6d71bfc40e8a97a81c4f219d33</anchor>
      <arglist>(int p, int q)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>okCPLL22393</name>
    <filename>classokCPLL22393.html</filename>
    <member kind="function">
      <type></type>
      <name>okCPLL22393</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>a52ba9bed6fe4b6e840a2be293137e623</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetOutputDivider</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>aa3c83db8637b48639489235bf3ffd450</anchor>
      <arglist>(int n)</arglist>
    </member>
    <member kind="function">
      <type>double</type>
      <name>GetOutputFrequency</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>a10d7223004a5bec4106afca099510336</anchor>
      <arglist>(int n)</arglist>
    </member>
    <member kind="function">
      <type>ClockSource</type>
      <name>GetOutputSource</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>a5ec3473562799ce2dc757cc6c8b1fcc5</anchor>
      <arglist>(int n)</arglist>
    </member>
    <member kind="function">
      <type>double</type>
      <name>GetPLLFrequency</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>a021c7f842ce6c7db6cb8234acaf65a31</anchor>
      <arglist>(int n)</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetPLLP</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>a7f7d896357aebae66918abf7b1046f9d</anchor>
      <arglist>(int n)</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetPLLQ</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>aa155fc9223d1cb0d567f8e9c8e1a4b23</anchor>
      <arglist>(int n)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>GetProgrammingInfo</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>a77a7bbb33a44f438100a5178fe590a8d</anchor>
      <arglist>(unsigned char *buf) const</arglist>
    </member>
    <member kind="function">
      <type>double</type>
      <name>GetReference</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>a22c64668ff8d0eb9a1ed3e54887b19cd</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>InitFromProgrammingInfo</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>a2d8b35ffa40d7ee3bcfd3021d19980c6</anchor>
      <arglist>(unsigned char *buf)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>IsPLLEnabled</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>a3e180ff0786ab751559b5fda6db48cea</anchor>
      <arglist>(int n)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>IsOutputEnabled</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>a0e11f510307a8995ffea91081d2228e3</anchor>
      <arglist>(int n)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>SetCrystalLoad</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>a5fae87353175dfc9cc2961cfccc57956</anchor>
      <arglist>(double capload)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetOutputEnable</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>ac4f5cd0689362fe194f7f075e50d4ec9</anchor>
      <arglist>(int n, bool enable)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>SetOutputDivider</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>af1acdc6c588fb65e193e775ec1936957</anchor>
      <arglist>(int n, int div)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>SetOutputSource</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>a2ecbce843128c650a14be48890970b84</anchor>
      <arglist>(int n, ClockSource clksrc)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>SetPLLParameters</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>a047becceb94ad658a14f6858106eb6ac</anchor>
      <arglist>(int n, int p, int q, bool enable=true)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>SetPLLLF</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>a64170b308ef8252367fbb5907a445b8e</anchor>
      <arglist>(int n, int lf)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetReference</name>
      <anchorfile>classokCPLL22393.html</anchorfile>
      <anchor>af7fb3d9296343bf66e8144928cacb2c5</anchor>
      <arglist>(double freq)</arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>okTDeviceInfo</name>
    <filename>structokTDeviceInfo.html</filename>
    <member kind="variable">
      <type>char</type>
      <name>deviceID</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a1b3f1bdaa9322a8ec311c1bbc8e5352b</anchor>
      <arglist>[OK_MAX_DEVICEID_LENGTH]</arglist>
    </member>
    <member kind="variable">
      <type>char</type>
      <name>serialNumber</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a132318715d3b79b4160b8baaf34fe1ed</anchor>
      <arglist>[OK_MAX_SERIALNUMBER_LENGTH]</arglist>
    </member>
    <member kind="variable">
      <type>char</type>
      <name>productName</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a706fbcc56c0f1e44a8430c4a7cbb2b3b</anchor>
      <arglist>[OK_MAX_PRODUCT_NAME_LENGTH]</arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>productID</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a8499afc882f767f8643e6528b2b002e8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>okEDeviceInterface</type>
      <name>deviceInterface</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a5a6baf2468ca8a14756d6e62a1924ec4</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>okEUSBSpeed</type>
      <name>usbSpeed</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a52f9c59da220bac35759ffa50dbf3b86</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>deviceMajorVersion</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a9546abf1068f50365ed4b1eaf576076e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>deviceMinorVersion</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a883246a3638a5c1c1a2a803c80c1e984</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>hostInterfaceMajorVersion</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a652c084aaa75c86c3520841c87c71e69</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>hostInterfaceMinorVersion</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a9e20b88557778c28d72d88f6a4fe009b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>bool</type>
      <name>isPLL22150Supported</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>ae24837c3430622cd30772df84254eef4</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>bool</type>
      <name>isPLL22393Supported</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>acd25670cac6e273718b05194ca2cfd82</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>bool</type>
      <name>isFrontPanelEnabled</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a71b61faafd7a3bdab0d1482c96b2feeb</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>wireWidth</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>ac92c9e7aa44a859436fcc7e4340e2f27</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>triggerWidth</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a4d1646fe284c6c228c1d9433f1cbf039</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>pipeWidth</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a0630e370edbfaf21bd69b779c19bdd16</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>registerAddressWidth</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a2dd1f52fe3100d219bfbe266f94a660e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>registerDataWidth</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a4471eb31e68e409cff22160dd192f487</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>okTFlashLayout</type>
      <name>flashSystem</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a7f574b55f7e081c86702986fca8c618c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>okTFlashLayout</type>
      <name>flashFPGA</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>aae9867cdaf76a9d3d90f5cad99d940d2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>bool</type>
      <name>hasFMCEEPROM</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a3dc6ffb513ad622b726266a60aa9fa89</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>bool</type>
      <name>hasResetProfiles</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a11225808b92ea8422fc79f0810f14679</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>okEFPGAVendor</type>
      <name>fpgaVendor</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a8fd546411bd6e67d9dd32793e69a8a80</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>interfaceCount</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a3f90f361894d9e5cd5956e66732dca20</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>interfaceIndex</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>a6a99e43fbb4d32d099790ac37649732d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>bool</type>
      <name>configuresFromSystemFlash</name>
      <anchorfile>structokTDeviceInfo.html</anchorfile>
      <anchor>aa244da15d5bd7a4bfb603a6cec298acc</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>okTDeviceSensor</name>
    <filename>structokTDeviceSensor.html</filename>
    <member kind="variable">
      <type>okEDeviceSensorType</type>
      <name>type</name>
      <anchorfile>structokTDeviceSensor.html</anchorfile>
      <anchor>aa5ddd4a964a939282abf2bf54a3e41c2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>char</type>
      <name>name</name>
      <anchorfile>structokTDeviceSensor.html</anchorfile>
      <anchor>aa2bcf2604aa79ff8107e35270eed0ba8</anchor>
      <arglist>[OK_MAX_DEVICE_SENSOR_NAME_LENGTH]</arglist>
    </member>
    <member kind="variable">
      <type>char</type>
      <name>description</name>
      <anchorfile>structokTDeviceSensor.html</anchorfile>
      <anchor>a4fb2875f8d44836a12f0545da987c7e5</anchor>
      <arglist>[OK_MAX_DEVICE_SENSOR_DESCRIPTION_LENGTH]</arglist>
    </member>
    <member kind="variable">
      <type>double</type>
      <name>min</name>
      <anchorfile>structokTDeviceSensor.html</anchorfile>
      <anchor>a414f04f4373ce6172eb9fcfff03521b1</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>double</type>
      <name>max</name>
      <anchorfile>structokTDeviceSensor.html</anchorfile>
      <anchor>a84e0f1f01cf7fafbf6377686f83b1f52</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>double</type>
      <name>step</name>
      <anchorfile>structokTDeviceSensor.html</anchorfile>
      <anchor>a46690185b8236e08a0b1d3142d345527</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>double</type>
      <name>value</name>
      <anchorfile>structokTDeviceSensor.html</anchorfile>
      <anchor>abf4c5137ac42c8705f1fce3ffc885cc2</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>okTFlashLayout</name>
    <filename>structokTFlashLayout.html</filename>
    <member kind="variable">
      <type>UINT32</type>
      <name>sectorCount</name>
      <anchorfile>structokTFlashLayout.html</anchorfile>
      <anchor>aef5d0020c89fe47453cf8e4bb2603447</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>UINT32</type>
      <name>sectorSize</name>
      <anchorfile>structokTFlashLayout.html</anchorfile>
      <anchor>a214e66757b4eb2ef9b2662313503c316</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>UINT32</type>
      <name>pageSize</name>
      <anchorfile>structokTFlashLayout.html</anchorfile>
      <anchor>acf61c0caba4ae5c412af414fd419c20b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>UINT32</type>
      <name>minUserSector</name>
      <anchorfile>structokTFlashLayout.html</anchorfile>
      <anchor>ac1e2bd1d00ff9fd9cd05b70a49069160</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>UINT32</type>
      <name>maxUserSector</name>
      <anchorfile>structokTFlashLayout.html</anchorfile>
      <anchor>a9ed67119cd3658cbabfc301837a420a3</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>okTFPGAResetProfile</name>
    <filename>structokTFPGAResetProfile.html</filename>
    <member kind="variable">
      <type>UINT32</type>
      <name>magic</name>
      <anchorfile>structokTFPGAResetProfile.html</anchorfile>
      <anchor>a5424ad66ad734249bf2d9448da77b1e0</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>UINT32</type>
      <name>configFileLocation</name>
      <anchorfile>structokTFPGAResetProfile.html</anchorfile>
      <anchor>af820d81f446e62e4cc548d0dd4925ebf</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>UINT32</type>
      <name>configFileLength</name>
      <anchorfile>structokTFPGAResetProfile.html</anchorfile>
      <anchor>abbca724159a519290ed930a4c900382e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>UINT32</type>
      <name>doneWaitUS</name>
      <anchorfile>structokTFPGAResetProfile.html</anchorfile>
      <anchor>a5a3dfd86f77e324d066371df4dc07a6e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>UINT32</type>
      <name>resetWaitUS</name>
      <anchorfile>structokTFPGAResetProfile.html</anchorfile>
      <anchor>ac62876565a1b5f32a9018ba4a8101ef2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>UINT32</type>
      <name>registerWaitUS</name>
      <anchorfile>structokTFPGAResetProfile.html</anchorfile>
      <anchor>afc3073040946067b770baa8c3acc25dc</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>UINT32</type>
      <name>padBytes1</name>
      <anchorfile>structokTFPGAResetProfile.html</anchorfile>
      <anchor>a15b049061c638be47e3c754a0468ea0e</anchor>
      <arglist>[28]</arglist>
    </member>
    <member kind="variable">
      <type>UINT32</type>
      <name>wireInValues</name>
      <anchorfile>structokTFPGAResetProfile.html</anchorfile>
      <anchor>a054384dfb5e73708f02e1bd608a40f50</anchor>
      <arglist>[32]</arglist>
    </member>
    <member kind="variable">
      <type>UINT32</type>
      <name>registerEntryCount</name>
      <anchorfile>structokTFPGAResetProfile.html</anchorfile>
      <anchor>ac417250b94875f905aff72b50abd98dc</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>okTRegisterEntry</type>
      <name>registerEntries</name>
      <anchorfile>structokTFPGAResetProfile.html</anchorfile>
      <anchor>a60d29b2a19accd1ee65b9efda5918fee</anchor>
      <arglist>[256]</arglist>
    </member>
    <member kind="variable">
      <type>UINT32</type>
      <name>triggerEntryCount</name>
      <anchorfile>structokTFPGAResetProfile.html</anchorfile>
      <anchor>af978c243182da9d44a112295ef1245c9</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>okTTriggerEntry</type>
      <name>triggerEntries</name>
      <anchorfile>structokTFPGAResetProfile.html</anchorfile>
      <anchor>a03f5e353c4da15a5f2368552687756d7</anchor>
      <arglist>[32]</arglist>
    </member>
    <member kind="variable">
      <type>UINT8</type>
      <name>padBytes2</name>
      <anchorfile>structokTFPGAResetProfile.html</anchorfile>
      <anchor>aea40bb955586affa4179e618acdd7cee</anchor>
      <arglist>[1520]</arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>okTRegisterEntry</name>
    <filename>structokTRegisterEntry.html</filename>
    <member kind="variable">
      <type>UINT32</type>
      <name>address</name>
      <anchorfile>structokTRegisterEntry.html</anchorfile>
      <anchor>a3eaf9be8d61771d52ae8775c56e54991</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>UINT32</type>
      <name>data</name>
      <anchorfile>structokTRegisterEntry.html</anchorfile>
      <anchor>ad6a3e039fa247cb38051b482c85e1ec0</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>okTTriggerEntry</name>
    <filename>structokTTriggerEntry.html</filename>
    <member kind="variable">
      <type>UINT32</type>
      <name>address</name>
      <anchorfile>structokTTriggerEntry.html</anchorfile>
      <anchor>ac6b4319021b2d5560aa17cc76e6dabac</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>UINT32</type>
      <name>mask</name>
      <anchorfile>structokTTriggerEntry.html</anchorfile>
      <anchor>a9dace8dfc94bb9abd1035a5d6ef04204</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>OpalKelly::ProgressCallback</name>
    <filename>classOpalKelly_1_1ProgressCallback.html</filename>
    <member kind="function">
      <type></type>
      <name>ProgressCallback</name>
      <anchorfile>classOpalKelly_1_1ProgressCallback.html</anchorfile>
      <anchor>a7a75e05e0ccf7d48f280cb865bcecfde</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~ProgressCallback</name>
      <anchorfile>classOpalKelly_1_1ProgressCallback.html</anchorfile>
      <anchor>a590c7d93662812331c02340490cb8cee</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual void</type>
      <name>OnProgress</name>
      <anchorfile>classOpalKelly_1_1ProgressCallback.html</anchorfile>
      <anchor>a8cc63104e89d7b228dbe736692abcbf7</anchor>
      <arglist>(int maximum, int current)=0</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>OpalKelly::ScriptEngine</name>
    <filename>classOpalKelly_1_1ScriptEngine.html</filename>
    <class kind="class">OpalKelly::ScriptEngine::AsyncResultHandler</class>
    <member kind="function">
      <type></type>
      <name>ScriptEngine</name>
      <anchorfile>classOpalKelly_1_1ScriptEngine.html</anchorfile>
      <anchor>a7e0a1ba3a589e037d2e7f06f6d8b4973</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>ConstructLua</name>
      <anchorfile>classOpalKelly_1_1ScriptEngine.html</anchorfile>
      <anchor>a0262570c74792d3e865b2be4cd196a39</anchor>
      <arglist>(okCFrontPanel &amp;fp)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>IsValid</name>
      <anchorfile>classOpalKelly_1_1ScriptEngine.html</anchorfile>
      <anchor>a760879c52b7cad47cb9ac04401a55c45</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>LoadScript</name>
      <anchorfile>classOpalKelly_1_1ScriptEngine.html</anchorfile>
      <anchor>a3ce86d3891ec760905a13a41af83fccf</anchor>
      <arglist>(const std::string &amp;name, const std::string &amp;code)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>LoadFile</name>
      <anchorfile>classOpalKelly_1_1ScriptEngine.html</anchorfile>
      <anchor>ae85fc444f788708a30265509873b184c</anchor>
      <arglist>(const std::string &amp;path)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>PrependToScriptPath</name>
      <anchorfile>classOpalKelly_1_1ScriptEngine.html</anchorfile>
      <anchor>af3439e87c865229f84777b820ce0ea77</anchor>
      <arglist>(const std::string &amp;dir)</arglist>
    </member>
    <member kind="function">
      <type>ScriptValues</type>
      <name>RunScriptFunction</name>
      <anchorfile>classOpalKelly_1_1ScriptEngine.html</anchorfile>
      <anchor>a69cdcfd79c63ed511f799b858629fb44</anchor>
      <arglist>(const std::string &amp;name, const ScriptValues &amp;args=ScriptValues())</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>RunScriptFunctionAsync</name>
      <anchorfile>classOpalKelly_1_1ScriptEngine.html</anchorfile>
      <anchor>a25c43624f233b72eb71bd8305967d2c3</anchor>
      <arglist>(AsyncResultHandler &amp;handler, const std::string &amp;name, const ScriptValues &amp;args=ScriptValues())</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>OpalKelly::ScriptValue</name>
    <filename>classOpalKelly_1_1ScriptValue.html</filename>
    <member kind="function">
      <type></type>
      <name>ScriptValue</name>
      <anchorfile>classOpalKelly_1_1ScriptValue.html</anchorfile>
      <anchor>abe76af7ce4f054a1a87c362a232746b8</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>ScriptValue</name>
      <anchorfile>classOpalKelly_1_1ScriptValue.html</anchorfile>
      <anchor>add1467e73e077cc9bd8ba65f25876ed4</anchor>
      <arglist>(int n)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>ScriptValue</name>
      <anchorfile>classOpalKelly_1_1ScriptValue.html</anchorfile>
      <anchor>a657d3a29e74eded7fed9dd78e525157e</anchor>
      <arglist>(bool b)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>ScriptValue</name>
      <anchorfile>classOpalKelly_1_1ScriptValue.html</anchorfile>
      <anchor>a4f052bcadc2ac37ac5bb68950d15f01e</anchor>
      <arglist>(const std::string &amp;s)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>ScriptValue</name>
      <anchorfile>classOpalKelly_1_1ScriptValue.html</anchorfile>
      <anchor>a829d720a2b113116e35dbfe2945120c6</anchor>
      <arglist>(Buffer buf)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>ScriptValue</name>
      <anchorfile>classOpalKelly_1_1ScriptValue.html</anchorfile>
      <anchor>a6b9c723c0261f2352a76172ccd376797</anchor>
      <arglist>(const ScriptValue &amp;value)</arglist>
    </member>
    <member kind="function">
      <type>ScriptValue &amp;</type>
      <name>operator=</name>
      <anchorfile>classOpalKelly_1_1ScriptValue.html</anchorfile>
      <anchor>a671b6e4fbf546b24b0aee507860583bd</anchor>
      <arglist>(const ScriptValue &amp;value)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>GetAsInt</name>
      <anchorfile>classOpalKelly_1_1ScriptValue.html</anchorfile>
      <anchor>a831db8e7adf034e18ffa34407341d541</anchor>
      <arglist>(int *pn) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>GetAsBool</name>
      <anchorfile>classOpalKelly_1_1ScriptValue.html</anchorfile>
      <anchor>a80c818850f20b741947c9ae09d98b8d6</anchor>
      <arglist>(bool *pb) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>GetAsString</name>
      <anchorfile>classOpalKelly_1_1ScriptValue.html</anchorfile>
      <anchor>a510d320781fcb339dcd7438e7f0f3ac8</anchor>
      <arglist>(std::string *ps) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>GetAsBuffer</name>
      <anchorfile>classOpalKelly_1_1ScriptValue.html</anchorfile>
      <anchor>aaccd36eeb080675284d08541e65de7ee</anchor>
      <arglist>(Buffer *pbuf) const</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>OpalKelly::ScriptValues</name>
    <filename>classOpalKelly_1_1ScriptValues.html</filename>
    <member kind="function">
      <type></type>
      <name>ScriptValues</name>
      <anchorfile>classOpalKelly_1_1ScriptValues.html</anchorfile>
      <anchor>ab3a52225f960dd8bdb736f364e30df59</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>Clear</name>
      <anchorfile>classOpalKelly_1_1ScriptValues.html</anchorfile>
      <anchor>af7506da2db2f1252a6c003dd7c9f4f21</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>Add</name>
      <anchorfile>classOpalKelly_1_1ScriptValues.html</anchorfile>
      <anchor>ae4339b7bcbf3d428f15acd90d4698226</anchor>
      <arglist>(const ScriptValue &amp;value)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>Set</name>
      <anchorfile>classOpalKelly_1_1ScriptValues.html</anchorfile>
      <anchor>ad840948e99fe0fec98e25a289e3bd5ce</anchor>
      <arglist>(const ScriptValue &amp;value)</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetCount</name>
      <anchorfile>classOpalKelly_1_1ScriptValues.html</anchorfile>
      <anchor>a459e1d11907d39c4dfced960972fcabf</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>ScriptValue</type>
      <name>Get</name>
      <anchorfile>classOpalKelly_1_1ScriptValues.html</anchorfile>
      <anchor>a6b7c0d7def3abbc50ac76d40741b1c48</anchor>
      <arglist>(int n=0) const</arglist>
    </member>
  </compound>
  <compound kind="namespace">
    <name>OpalKelly</name>
    <filename>namespaceOpalKelly.html</filename>
    <class kind="class">OpalKelly::Buffer</class>
    <class kind="class">OpalKelly::FrontPanelDevices</class>
    <class kind="class">OpalKelly::FrontPanelManager</class>
    <class kind="class">OpalKelly::ProgressCallback</class>
    <class kind="class">OpalKelly::ScriptEngine</class>
    <class kind="class">OpalKelly::ScriptValue</class>
    <class kind="class">OpalKelly::ScriptValues</class>
    <member kind="typedef">
      <type>std::auto_ptr&lt; okCFrontPanel &gt;</type>
      <name>FrontPanelPtr</name>
      <anchorfile>namespaceOpalKelly.html</anchorfile>
      <anchor>aed5b6191f81ce1aacfeefddc19df3293</anchor>
      <arglist></arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetAPIVersionMajor</name>
      <anchorfile>namespaceOpalKelly.html</anchorfile>
      <anchor>a27d175286fd14d6fdc1a3e9d8e5c3210</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetAPIVersionMinor</name>
      <anchorfile>namespaceOpalKelly.html</anchorfile>
      <anchor>a714cdfa27993d84c3ed62fe01cb364e0</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetAPIVersionMicro</name>
      <anchorfile>namespaceOpalKelly.html</anchorfile>
      <anchor>a047105264b8ee48c8ab56d39958c6020</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const char *</type>
      <name>GetAPIVersionString</name>
      <anchorfile>namespaceOpalKelly.html</anchorfile>
      <anchor>a705299d3de48569b19af4d58c85d03bf</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>CheckAPIVersion</name>
      <anchorfile>namespaceOpalKelly.html</anchorfile>
      <anchor>a0663480683e198bcba8894dc5e831fc7</anchor>
      <arglist>(int major, int minor, int micro)</arglist>
    </member>
    <member kind="function">
      <type>FrontPanel::ErrorCode</type>
      <name>FrontPanelEmulateTestDeviceConnection</name>
      <anchorfile>namespaceOpalKelly.html</anchorfile>
      <anchor>a5cc2b4dcf3e756ba600ff3dcaf2d0f82</anchor>
      <arglist>(const std::string &amp;serial, bool connect)</arglist>
    </member>
  </compound>
  <compound kind="page">
    <name>migrate_fpdevices</name>
    <title>Switching to OpalKelly::FrontPanelDevices</title>
    <filename>migrate_fpdevices</filename>
  </compound>
  <compound kind="page">
    <name>index</name>
    <title>Overview</title>
    <filename>index</filename>
  </compound>
</tagfile>
