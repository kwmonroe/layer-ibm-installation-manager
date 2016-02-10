# IBM Installation Manager

This is a generic IBM Installation Manager (IBM IM) layer.  You can extend this layer to support any IBM software that can be installed with IBM IM.

## Usage

This layer is intended to be extended by other charms that would benefit from having IBM Installation Manager (IBM IM) preinstalled. For example, a WebSphere layered charm could include this layer so it could use IBM IM to install WebSphere.

To use this layer, include the following in your `layer.yaml`:

```yaml
includes: ['layer:ibm-installation-manager']
```

Then, in your charm, watch for the `im.installed` state, at which point you will know the IBM IM tools are available:

```bash
IM_PATH=/opt/IBM/InstallationManager

@when 'im.installed'
install_was() {
    WAS_REPO=`config-get was_repo`
    ${IM_PATH}/tools/imutilsc saveCredential -url $WAS_REPO -userName $IBM_ID_NAME -userPassword $IBM_ID_PASS -secureStorageFile "secure.store"
    ${IM_PATH}/installc -input silent-install.xml -acceptlicense -secureStorageFile "secure.store"
    ${IM_PATH}/imcl install $IM_ARGS
}
```

## Configuration

This layer currently supports the following configuration options:

**accept-ibm-im-license** - The IBM Installation Manager software comes with special terms and conditions from IBM. Set this value to “True” if you have read and accept the IBM Installation Manager license. The Installation Manager software can only be used if the license terms and conditions are accepted.

## IBM Installation Manager (IM) Information

(1) General Information
Details about IM available at [IBM Knowledge Center][IM-info].

(2) Download Information
Information on procuring IM product is available at the [Product Page][im-product-page]
and at the [Passport Advantage Site][Passport].

[IM-info]: http://www-01.ibm.com/support/knowledgecenter/SSDV2W/im_family_welcome.html
[im-product-page]: http://www-01.ibm.com/support/docview.wss?uid=swg27025142
[Passport]: http://www-01.ibm.com/software/passportadvantage/
