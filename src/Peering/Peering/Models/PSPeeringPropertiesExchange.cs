// <auto-generated>
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Microsoft.Azure.PowerShell.Cmdlets.Peering.Models
{
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// The properties that define an exchange peering.
    /// </summary>
    public partial class PSPeeringPropertiesExchange
    {
        /// <summary>
        /// Initializes a new instance of the PSPeeringPropertiesExchange
        /// class.
        /// </summary>
        public PSPeeringPropertiesExchange()
        {
            CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the PSPeeringPropertiesExchange
        /// class.
        /// </summary>
        /// <param name="connections">The set of connections that constitute an
        /// exchange peering.</param>
        /// <param name="peerAsn">The reference of the peer ASN.</param>
        public PSPeeringPropertiesExchange(IList<PSExchangeConnection> connections = default(IList<PSExchangeConnection>), PSSubResource peerAsn = default(PSSubResource))
        {
            Connections = connections;
            PeerAsn = peerAsn;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the set of connections that constitute an exchange
        /// peering.
        /// </summary>
        [JsonProperty(PropertyName = "connections")]
        public IList<PSExchangeConnection> Connections { get; set; }

        /// <summary>
        /// Gets or sets the reference of the peer ASN.
        /// </summary>
        [JsonProperty(PropertyName = "peerAsn")]
        public PSSubResource PeerAsn { get; set; }

    }
}
