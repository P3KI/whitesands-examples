# Smarthome Demo

In this example we'll look at a simplified smarthome example.

Three devices ('door', 'heater', 'light') trust their 'owner'.
Their identities are handled on the same instance for simplicity, but that makes no functional difference.

On another instance there's a 'friend' identity.

- Initially the friend is not trusted at all, so it's unable to interact with the devices.
- As a next step, the owner delegates control over the 'light' device to the friend (without telling the device itself!).
  Now 'friend' is able to interact with 'light' but not 'door' and 'heater'.
- In the final step 'owner' updates its delegation towards 'friend' to a general 'control' permission that includes all possible devices (again, without telling the devices).
  Now the friend is able to interact with all devices.
  We could even introduce new devices without having to update the delegation 'owner'->'friend', as long as the new devices trust 'owner'.


## Example runs

```
$ ./smarthome_handshake_v1.sh 
Whitesands URL: https://whitesands.p3ki.net
Whitesands User: p3ki
Whitesands instances: i1, i2, i3, i4, i5




-- ACT 0: Setup ------------------------------------------

# Querying required instances...

 Whitesands: Pong
      owner: i1, Pong
     friend: i2, Pong
global view: i3, Pong

# Resetting instances ...

all instances: "Instance reset executed:  "

# Creating identities...

 owner: "AAABQ5So4BH0VtDjOKT6WsDkVQ13zi3-grATQWO5AwWqiG4"
  door: "AAABr8TJBpZhwDYFWbXeDg2K-z0eM7qwwhxxH8twkdph7n0"
heater: "AAABblD2ew5ADL_w27JgoyvmEEdVy1f9MKaL9JRU9l-2WQk"
 light: "AAABEUhT5Jfxv31v2j7rZI6WqSLMj104lGRiuQMu3cWq2ts"
friend: "AAABILYYr6l6mjfxKuBufB94KlF-zJkNshnV21B9NFptObw"

# Requesting public keys...

 owner: AAABQ5So4BH0VtDjOKT6WsDkVQ13zi3-grATQWO5AwWqiG4
  door: AAABr8TJBpZhwDYFWbXeDg2K-z0eM7qwwhxxH8twkdph7n0
heater: AAABblD2ew5ADL_w27JgoyvmEEdVy1f9MKaL9JRU9l-2WQk
 light: AAABEUhT5Jfxv31v2j7rZI6WqSLMj104lGRiuQMu3cWq2ts
friend: AAABILYYr6l6mjfxKuBufB94KlF-zJkNshnV21B9NFptObw





-- ACT 1: Devices that trust -----------------------------

# Setting devices to trust owner...

Note: for sake of simplification, we're using unlimited
      validity. You should not do that in production.

   door trust owner: "Success"
  light trust owner: "Success"
heater trusts owner: "Success"

# Listing relationships...

  door->owner: [{"target":"AAABQ5So4BH0VtDjOKT6WsDkVQ13zi3-grATQWO5AwWqiG4","policy":"action:{control.door}"}]
 light->owner: [{"target":"AAABQ5So4BH0VtDjOKT6WsDkVQ13zi3-grATQWO5AwWqiG4","policy":"action:{control.light}"}]
heater->owner: [{"target":"AAABQ5So4BH0VtDjOKT6WsDkVQ13zi3-grATQWO5AwWqiG4","policy":"action:{control.heating}"}]

# Exporting delegation certificates...

  door->owner: ZDI6aHRkODpTSEEyXzI1NmQzMjp0uxKII0ogyBwszG1N1VAn6H3yGMENGp9hha7BZGi6fzgxOmQzOmtleTM1OgAAAUOUqOAR9FbQ4zik-lrA5FUNd84t_oKwE0FjuQMFqohuNTp2YWx1ZWQxOnYyMTphY3Rpb246e2NvbnRyb2wuZG9vcn1lZWVlNTpyb290c2xkMTA6cHVibGljX2tleTM1OgAAAa_EyQaWYcA2BVm13g4Nivs9HjO6sMIccR_LcJHaYe59OTpzaWduYXR1cmUxMzQ6TRUvoV7qkqjPT3g57gDU7WUaopMxY5ouI3UYc4mRR3rdRqmIA84CDyzZOtOXLL1thgWsO2HkwBL2ZqFxi0UpBmQxOmNpMTYwNTEwMDQwNzcxOGUxOnJkODpTSEEyXzI1NjMyOnS7EogjSiDIHCzMbU3VUCfoffIYwQ0an2GFrsFkaLp_ZWVlZWU
 light->owner: ZDI6aHRkODpTSEEyXzI1NmQzMjrAi7AJdR5wyRwXgUr-_-DzYHzZxHLbcJM5V07n7FSE2TgyOmQzOmtleTM1OgAAAUOUqOAR9FbQ4zik-lrA5FUNd84t_oKwE0FjuQMFqohuNTp2YWx1ZWQxOnYyMjphY3Rpb246e2NvbnRyb2wubGlnaHR9ZWVlZTU6cm9vdHNsZDEwOnB1YmxpY19rZXkzNToAAAERSFPkl_G_fW_aPutkjpapIsyPXTiUZGK5Ay7dxara2zk6c2lnbmF0dXJlMTM0Oly2tAtG-lqqifLTSM1T_8d6q3G2dkj347THy_DbpVQRi3NCRz8pEP6ig2uIJn0HVcdqSOubReBVZmcjgJMwHAFkMTpjaTE2MDUxMDA0MDc4NzhlMTpyZDg6U0hBMl8yNTYzMjrAi7AJdR5wyRwXgUr-_-DzYHzZxHLbcJM5V07n7FSE2WVlZWVl
heater->owner: ZDI6aHRkODpTSEEyXzI1NmQzMjqs3PXGT1LIw1LPag7VJ8qDnbxf44yfihM1lKtx5We--Tg0OmQzOmtleTM1OgAAAUOUqOAR9FbQ4zik-lrA5FUNd84t_oKwE0FjuQMFqohuNTp2YWx1ZWQxOnYyNDphY3Rpb246e2NvbnRyb2wuaGVhdGluZ31lZWVlNTpyb290c2xkMTA6cHVibGljX2tleTM1OgAAAW5Q9nsOQAy_8NuyYKMr5hBHVctX_TCmi_SUVPZftlkJOTpzaWduYXR1cmUxMzQ6TynJ-_NV2dJxHj0MDB08kGHgsTjLtsrYFHP1bNBYDVyTgpCfwq3niu9Ps0a8enIu7PJSsfNIgwga5yW1pVFCCWQxOmNpMTYwNTEwMDQwODA0MGUxOnJkODpTSEEyXzI1NjMyOqzc9cZPUsjDUs9qDtUnyoOdvF_jjJ-KEzWUq3HlZ775ZWVlZWU

# Verifying trust between devices and owner...

   owner can control door?: {"success":true,"policy":"action:{control.door}"}
  owner can control light?: {"success":true,"policy":"action:{control.light}"}
 owner can control heater?: {"success":true,"policy":"action:{control.heating}"}

# Verifying trust between devices and friend...

Note: the friend has no access, so everything should fail.
Note: we actually will not reach the point where we can verify
      the handshake, rather we already fail at creating a response.

  friend can control door?: No trust path found
 friend can control light?: No trust path found
friend can control heater?: No trust path found




-- ACT 2: Delegating some --------------------------------

# Owner delegates PARTIAL control...

door trust friend with light: "Success"

# Listing relationships of owner...

owner->friend: [{"target":"AAABILYYr6l6mjfxKuBufB94KlF-zJkNshnV21B9NFptObw","policy":"action:{control.light}"}]

# Exporting owner delegation certificates...

owner->friend: ZDI6aHRkODpTSEEyXzI1NmQzMjpo-sBmiaxer550Gsno6fcb4i26Tz4ipcNs7AsHCHvVWTgyOmQzOmtleTM1OgAAASC2GK-pepo38SrgbnwfeCpRfsyZDbIZ1dtQfTRabTm8NTp2YWx1ZWQxOnYyMjphY3Rpb246e2NvbnRyb2wubGlnaHR9ZWVlZTU6cm9vdHNsZDEwOnB1YmxpY19rZXkzNToAAAFDlKjgEfRW0OM4pPpawORVDXfOLf6CsBNBY7kDBaqIbjk6c2lnbmF0dXJlMTM0OmTDEHbsb9GJxQcskSEV3VGGGYR21m0fnOgVf_OUvT7DmJfNphhNgYOHpDA4h3LyJYVwmQU_qPOW4-qShbOxrwpkMTpjaTE2MDUxMDA0MTA2NzdlMTpyZDg6U0hBMl8yNTYzMjpo-sBmiaxer550Gsno6fcb4i26Tz4ipcNs7AsHCHvVWWVlZWVl

# Verifying trust between devices and friend...

Note: With the additional delegation of the owner
      the friend is now able to control the light.
      But _only_ the light.

  friend response to door challenge: No trust path found
 friend response to light challenge: ZDEwOnB1YmxpY19rZXkzNToAAAEgthivqXqaN_Eq4G58H3gqUX7MmQ2yGdXbUH00Wm05vDk6c2lnbmF0dXJlODg2Otz-YJp2OSfwlqrppRW4Wb8xYqqapdTNq6MHX1PTO8Gefd4YW8c_1FhO-N9k3qrSj6lkRRdAzE3jm9JbG7DFnQFkMTohZDI6aHRkODpTSEEyXzI1NmQzMjpo-sBmiaxer550Gsno6fcb4i26Tz4ipcNs7AsHCHvVWTgyOmQzOmtleTM1OgAAASC2GK-pepo38SrgbnwfeCpRfsyZDbIZ1dtQfTRabTm8NTp2YWx1ZWQxOnYyMjphY3Rpb246e2NvbnRyb2wubGlnaHR9ZWUzMjrAi7AJdR5wyRwXgUr-_-DzYHzZxHLbcJM5V07n7FSE2TgyOmQzOmtleTM1OgAAAUOUqOAR9FbQ4zik-lrA5FUNd84t_oKwE0FjuQMFqohuNTp2YWx1ZWQxOnYyMjphY3Rpb246e2NvbnRyb2wubGlnaHR9ZWVlZTU6cm9vdHNsZDEwOnB1YmxpY19rZXkzNToAAAFDlKjgEfRW0OM4pPpawORVDXfOLf6CsBNBY7kDBaqIbjk6c2lnbmF0dXJlMTM0OmTDEHbsb9GJxQcskSEV3VGGGYR21m0fnOgVf_OUvT7DmJfNphhNgYOHpDA4h3LyJYVwmQU_qPOW4-qShbOxrwpkMTpjaTE2MDUxMDA0MTA2NzdlMTpyZDg6U0hBMl8yNTYzMjpo-sBmiaxer550Gsno6fcb4i26Tz4ipcNs7AsHCHvVWWVlZWQxMDpwdWJsaWNfa2V5MzU6AAABEUhT5Jfxv31v2j7rZI6WqSLMj104lGRiuQMu3cWq2ts5OnNpZ25hdHVyZTEzNDpctrQLRvpaqony00jNU__HeqtxtnZI9-O0x8vw26VUEYtzQkc_KRD-ooNriCZ9B1XHakjrm0XgVWZnI4CTMBwBZDE6Y2kxNjA1MTAwNDA3ODc4ZTE6cmQ4OlNIQTJfMjU2MzI6wIuwCXUecMkcF4FK_v_g82B82cRy23CTOVdO5-xUhNllZWVlZTE6JDE5OmFjdGlvbjp0ZG5zKGF0b21pYykxOjoxNjpHoi9dij14FE1TPM4sSy-5MTo9MjI6YWN0aW9uOntjb250cm9sLmxpZ2h0fTE6PjIyOmFjdGlvbjp7Y29udHJvbC5saWdodH0xOkAzNToAAAERSFPkl_G_fW_aPutkjpapIsyPXTiUZGK5Ay7dxara22Vl
friend response to heater challenge: No trust path found

Note: at this point, it only makes sense to proceed with the verification for light.

friend can control light?: {"success":true,"policy":"action:{control.light}"}





-- ACT 3: Delegating all ---------------------------------

# Owner delegates FULL control...

door trust friend with light: "Success"

# Listing relationships of owner...

owner->friend: [{"target":"AAABILYYr6l6mjfxKuBufB94KlF-zJkNshnV21B9NFptObw","policy":"action:{control}"}]

# Exporting owner delegation certificates...

owner->friend: ZDI6aHRkODpTSEEyXzI1NmQzMjpBrBL32Naw8DXxcPbIX7chN3Eeru1qIcV32t-j2BjJgDc2OmQzOmtleTM1OgAAASC2GK-pepo38SrgbnwfeCpRfsyZDbIZ1dtQfTRabTm8NTp2YWx1ZWQxOnYxNjphY3Rpb246e2NvbnRyb2x9ZWVlZTU6cm9vdHNsZDEwOnB1YmxpY19rZXkzNToAAAFDlKjgEfRW0OM4pPpawORVDXfOLf6CsBNBY7kDBaqIbjk6c2lnbmF0dXJlMTM0OjV_bjRFfXE4y3cnL_NjDec889mGpzpXkWrtJT29HcIbAgrukJi4GDv1E6huLeeVsk_ZJqXelhgHcvoh0KmZogRkMTpjaTE2MDUxMDA0MTIwMTBlMTpyZDg6U0hBMl8yNTYzMjpBrBL32Naw8DXxcPbIX7chN3Eeru1qIcV32t-j2BjJgGVlZWVl

# Verifying trust between devices and friend...

Note: With the broader delegation of the owner
      the friend is now able to control all devices.
      And do so with a single delegation.

  friend can control door?: {"success":true,"policy":"action:{control.door}"}
 friend can control light?: {"success":true,"policy":"action:{control.light}"}
friend can control heater?: {"success":true,"policy":"action:{control.heating}"}

```
